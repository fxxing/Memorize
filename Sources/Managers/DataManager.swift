//
//  DataManager.swift
//  Memorize
//
//  Created by Fengxiang Xing on 2/5/16.
//  Copyright © 2016 Fengxiang Xing. All rights reserved.
//

import Foundation

class DataManager {
    static let LIST_PER_DAY = 2
    static let WORD_PER_LIST = 100
    private static let instance = DataManager()
    private var today = 0
    private init() {
        let dbPath = NSHomeDirectory().stringByAppendingString("/Documents/data.db")
        let fm = NSFileManager.defaultManager()
        if !fm.fileExistsAtPath(dbPath) {
            let srcPath = NSBundle.mainBundle().pathForResource("data", ofType: "db")
            do {
                try fm.copyItemAtPath(srcPath!, toPath: dbPath)
            } catch {
            }
        }

        self.today = NSUserDefaults.standardUserDefaults().integerForKey("date")
    }

    class func sharedInstance() -> DataManager {
        return instance;
    }

    func importLists() -> Int {
        var lastList = 0
        let db = SQLiteDB.sharedInstance()
        let rows = db.query("SELECT MAX(`list`) AS `last_list` FROM `word`")
        if rows[0]["last_list"] != nil {
            lastList = rows[0]["last_list"] as! Int
        }

        var list = lastList + 1
        var word = 0
        var count = 0
        let fm = NSFileManager.defaultManager()
        let docDir = NSHomeDirectory().stringByAppendingString("/Documents/")
        for path in fm.subpathsAtPath(docDir)! {
            if path.hasSuffix(".json") {
                let words = try? NSJSONSerialization.JSONObjectWithData(NSData.dataWithContentsOfMappedFile(docDir.stringByAppendingString(path)) as! NSData, options: NSJSONReadingOptions()) as! [AnyObject]
//                if words!.count % DataManager.WORD_PER_LIST != 0 {
//                    continue
//                }
                for dict in words! {
                    let wordObj = dict as! [String:String]
                    let result = db.execute("INSERT INTO `word`(`kana`,`japanese`,`part_of_speech`,`chinese`,`sound`,`list`) values (?,?,?,?,?,?)",
                            parameters: [wordObj["kana"]!, wordObj["japanese"]!, wordObj["part_of_speech"]!, wordObj["chinese"]!, wordObj["sound"]!, list])
                    if result > 0 {
                        count += 1
                        word += 1
                        if word >= DataManager.WORD_PER_LIST {
                            word = 0
                            list += 1
                        }
                    }
                }
                do {
                    try fm.removeItemAtPath(docDir.stringByAppendingString(path))
                } catch {
                }
            }
        }

        return count
    }

    func deleteLists() {
        SQLiteDB.sharedInstance().execute("DELETE FROM `word`")
    }

    func getTasks() -> Array<Task> {
        var tasks = self.getLearnTasks()
        tasks.appendContentsOf(self.getReviewTasks())
        return tasks
    }

    private func getLearnTasks() -> Array<Task> {
        let db = SQLiteDB.sharedInstance()
        let rows = db.query("SELECT MAX(`list`) AS `last_list` FROM `learned` WHERE `date`<? AND `review`=0", parameters: [today])
        var lastList = 0
        if rows[0]["last_list"] != nil {
            lastList = rows[0]["last_list"] as! Int
        }
        let todayLearnedLists = db.query("SELECT `list` FROM `learned` WHERE `date`=? AND `review`=0", parameters: [today]).map({ $0["list"] as! Int })
        let todayLists = Array((lastList + 1) ... (lastList + DataManager.LIST_PER_DAY))
        var tasks = Array<Task>()
        for row in db.query("SELECT DISTINCT `list` FROM `word` WHERE `list` IN (" + Array(count: todayLists.count, repeatedValue: "?").joinWithSeparator(",") + ") ORDER BY `list`", parameters: todayLists) {
            let task = Task()
            task.type = TaskType.Learn
            task.list = row["list"] as! Int
            task.done = todayLearnedLists.contains(task.list)
            tasks.append(task)
        }
        return tasks
    }

    private func getReviewTasks() -> Array<Task> {
        let db = SQLiteDB.sharedInstance()
        let todayReviewedLists = db.query("SELECT `list` FROM `learned` WHERE `date`=? AND `review`=1", parameters: [today]).map({ $0["list"] as! Int })
        var tasks = Array<Task>()

        let dates = [30, 15, 7, 4, 2, 1].map({ today - $0 }).filter({ $0 >= 0 })
        if dates.count > 0 {
            let sql = "SELECT DISTINCT `list` FROM `learned` WHERE `review`=0 AND `date` IN (" + Array(count: dates.count, repeatedValue: "?").joinWithSeparator(",") + ") ORDER BY `list`"
            for row in db.query(sql, parameters: dates) {
                let task = Task()
                task.list = row["list"] as! Int
                task.type = TaskType.Review
                task.done = todayReviewedLists.contains(task.list)
                tasks.append(task)
            }
        }

        var learnTasks = getLearnTasks()
        for task in learnTasks {
            task.type = TaskType.ReviewToday
            task.done = todayReviewedLists.contains(task.list)
        }
        if learnTasks.count >= 2 {
            // move first list to last to prevent proactive interference and retroactive interference
            let first = learnTasks.first!
            learnTasks.removeAtIndex(0)
            learnTasks.append(first)
        }
        tasks.appendContentsOf(learnTasks)


        if tasks.count > 0 {
            let sql = "SELECT `list`, COUNT(1) AS `count` FROM `learned` WHERE `list` IN(" + Array(count: tasks.count, repeatedValue: "?").joinWithSeparator(",") + ")  GROUP BY `list`"
            var listCounts = [Int: Int]()
            for row in db.query(sql, parameters: tasks.map({ $0.list })) {
                listCounts[row["list"] as! Int] = row["count"] as? Int
            }
            for task in tasks {
                task.count = listCounts[task.list] == nil ? 0 : listCounts[task.list]!
            }
        }

        return tasks
    }

    func getWordsInList(list: Int) -> Array<Word> {
        var words = Array<Word>()
        for row in SQLiteDB.sharedInstance().query("SELECT * FROM `word` WHERE `list`=?", parameters: [list]) {
            let word = Word()
            word.kana = row["kana"] as? String
            word.japanese = row["japanese"] as? String
            word.partOfSpeech = row["part_of_speech"] as? String
            word.chinese = row["chinese"] as? String
            word.sound = row["sound"] as? String

            if word.japanese == "" {
                word.japanese = word.kana
            }
            words.append(word)
        }
        return words

    }

    func recordLearned(list: Int) {
        SQLiteDB.sharedInstance().execute("INSERT INTO `learned`(`list`, `date`, `review`) VALUES (?, ?, 0)", parameters: [list, today])
    }

    func recordReviewed(list: Int) {
        SQLiteDB.sharedInstance().execute("INSERT INTO `learned`(`list`, `date`, `review`) VALUES (?, ?, 1)", parameters: [list, today])
    }

    func nextDay() {
        self.today += 1
        let userDefautls = NSUserDefaults.standardUserDefaults()
        userDefautls.setInteger(self.today, forKey: "date")
        userDefautls.synchronize()
    }
}
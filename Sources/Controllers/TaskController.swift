//
//  ViewController.swift
//  Memorize
//
//  Created by Fengxiang Xing on 2/4/16.
//  Copyright © 2016 Fengxiang Xing. All rights reserved.
//

import UIKit

@objc class TaskController: BaseCotroller, SWTableViewCellDelegate {
    
    @IBOutlet var tableView: UITableView?
    var tasks: Array<Task>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TaskCell", bundle: nil)
        self.tableView!.registerNib(nib, forCellReuseIdentifier: "taskCell")
        
        self.tasks = DataManager.sharedInstance().getTasks()
        
        self.tableView!.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView!.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks == nil ? 0 : self.tasks!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("taskCell") as! TaskCell
        let task = self.tasks![indexPath.row]
        cell.countLabel!.text = "\(task.count)"
        cell.taskLabel!.text = "List \(task.list)"
        cell.rightUtilityButtons = self.rightButtons()
        if task.done {
            cell.countLabel!.backgroundColor = UIColor.fromHex(0xdce0e0)
            let attributedText = NSMutableAttributedString(string: "List \(task.list)", attributes: [NSStrikethroughColorAttributeName: UIColor.fromHex(0xdce0e0), NSForegroundColorAttributeName:UIColor.fromHex(0xdce0e0)])
            attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributedText.length))
            cell.taskLabel!.attributedText = attributedText
        } else if task.type == TaskType.Learn {
            cell.countLabel?.backgroundColor = UIColor.fromHex(0xf2613d)
        } else if task.type == TaskType.Review {
            cell.countLabel?.backgroundColor = UIColor.fromHex(0x93c251)
        } else if task.type == TaskType.ReviewToday {
            cell.countLabel?.backgroundColor = UIColor.fromHex(0xd59322)
        }
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.startLearn(self.tasks![indexPath.row], mode: WordMode.Learn)
    }
    
    func swipeableTableViewCell(cell:SWTableViewCell, didTriggerRightUtilityButtonWithIndex index:Int) {
        if index == 0 {
            self.startLearn(self.tasks![(cell as! TaskCell).index!], mode: WordMode.Dictate)
        } else {
            self.startLearn(self.tasks![(cell as! TaskCell).index!], mode: WordMode.Translate)
        }
    }
    
    func startLearn(task: Task, mode: WordMode) {
        let wordController = WordController()
        wordController.task = task
        wordController.mode = mode
        self.navigationController?.pushViewController(wordController, animated: true)
    }
    
    func rightButtons() -> [AnyObject] {
        let dictateButton = UIButton(type: UIButtonType.Custom)
        dictateButton.backgroundColor = UIColor.fromHex(0xa1abab)
        dictateButton.setTitle("Dictate", forState: UIControlState.Normal)
        dictateButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        dictateButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let translateButton = UIButton(type: UIButtonType.Custom)
        translateButton.backgroundColor = UIColor.fromHex(0xa1abab)
        translateButton.setTitle("Test", forState: UIControlState.Normal)
        translateButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        translateButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        return [dictateButton, translateButton]
    }
    
    @IBAction func done() {
        DataManager.sharedInstance().nextDay()
        self.tasks = DataManager.sharedInstance().getTasks()
        self.tableView!.reloadData()
    }
    
    @IBAction func settings() {
        self.navigationController?.pushViewController(SettingsController(), animated: true)
    }

}


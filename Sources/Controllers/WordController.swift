//
//  ViewController.swift
//  Memorize
//
//  Created by Fengxiang Xing on 2/4/16.
//  Copyright © 2016 Fengxiang Xing. All rights reserved.
//

import UIKit


enum WordMode {
    case Learn
    case Dictate
    case Translate
}


@objc class WordController: BaseCotroller {
    
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var countLabel: UILabel?
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var prevButton: UIButton?
    @IBOutlet var nextButton: UIButton?
    
    var wordView: WordView?
    var mode = WordMode.Learn
    var task: Task?
    var words: Array<Word>?
    var wordCount = 0
    var wordIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.words = DataManager.sharedInstance().getWordsInList(self.task!.list)
        self.wordCount = self.words!.count
        if self.words!.count == 0 {
            self.back()
            return
        }
        switch self.mode {
        case .Learn:
            self.wordView = LearnView.fromNib("LearnView")
            self.titleLabel!.text = "Learn List \(self.task!.list)"
        case .Dictate:
            self.wordView = DictateView.fromNib("DictateView")
            self.titleLabel!.text = "Dictate List \(self.task!.list)"
        case .Translate:
            self.wordView = TranslateView.fromNib("TranslateView")
            self.titleLabel!.text = "Test List \(self.task!.list)"
        }
        
        self.scrollView!.addSubview(self.wordView!)
        self.scrollView?.contentSize = self.wordView!.bounds.size
        
        self.next()
    }
    
    func showWord(i: Int) {
        if i >= 0 && i < self.wordCount {
            self.prevButton!.hidden = i == 0
            self.nextButton?.setTitle(i == self.wordCount - 1 ? "Done" : "Next", forState: UIControlState.Normal)
            self.wordView!.word = self.words![i]
            self.wordIndex = i
            
            self.countLabel!.text = "\(i + 1)/\(self.wordCount)";
        }
    }

    @IBAction func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func prev() {
        self.showWord(self.wordIndex - 1)
    }
    
    @IBAction func next() {
        if self.wordIndex == self.wordCount - 1 {
            self.task!.done = true
            if self.task!.type == TaskType.Learn {
                DataManager.sharedInstance().recordLearned(self.task!.list)
            } else {
                DataManager.sharedInstance().recordReviewed(self.task!.list)
            }
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            self.showWord(self.wordIndex + 1)
        }
    }
}


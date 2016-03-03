//
//  WordView.swift
//  Memorize
//
//  Created by Fengxiang Xing on 2/9/16.
//  Copyright © 2016 Fengxiang Xing. All rights reserved.
//

import Foundation
import AVFoundation

@objc class WordView: UIView {
    static var SPACING: CGFloat = 8
    static var MIN_LABEL_HEIGHT: CGFloat = 40
    @IBOutlet var japaneseLabel: UILabel?
    @IBOutlet var partOfSpeechLabel: UILabel?
    @IBOutlet var kanaLabel: UILabel?
    @IBOutlet var chineseLabel: UILabel?
    @IBOutlet var speakButton: UIButton?
    var answerShown = false
    var audioPlayer: AVAudioPlayer?
    
    var word: Word? {
        didSet {
            if self.japaneseLabel != nil {
                self.japaneseLabel!.text = word?.japanese
            }
            if self.partOfSpeechLabel != nil {
                self.partOfSpeechLabel!.text = word?.partOfSpeech
            }
            if self.kanaLabel != nil {
                self.kanaLabel!.text = word?.kana
            }
            if self.chineseLabel != nil {
                self.chineseLabel!.text = word?.chinese
            }
            self.answerShown = false
            self.layout()
            self.didSetWord()
        }
    }
    
    override func awakeFromNib() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Fail to init audio")
        }
    }
    
    func didSetWord() {
        
    }
    
    func layoutLabel(label: UILabel, atY: CGFloat) -> CGFloat {
        let constrainedSize = CGSizeMake(self.chineseLabel!.frame.size.width, CGFloat.max)
        let size = label.text!.boundingRectWithSize(constrainedSize, options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil).size as CGSize
        var f = label.frame
        f.origin.y = atY
        f.size.height = size.height < WordView.MIN_LABEL_HEIGHT ? WordView.MIN_LABEL_HEIGHT : size.height
        label.frame = f
        return atY + f.size.height + WordView.SPACING
    }
    
    func layout() {
    }
    
    @IBAction func speak() {
        if self.audioPlayer != nil {
            self.audioPlayer!.stop()
        }
        
        let path = NSHomeDirectory().stringByAppendingString("/Documents/").stringByAppendingString(self.word!.sound!)
        if !path.hasSuffix(".mp3") {
            return
        }
        if !NSFileManager.defaultManager().fileExistsAtPath(path) {
            return
        }
        self.audioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path))
        self.audioPlayer!.prepareToPlay()
        self.audioPlayer!.play()
    }
    
    @IBAction func showAnswer() {
        self.answerShown = true
        self.layout()
    }
}
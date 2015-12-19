//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Kath Faulkner on 16/12/2015.
//  Copyright © 2015 T3D. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var charChangeBtn: UIButton!
    @IBOutlet weak var charChangeLbl: UILabel!
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var groundImg: UIImageView!
    @IBOutlet weak var charSelectBtn: UIButton!
    @IBOutlet weak var charSelectLbl: UILabel!
    @IBOutlet weak var selectionImg: MonsterImg!
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var needStack: UIStackView!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var whistleImg: DragImg!
    @IBOutlet weak var livesPanelImg: UIImageView!
    @IBOutlet weak var penalityStack: UIStackView!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var restartLbl: UILabel!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalities = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxWhistle: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        whistleImg.dropTarget = monsterImg
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            try sfxWhistle = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("whistle", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxWhistle.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        setBackgroundImages()
        selectionImg.playWalkAnimation()
    }
    
    @IBAction func onRestartPress(sender: AnyObject) {
        gameStart()
    }
    
    
    @IBAction func onCharacterChange(sender: AnyObject) {
        
        if monsterImg.assignedCharacter >= monsterImg.characters.count - 1 {
            monsterImg.assignedCharacter = 0
        } else {
            monsterImg.assignedCharacter++
        }
        
        setBackgroundImages()
        selectionImg.assignedCharacter = monsterImg.assignedCharacter
        selectionImg.playWalkAnimation()
    }
    @IBAction func onCharacterSelect(sender: AnyObject) {
        gameStart()
    }
    
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        whistleImg.alpha = DIM_ALPHA
        whistleImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else if currentItem == 1 {
            sfxBite.play()
        } else {
            sfxWhistle.play()
        }
    }
    
    func gameStart() {
        charChangeBtn.hidden = true
        charChangeLbl.hidden = true
        charSelectBtn.hidden = true
        charSelectLbl.hidden = true
        selectionImg.hidden = true
        restartBtn.hidden = true
        restartLbl.hidden = true
        monsterImg.hidden = false
        needStack.hidden = false
        livesPanelImg.hidden = false
        penalityStack.hidden = false
        
        penalities = 0
        monsterHappy = false
        currentItem = 0
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        selectMonsterNeed()
        
        startTimer()
        monsterImg.playIdleAnimation()
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            
            penalities++
            sfxSkull.play()
            
            if penalities == 1 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            } else if penalities == 2 {
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
            } else if penalities >= 3 {
                penalty3Img.alpha = OPAQUE
            } else {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            }
            
            if penalities >= MAX_PENALTIES {
                gameOver()
            }
        
        } else {
            
            selectMonsterNeed()
            monsterHappy = false
        }
    }
    
    func selectMonsterNeed() {
        let rand = arc4random_uniform(3)
        
        if rand == 0 {
            
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            whistleImg.alpha = DIM_ALPHA
            whistleImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else if rand == 1 {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            whistleImg.alpha = DIM_ALPHA
            whistleImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        } else {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            whistleImg.alpha = OPAQUE
            whistleImg.userInteractionEnabled = true
        }
        
        currentItem = rand
    }
    
    func gameOver() {
        sfxDeath.play()
        timer.invalidate()
        monsterImg.playDeathAnimation()
        
        restartBtn.hidden = false
        restartLbl.hidden = false
    }
    
    func setBackgroundImages() {
        if monsterImg.assignedCharacter == 0 {
            groundImg.image = UIImage(named: "grassyground.png")
            bgImg.image = UIImage(named: "altbg")
        } else {
            groundImg.image = UIImage(named: "ground.png")
            bgImg.image = UIImage(named: "bg.png")
        }
    }
    

}


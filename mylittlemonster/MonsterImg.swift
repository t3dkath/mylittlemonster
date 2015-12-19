//
//  MonsterImg.swift
//  mylittlemonster
//
//  Created by Kath Faulkner on 18/12/2015.
//  Copyright © 2015 T3D. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
    
    var characters = ["Miner", "Rockman"]
    var assignedCharacter: Int = 0
    var imgCharacterSet: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func playIdleAnimation() {
        playAnimation("idle", initImgNum: 1, numOfImages: 4)
    }
    func playWalkAnimation() {
        playAnimation("walk", initImgNum: 1, numOfImages: 9)
    }
    func playDeathAnimation() {
        playAnimation("dead", initImgNum: 5, numOfImages: 5, repeatCount: 1)
    }
    
    func playAnimation(imgSet: String, initImgNum: Int, numOfImages: Int, repeatCount: Int = 0, aniDuration: Double = 0.8, imgExtention: String = ".png") {
        
        imgCharacterSet = "\(characters[assignedCharacter])-\(imgSet)"
        
        self.image = UIImage(named: "\(imgCharacterSet)\(initImgNum)\(imgExtention)")
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        
        for var x = 1; x <= numOfImages; x++ {
            let img = UIImage(named: "\(imgCharacterSet)\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = aniDuration
        self.animationRepeatCount = repeatCount
        self.startAnimating()
        
    }
    
    
}
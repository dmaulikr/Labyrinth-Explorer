//
//  LevelStatus.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 3/29/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class LevelStatus: SKScene {
    init(size: CGSize, won:Bool, nextLevel:MainScene) {
        
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
        let message = won ? "You Won!" : "You Lose :["
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        /*if won {
            runAction(SKAction.sequence([SKAction.waitForDuration(3.0),SKAction.runBlock() {
                
                let reveal = SKTransition.doorsCloseHorizontalWithDuration(0.5)
                
                let gameviewcontroller = GameViewController()
                
                gameviewcontroller.skView?.presentScene(nextLevel, transition: reveal)
                self.removeFromParent()
                
                }
                
                ]))
        }*/
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

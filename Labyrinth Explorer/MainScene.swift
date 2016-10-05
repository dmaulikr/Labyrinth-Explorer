//
//  JoystickManager.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 3/30/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class MainScene: SKScene, SKPhysicsContactDelegate {
    
    func loadWorld() {}
    
    func turnOnSlowMotion(recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Began {
            var location:CGPoint = recognizer.locationInView(recognizer.view)
            location = GameScene.sceneView!.convertPointFromView(location)
            let touchedNode:SKNode = GameScene.sceneView!.nodeAtPoint(location)
            if touchedNode.name == "MoveJoystick" {
                moveJoystick.endControl()
                if !slowModeActivated {
                    changeTextureForJoystick(spriteNode:moveJoystick.innerControl, imageName:"slowInner.png", inner:true)
                    changeTextureForJoystick(spriteNode:moveJoystick.outerControl, imageName:"slowOuter.png", inner:false)
                    
                }
                else {
                    changeTextureForJoystick(spriteNode:moveJoystick.innerControl, imageName:"inner.png", inner:true)
                    changeTextureForJoystick(spriteNode:moveJoystick.outerControl, imageName:"outer.png", inner:false)
                    
                }
            }
        }
    }
    
    func changeTextureForJoystick(spriteNode spriteNode:SKSpriteNode, imageName:String, inner:Bool) {
        spriteNode.runAction(SKAction.fadeAlphaTo(1, duration: 1), completion: {
            spriteNode.runAction(SKAction.setTexture(SKTexture(imageNamed:imageName)))
            if inner {
                spriteNode.runAction(SKAction.fadeAlphaTo(0.5, duration: 1))
            }
            else {
                spriteNode.runAction(SKAction.fadeAlphaTo(0.25, duration: 1))
            }
            
            if !inner && imageName == "outer.png" {
                slowModeActivated = false
                moveJoystick.speed = moveJoystickDefaultSpeed
            }
            else if !inner && imageName == "slowOuter.png"  {
                slowModeActivated = true
                moveJoystick.speed = 4
            }
            
        })
    }
    
    override func update(currentTime: NSTimeInterval) {
        if paused {
            lastUpdateTimeInterval = currentTime
            
            return
        }
        
        var timeSinceLast = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        if timeSinceLast > 1 {
            timeSinceLast = GameScene.minimumUpdateInterval
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLast)
        
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLast: NSTimeInterval) {}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            gameConstantProperties.eventIsOnProcess(touch , event: 0)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            gameConstantProperties.eventIsOnProcess(touch , event: 1)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            gameConstantProperties.eventIsOnProcess(touch , event: 2)
        }
    }
    
}

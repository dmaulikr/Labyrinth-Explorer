//
//  RonCharacter.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 3/5/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

final class RonCharacter: GameCharacter, SharedAssetProvider {
    
    var isLeaning = false
    var livesCount:Int = 1
    var heroIsHidden = false
    var isDetected = false
    var invincible = false
    var lockTouchActions = false
    
    enum FaceDirection {
        case Top, Bottom, Right, Left
    }
    
    var direction:FaceDirection = .Top
    // MARK: Initializers
    
    convenience init(atPosition position: CGPoint) {
        let atlas = SKTextureAtlas(named: "Ron_Idle")
        let ronTexture = atlas.textureNamed("ron_idle_0001.png")
        self.init(texture: ronTexture, atPosition: position)
        size = CGSizeMake(200, 200)
        animationSpeed = 1/30
        zPosition = 5
        movementSpeed = 0
    }
    
    override func controlLivesCount(decrease decrease:Bool, count:Int) {
        if decrease {
            if livesCount != 0 {
                
                if !invincible {
                    
                    invincible = true
                    
                    let remainingLivesCount = livesCount - count
                    
                    if remainingLivesCount == 0 {
                        moveJoystick.endControl()
                        isDying = true
                        physicsBody?.dynamic = false
                        for lifeHud in livesHud.children {
                            lifeHud.runAction(SKAction.setTexture(SKTexture(imageNamed: "LifeIsNull.png")))
                        }
                        runAction(SKAction.sequence([
                            SKAction.waitForDuration(1.6)
                            ]), completion: {
                                checkLevelStatus(won:false, nextLevel:MainScene())
                        })
                    }
                    else {
                        for var i=livesCount-1;i>=livesCount-count;i-- {
                            livesHud.children[i].runAction(SKAction.sequence([SKAction.fadeAlphaTo(0.25, duration: 3.0), SKAction.setTexture(SKTexture(imageNamed: "LifeIsNull.png")), SKAction.fadeAlphaTo(1.0, duration: 0)]))
                        }
                        
                        runAction(SKAction.repeatAction(SKAction.sequence([SKAction.fadeAlphaTo(0.5, duration: 0.25), SKAction.fadeAlphaTo(1, duration: 0.25)]) , count: 5), completion:{
                            self.invincible = false
                        })
                        
                        characterHurts = true
                        runAction(SKAction.waitForDuration(1.3),completion:{
                            self.characterHurts = false
                        })
                    }
                    
                    livesCount-=count
                    
                }
            }
        }
    }
    
    override func collidedWith(other: SKPhysicsBody) {
        if other.categoryBitMask & PhysicsCategory.Enemy == 0 {
            return
        }
        
        if other.categoryBitMask == 13 || other.categoryBitMask == 15 {
            if other.categoryBitMask == 15 {
                if !trapEmitterInAction && !characterHurts {
                    let trapFireEmitterTemplate = other.node as! SKEmitterNode
                    trapEmitterInAction = true
                    runAction(SKAction.sequence([SKAction.runBlock({
                        trapFireEmitterTemplate.particleBirthRate = 455.28
                    }), SKAction.waitForDuration(1.0),SKAction.runBlock({
                        trapFireEmitterTemplate.particleBirthRate = 0
                        self.trapEmitterInAction = false
                    })]))
                }
            }
            controlLivesCount(decrease: true, count: 1)
        }
    }
    
    // MARK: Setup
    
    override func configurePhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: collisionRadius)
        physicsBody!.categoryBitMask = PhysicsCategory.Player
        physicsBody!.contactTestBitMask = PhysicsCategory.All
    }
    
    // MARK: Scene Processing Support
    
    override func animationDidComplete(animation: AnimationState) {
        super.animationDidComplete(animation)
        
        if animation == AnimationState.Death {
        }
    }
    
    class func loadSharedAssets() {
        idleAnimationFrames = loadFramesFromAtlasWithName("Ron_Idle")
        walkAnimationFrames = loadFramesFromAtlasWithName("Ron_Run")
        getHitAnimationFrames = loadFramesFromAtlasWithName("Ron_GetHit")
        deathAnimationFrames = loadFramesFromAtlasWithName("Ron_Death")
        leanSlidingAnimationFrames = loadFramesFromAtlasWithName("Ron_LeanSlide")
        sneakUpAnimationFrames = loadFramesFromAtlasWithName("Ron_SneakUp")
    }
    
    func faceToPosition(targetPosition: CGPoint, withDuration duration:NSTimeInterval, isItCounterClockWiseRotation counter_clockWise:Bool) -> CGFloat {
        
        let deltaX = targetPosition.x - position.x
        let deltaY = targetPosition.y - position.y
        
        let newTargetPosition = CGPoint(x: position.x + deltaX, y: position.y + deltaY)
        
        let theta = newTargetPosition.radiansToPoint(position)
        
        let angle:CGFloat!
        
        //Clockwise
        if !counter_clockWise {
            angle = theta-CGFloat(M_PI)*0.5
        }
            //Counter-clockwise
        else {
            angle = theta+CGFloat(M_PI)*1.5
        }
        
        self.runAction(SKAction.rotateToAngle(angle, duration: duration))
        
        return angle
    }
    
    func moveTowardsPosition(targetPosition: CGPoint, withTimeInterval timeInterval: NSTimeInterval, running:Bool) {
        
        let deltaX = targetPosition.x - position.x
        let deltaY = targetPosition.y - position.y
        let maximumDistance = movementSpeed * 12 * CGFloat(timeInterval)
        
        moveFromCurrentPosition(byDeltaX: deltaX, deltaY: deltaY, maximumDistance: maximumDistance, targetPosition:targetPosition,running:running)
    }
    
    func moveFromCurrentPosition(byDeltaX dx: CGFloat, deltaY dy: CGFloat, maximumDistance: CGFloat, targetPosition:CGPoint, running:Bool) {
        let targetPosition = CGPoint(x: position.x + dx, y: position.y + dy)
        
        let angle = adjustAssetOrientation(targetPosition.radiansToPoint(position))
        
        faceToPosition(targetPosition, withDuration: 0, isItCounterClockWiseRotation:false)
        
        let distRemaining = hypot(dx, dy)
        if distRemaining < maximumDistance {
            position = targetPosition
        } else {
            let x = position.x - (maximumDistance * sin(angle))
            let y = position.y + (maximumDistance * cos(angle))
            position = CGPoint(x: x, y: y)
        }
        
        if !running {
            requestedAnimation = .SneakUp
            movementSpeed = 4
        }
        else {
            requestedAnimation = .Walk
            movementSpeed = 16
        }
    }
}
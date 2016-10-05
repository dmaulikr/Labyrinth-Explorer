/*
  Copyright (C) 2015 Apple Inc. All Rights Reserved.
  See LICENSE.txt for this sample’s licensing information
  
  Abstract:
  Defines the class for enemy characters
*/

import SpriteKit

enum MotionType {
    case Direct, Cycled, Fixed, None
}

class EnemyCharacter: GameCharacter {
    
    // MARK: Properties
    
    var livesCount = 1
    var canSeePath = false
    var inEscapeArea = false
    var running = false
    var assignedLocations:[String] = []
    var maxLivesCount:Int!
    var heroLastPositionIsReceived = false
    var motionType:MotionType = .None
    var currentPathIndex:Int = 0
    var distracted = false
    var enemyRunSpeed:CGFloat = 18
    
    // MARK: Scene Processing Support
    
    override func updateWithTimeSinceLastUpdate(interval: NSTimeInterval) {
        super.updateWithTimeSinceLastUpdate(interval)
        if ron.isDying {
            requestedAnimation = .Idle
        }
        if !isDying {
            detectionArea?.updateWithTimeSinceLastUpdate(interval)
        }
    }

    override func animationDidComplete(animationState: AnimationState) {
        if animationState == AnimationState.Death {
            isDying = true
            runAction(SKAction.waitForDuration(1.8), completion:{
                self.removeFromParent()
            })
        }
    }
    
    func performAttackAction(attackRadius attackRadius:CGFloat) {
        if isAttacking {
            return
        }
        
        detectionArea?.stopAndHit = true
        
        if self is EnemyWithSword {
            runAction(SKAction.waitForDuration(1.2), completion: {
                if let closestEnemyPathDistance = self.detectionArea?.closestEnemyPathWithinEnemyAlertRadius(self.position, enemyPath: ron) {
                    if closestEnemyPathDistance <= attackRadius {
                        self.requestedAnimation = .Attack
                        if ron.livesCount > 1 {
                            ron.controlLivesCount(decrease: true, count: 1)
                        }
                        else {
                            self.runAction(SKAction.waitForDuration(0.2), completion: {
                                ron.zPosition = 0
                                ron.controlLivesCount(decrease: true, count: 1)
                            })
                        }
                    }
                }
                self.detectionArea?.stopAndHit = false
            })
        }
        if self is EnemyWithGun {
                if let closestEnemyPathDistance = detectionArea?.closestEnemyPathWithinEnemyAlertRadius(position, enemyPath: ron) {
                if closestEnemyPathDistance <= attackRadius {
                    requestedAnimation = .Attack
                }
            }
        }
        
    }
    
    override func controlLivesCount(decrease decrease:Bool, count:Int) {

        if livesCount != 0 {
            if !characterHurts && decrease {
                livesCount-=count
                runAction(SKAction.sequence([SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0.15, duration: 0.15),
                    SKAction.waitForDuration(0.5),
                    SKAction.colorizeWithColorBlendFactor(0, duration:0.15)]), completion:{
                        self.characterHurts = false
                })
                if livesCount == 0 {
                    physicsBody?.dynamic = false
                    animationDidComplete(.Death)
                }
                else {
                    characterHurts = true
                }
            }
        }
        
    }
    
    var detectionArea:DetectionArea?
    
    func activateDetectionArea(initializeDetectionAreaTopRightX topRightX:CGFloat, initializeDetectionAreaTopRightY topRightY:CGFloat, initializeDetectionAreaTopLeftX topLeftX:CGFloat,
        initializeDetectionAreaTopLeftY topLeftY:CGFloat,
        initializeDetectionAreaBottomRightX bottomRightX:CGFloat,
        initializeDetectionAreaBottomLeftX bottomLeftX:CGFloat) {
        detectionArea = DetectionArea(initializeDetectionAreaTopRightX: topRightX, initializeDetectionAreaTopRightY: topRightY, initializeDetectionAreaTopLeftX: topLeftX, initializeDetectionAreaTopLeftY: topLeftY, initializeDetectionAreaBottomRightX: bottomRightX, initializeDetectionAreaBottomLeftX: bottomLeftX)
        detectionArea!.character = self
        
        detectionArea!.enemyAlertRadius = self.collisionRadius * 500
        detectionArea!.attackRadius =  self.collisionRadius * 2.0
            
        self.currentPathIndex = 0
            
        if self.paths.count != 0 {
            detectionArea!.paths = self.paths
        }

        world.addChild(detectionArea!)
    }
    
    // MARK: Movement Handling
    
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
        
        runAction(SKAction.rotateToAngle(angle, duration: duration))
        detectionArea?.zRotation = zRotation
        detectionArea?.runAction(SKAction.rotateToAngle(angle, duration: duration))
        
        return angle
    }
    
    func moveTowardsPosition(targetPosition: CGPoint, withTimeInterval timeInterval: NSTimeInterval) {

        let deltaX = targetPosition.x - position.x
        let deltaY = targetPosition.y - position.y
        let maximumDistance = movementSpeed * 12 * CGFloat(timeInterval)
        
        moveFromCurrentPosition(byDeltaX: deltaX, deltaY: deltaY, maximumDistance: maximumDistance, targetPosition:targetPosition)
    }
    
    func moveFromCurrentPosition(byDeltaX dx: CGFloat, deltaY dy: CGFloat, maximumDistance: CGFloat, targetPosition:CGPoint) {
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
        
        if !isAttacking {
            if detectionArea!.targetWasSeen {
                movementSpeed = enemyRunSpeed
                requestedAnimation = .Run
            }
            else {
                movementSpeed = 6
                requestedAnimation = .Walk
            }
        }
    }
    
}

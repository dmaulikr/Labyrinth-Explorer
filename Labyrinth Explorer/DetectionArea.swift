//
//  DetectionArea.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 4/6/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class DetectionArea : SKShapeNode {
    
    var detectorBezierPath = UIBezierPath()
    var character:EnemyCharacter!
    let radiusOfHeroPresenseDetection = SKShapeNode(circleOfRadius: 600)
    var radiusOfRunningHeroDetection:SKShapeNode?
    var radiusOfImmediateDetection:SKShapeNode?
    var enemiesConnection:SKShapeNode?
    var enemiesConnectionPath = UIBezierPath()
    var obstacles:[SKNode] = []
    var characterInProgress = false
    
    var target:SKNode?
    
    var actionsExist = false
    
    var targetWasSeen = false
    
    var isInspecting = false
    
    var reversedMotion = false
    
    var stopAndHit = false
    
    var paths:[SKNode] = []
    
    var pathFound = false
    
    var inProgress = false
    
    var lastPositionOfHero:CGPoint = CGPointMake(0, 0)
    
    var lastPositionOfHeroIsDetected = false
    
    var closestPathDistance = CGFloat.max
    
    var attackRadius: CGFloat = 0.0
    
    var enemyAlertRadius: CGFloat = 0.0
    
    var enemyIsAlarmed = false
    
    struct detectionDistance {
        static var bottomRightY:CGFloat = -50.0
        static var bottomLeftY:CGFloat = -50.0
    }
    
    init(initializeDetectionAreaTopRightX topRightX:CGFloat, initializeDetectionAreaTopRightY topRightY:CGFloat, initializeDetectionAreaTopLeftX topLeftX:CGFloat,
        initializeDetectionAreaTopLeftY topLeftY:CGFloat,
        initializeDetectionAreaBottomRightX bottomRightX:CGFloat,
        initializeDetectionAreaBottomLeftX bottomLeftX:CGFloat) {
        super.init()
        let topRightX:CGFloat = topRightX
        let topRightY:CGFloat = topRightY
        let topLeftX:CGFloat = topLeftX
        let topLeftY:CGFloat = topLeftY
        let bottomRightX:CGFloat = bottomRightX
        let bottomLeftX:CGFloat = bottomLeftX
        
        strokeColor = UIColor.clearColor()
        fillColor = UIColor.clearColor()
        
        detectorBezierPath.moveToPoint(CGPointMake(topRightX,topRightY))
        detectorBezierPath.addLineToPoint(CGPointMake(bottomRightX,detectionDistance.bottomRightY))
        detectorBezierPath.addLineToPoint(CGPointMake(0.0, 0.0))
        detectorBezierPath.addLineToPoint(CGPointMake(bottomLeftX,detectionDistance.bottomLeftY))
        detectorBezierPath.addLineToPoint(CGPointMake(topLeftX,topLeftY))
        self.path = detectorBezierPath.CGPath
        
        enemiesConnection = SKShapeNode()
        enemiesConnection?.strokeColor = UIColor.clearColor()
        enemiesConnection?.fillColor = UIColor.clearColor()
        world.addChild(enemiesConnection!)
        
        radiusOfHeroPresenseDetection.strokeColor = UIColor.clearColor()
        radiusOfHeroPresenseDetection.fillColor = UIColor.clearColor()
        world.addChild(radiusOfHeroPresenseDetection)
        
        gameScene.enumerateChildNodesWithName("wall*") { node, stop in
            let wall = node.copy() as! SKNode
            self.obstacles.append(wall)
        }

    }
    
    func updateWithTimeSinceLastUpdate(interval: NSTimeInterval) {
        
        self.position = character.position
        radiusOfHeroPresenseDetection.position = character.position
        
        if radiusOfHeroPresenseDetection.containsPoint(ron.position) {
            
            if radiusOfImmediateDetection == nil {
                radiusOfImmediateDetection = SKShapeNode(circleOfRadius: 70)
                radiusOfImmediateDetection!.fillColor = UIColor.clearColor()
                radiusOfImmediateDetection!.strokeColor = UIColor.clearColor()
                world.addChild(radiusOfImmediateDetection!)
            }
            
            radiusOfImmediateDetection!.position = character.position
            
            if radiusOfRunningHeroDetection == nil {
                radiusOfRunningHeroDetection = SKShapeNode(circleOfRadius: 200)
                radiusOfRunningHeroDetection!.fillColor = UIColor.clearColor()
                radiusOfRunningHeroDetection!.strokeColor = UIColor.clearColor()
                world.addChild(radiusOfRunningHeroDetection!)
            }
            
            radiusOfRunningHeroDetection!.position = character.position
            
        }
        else {
            
            if radiusOfImmediateDetection != nil {
                radiusOfImmediateDetection!.removeFromParent()
                radiusOfImmediateDetection = nil
            }
            
            if radiusOfRunningHeroDetection != nil {
                radiusOfRunningHeroDetection!.removeFromParent()
                radiusOfRunningHeroDetection = nil
            }
        }
        
        enemiesConnectionPath.removeAllPoints()
        enemiesConnectionPath.moveToPoint(character.convertPoint(character.position, fromNode: enemiesConnection!))
        enemiesConnectionPath.addLineToPoint(ron.convertPoint(ron.position, fromNode: enemiesConnection!))
        enemiesConnection!.path = enemiesConnectionPath.CGPath
        
        // HERO DETECTION

        if self.containsPoint(ron.position) {
            heroDetection(interval)
        }
        else {
            ron.isDetected = false
        }
        
        // DETECTION OF HERO IN THE RADIUS NO MATTER WHERE HE IS
        
        if radiusOfImmediateDetection != nil {
            if radiusOfImmediateDetection!.containsPoint(ron.position) && moveJoystick.moveSize.width != 0 && moveJoystick.moveSize.height != 0 {
                heroDetection(interval)
            }
        }
        
        // DETECTION OF HERO WHEN HE RUNS NEARBY IN THE RADIUS
        
        if radiusOfRunningHeroDetection != nil && !slowModeActivated && !ron.heroIsHidden {
            if radiusOfRunningHeroDetection!.containsPoint(ron.position) && moveJoystick.moveSize.width != 0 && moveJoystick.moveSize.height != 0 {
                heroDetection(interval)
            }
        }
        
        if character.isDying || stopAndHit {
            target = nil
            return
        }
        
        if ron.isDetected {
            
            if character.motionType == .None {
                
                let deltaX = ron.position.x - character.position.x
                let deltaY = ron.position.y - character.position.y
                
                let targetPosition = CGPoint(x: character.position.x + deltaX, y: character.position.y + deltaY)
                
                character.faceToPosition(targetPosition, withDuration: 0, isItCounterClockWiseRotation:false)
                
                if !ron.invincible {
                    character.performAttackAction(attackRadius: attackRadius)
                }
                
                return
            }
            
        }
        
        if character.motionType != .None {
            if let closestHeroDistance = closestHeroWithinEnemyAlertRadius() {
                target = ron
                targetWasSeen = true
                isInspecting = false
                lastPositionOfHeroIsDetected = false
                character.faceToPosition(target!.position, withDuration: 0, isItCounterClockWiseRotation:false)
                if !enemyIsAlarmed {
                    character.requestedAnimation = .Alarmed
                    character.runAction(SKAction.waitForDuration(1.5), completion:{
                        self.enemyIsAlarmed = true
                    })
                }
                else {
                    chaseTargetWithinDistance(closestHeroDistance, timeInterval: interval)
                }
            }
            else {
                
                if isInspecting {
                    
                    character.moveTowardsPosition(lastPositionOfHero, withTimeInterval: interval)
                    
                    if character.position == lastPositionOfHero {
                        character.requestedAnimation = .Inspect
                        character.faceToPosition(ron.position, withDuration: 0, isItCounterClockWiseRotation:false)
                        if !inProgress {
                            inProgress = true
                            
                            character.runAction(SKAction.waitForDuration(5.0), completion: {
                                self.enemyIsAlarmed = false
                                self.isInspecting = false
                                self.targetWasSeen = false
                                self.inProgress = false
                                self.closestPathDistance = CGFloat.max
                                self.character.distracted = true
                                for var i=0;i<self.character.paths.count;i++ {
                                    if let closestEnemyPathDistance = self.closestEnemyPathWithinEnemyAlertRadius(self.character.position, enemyPath: self.paths[i]) {
                                        
                                        if self.closestPathDistance > closestEnemyPathDistance {
                                            self.closestPathDistance = closestEnemyPathDistance
                                            self.character.currentPathIndex = i
                                        }
                                        
                                    }
                                }
                            })
                            
                        }
                    }
                    
                    return
                }
                
                if targetWasSeen && !lastPositionOfHeroIsDetected {
                    lastPositionOfHeroIsDetected = true
                    lastPositionOfHero = ron.position
                    
                    isInspecting = true
                    
                }
                
                if !actionsExist {
                    if let closestEnemyPathDistance = closestEnemyPathWithinEnemyAlertRadius(character.position, enemyPath: paths[character.currentPathIndex]) {
                        inProgress = false
                        pathFound(closestEnemyPathDistance, timeInterval: interval)
                    }
                }
                
            }
        }
        
    }
    
    func pathFound(closestEnemyPathDistance:CGFloat, timeInterval:NSTimeInterval) {
        target = paths[character.currentPathIndex]
        chaseTargetWithinDistance(closestEnemyPathDistance, timeInterval: timeInterval)
        character.distracted = false
    }
    
    // MARK: Intelligence Implementation
    
    func closestEnemyPathWithinEnemyAlertRadius(originCharacterPosition:CGPoint, enemyPath:SKNode) -> CGFloat? {
        
        let position = GameScene.sceneView!.convertPoint(originCharacterPosition, fromNode: world)
        
        var closestEnemyPathDistance = CGFloat.max
        
        let enemyPathPosition = GameScene.sceneView!.convertPoint(enemyPath.position, fromNode: world)
        let distance = position.distanceToPoint(enemyPathPosition)
        
        if distance < enemyAlertRadius && distance < closestEnemyPathDistance {
            
            character.canSeePath = canSee(enemyPathPosition, from: position)
            
            if character.canSeePath {
                closestEnemyPathDistance = distance
            }
            
        }
        
        if closestEnemyPathDistance <= enemyAlertRadius {
            return (closestEnemyPathDistance: closestEnemyPathDistance)
        }
        
        return nil
    }
    
    func closestHeroWithinEnemyAlertRadius() -> CGFloat? {
        
        let position = GameScene.sceneView!.convertPoint(character.position, fromNode: gameScene)
        
        var closestHeroDistance = CGFloat.max
        
        let heroPosition = GameScene.sceneView!.convertPoint(ron.position, fromNode: gameScene)
        let distance = position.distanceToPoint(heroPosition)
        
        if distance < enemyAlertRadius && distance < closestHeroDistance && !ron.heroIsHidden {
            if ron.isDetected {
                closestHeroDistance = distance
            }
        }
        
        if closestHeroDistance <= enemyAlertRadius {
            return (closestHeroDistance: closestHeroDistance)
        }
        
        return nil
    }
    
    func chaseTargetWithinDistance(closestDistance: CGFloat, timeInterval: NSTimeInterval) {
        
        if let targetPosition = target?.position {
            if closestDistance > attackRadius && target == ron {
                character.moveTowardsPosition(targetPosition, withTimeInterval: timeInterval)
            }
            else if closestDistance > character.collisionRadius/2 && target != ron {
                character.moveTowardsPosition(targetPosition , withTimeInterval: timeInterval)
            }
            else {
                
                if character.paths.count != 0  && character.motionType != .Fixed {
                    if character.canSeePath && !isInspecting {
                        
                        if character.motionType == .Direct {
                            character.currentPathIndex++
                            if character.currentPathIndex > paths.count-1 {
                                character.currentPathIndex = 0
                            }
                        }
                            // Cycled Motion
                        else {
                            if character.currentPathIndex == paths.count-1 {
                                reversedMotion = true
                            }
                            else if character.currentPathIndex == 0 {
                                reversedMotion = false
                            }
                            
                            if !reversedMotion {
                                character.currentPathIndex++
                            }
                            else {
                                character.currentPathIndex--
                            }
                            
                        }
                        
                    }
                }
                
                if ron.isDetected && !ron.invincible {
                    character.performAttackAction(attackRadius: attackRadius)
                }
            }
        }
    }
    
    func heroDetection(interval: NSTimeInterval) {
        gameScene.enumerateChildNodesWithName("wall*") { node, stop in
            for var i=0;i<self.obstacles.count;i++ {
                let wall = self.obstacles[i]
                if self.enemiesConnectionPath.bounds.intersects(wall.frame) {
                    ron.isDetected = false
                    break
                }
                else if i == self.obstacles.count-1 && !ron.heroIsHidden {
                    ron.isDetected = true
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
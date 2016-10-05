//
//  MineBomb.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 5/10/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class MineBomb: SKSpriteNode {
    
    var isAboutToBeExploded = false
    var mineBombType:type
    var visualEffect = SKSpriteNode()
    var effectArea = SKShapeNode()
    var mineAndTargetConnection = SKShapeNode()
    var mineAndTargetConnectionPath = UIBezierPath()
    var obstacles:[SKNode] = []
    var warningAnimationFrames:[SKTexture] = []
    var effectAnimationFrames:[SKTexture] = []
    
    enum type {
        case Explosive
        case Electric
        case Flash
    }
    
    init(node:SKNode, mineBombType:type, effectAreaSize:CGSize, alarmArea:CGFloat, warningAnimationFrames:[SKTexture], effectAnimationFrames:[SKTexture]) {
        let texture = SKTexture(imageNamed: "fireMineBomb_0001.png")
        self.mineBombType = mineBombType
        super.init(texture: texture, color: UIColor.clearColor(), size: node.frame.size)
        self.name = node.name
        self.position = node.position
        self.warningAnimationFrames = warningAnimationFrames
        self.effectAnimationFrames = effectAnimationFrames
        configurePhysicsBody()
        visualEffect.position = self.position
        visualEffect.size = effectAreaSize
        world.addChild(visualEffect)
        effectArea = SKShapeNode(circleOfRadius: alarmArea)
        effectArea.position = visualEffect.position
        effectArea.lineWidth = 5
        effectArea.zPosition = 50
        world.addChild(self)
    }
    
    func configurePhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: self.size.width)
        physicsBody?.dynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.MineBomb
        physicsBody!.contactTestBitMask = PhysicsCategory.LivingCreatures
    }
    
    // MARK: Scene Processing Support
    
    func collidedWith(other: SKPhysicsBody) {
        
        if isAboutToBeExploded {
            return
        }
        
        if other.categoryBitMask == PhysicsCategory.Player || other.categoryBitMask == PhysicsCategory.Enemy {
            mineIsAboutToDoSomethingVeryBad()
        }
    }
    
    func mineIsAboutToDoSomethingVeryBad() {
        isAboutToBeExploded = true
        gameScene.enumerateChildNodesWithName("wall*") { node, stop in
            let wall = node.copy() as! SKNode
            self.obstacles.append(wall)
        }
        world.addChild(effectArea)
        mineAndTargetConnection.strokeColor = UIColor.clearColor()
        mineAndTargetConnection.fillColor = UIColor.clearColor()
        world.addChild(mineAndTargetConnection)
        if mineBombType == .Explosive {
            effectArea.strokeColor = UIColor.redColor()
        }
        else if mineBombType == .Electric {
            effectArea.strokeColor = UIColor.blueColor()
        }
        else if mineBombType == .Flash {
            effectArea.strokeColor = UIColor.yellowColor()
        }
        
        effectArea.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.fadeOutWithDuration(0.5),
            SKAction.waitForDuration(0.5),
            SKAction.fadeInWithDuration(0.5),
            SKAction.waitForDuration(0.5)
            ])))
        
        self.runAction(SKAction.repeatAction(SKAction.animateWithTextures(warningAnimationFrames, timePerFrame: 0.01, resize: false, restore: false), count: 5), completion:{
            self.hidden = true
            self.castEffectOnTargets()
        })
    }
    
    func castEffectOnTargets() {
        for target in world.children {
            if effectArea.containsPoint(target.position) {
                mineAndTargetConnectionPath.removeAllPoints()
                mineAndTargetConnectionPath.moveToPoint(self.convertPoint(self.position, fromNode: mineAndTargetConnection))
                mineAndTargetConnectionPath.addLineToPoint(target.convertPoint(target.position, fromNode: mineAndTargetConnection))
                mineAndTargetConnection.path = mineAndTargetConnectionPath.CGPath
                
                for var i=0;i<self.obstacles.count;i++ {
                    let wall = self.obstacles[i]
                    if mineAndTargetConnectionPath.bounds.intersects(wall.frame) {
                        break
                    }
                    else if i == self.obstacles.count-1 {
                        if target is RonCharacter {
                            if self.mineBombType == .Explosive {
                                ron.controlLivesCount(decrease: true, count: 1)
                            }
                        }
                        else if target is EnemyCharacter {
                            if self.mineBombType == .Explosive {
                                (target as! EnemyCharacter).controlLivesCount(decrease: true, count: 1)
                            }
                        }
                        else if target is MineBomb && !(target as! MineBomb).isAboutToBeExploded {
                            (target as! MineBomb).mineIsAboutToDoSomethingVeryBad()
                        }
                    }
                }
                
            }
        }
        visualEffect.runAction(SKAction.animateWithTextures(effectAnimationFrames, timePerFrame: 0.01, resize: false, restore: false), completion:{
            self.mineAndTargetConnection.removeFromParent()
            self.effectArea.removeFromParent()
            self.visualEffect.removeFromParent()
            self.removeFromParent()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

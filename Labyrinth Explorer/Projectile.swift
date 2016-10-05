//
//  Projectile.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 4/19/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class Projectile: LongRangeCombatEnemy {
    
    var enemy:LongRangeCombatEnemy!
    
    // MARK: Setup
    
    override func configurePhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: LongRangeCombatEnemy.Constants.projectileCollisionRadius)
        physicsBody!.categoryBitMask = PhysicsCategory.Projectile
        physicsBody!.collisionBitMask = PhysicsCategory.Wall
        physicsBody!.contactTestBitMask = physicsBody!.collisionBitMask
    }
    
    // MARK: Scene Processing Support
    
    override func collidedWith(other: SKPhysicsBody) {
        
        if isDying {
            return
        }
        
        enemy.detectionArea?.stopAndHit = false
        
        if other.categoryBitMask == PhysicsCategory.Wall || other.categoryBitMask == PhysicsCategory.BlockingTrap || other.categoryBitMask == PhysicsCategory.Door || other.categoryBitMask == PhysicsCategory.Player {
            self.removeFromParent()
        }
        if other.categoryBitMask == PhysicsCategory.Player {
            if ron.livesCount > 1 {
                ron.controlLivesCount(decrease: true, count: 1)
            }
            else {
                ron.runAction(SKAction.waitForDuration(0.2), completion: {
                ron.zPosition = 0
                ron.controlLivesCount(decrease: true, count: 1)
            })
            }
        }
        
    }
    
}

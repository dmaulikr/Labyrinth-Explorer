//
//  LongRangeCombatEnemy.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 4/19/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

    class LongRangeCombatEnemy: EnemyCharacter {
    
    struct Constants {
        static var projectileCollisionRadius: CGFloat = 5.0
        static var projectileSpeed: CGFloat = 480.0
        static var projectileLifetime: NSTimeInterval = 2.0
        static var projectileFadeOutDuration: NSTimeInterval = 0.6
    }
        
    // MARK: Scene Processing Support
    
    override func animationDidComplete(animation: AnimationState) {
        super.animationDidComplete(animation)
        
        switch animation {
            
        case .Attack:
            fireProjectile()
            
        default:
            () // Do nothing
        }
    }
        
    func fireProjectile() {
        let projectile = self.dynamicType.projectile.copy() as! Projectile
        projectile.enemy = self
        projectile.position = position
        projectile.zRotation = zRotation
        
        let emitter = self.dynamicType.projectileEmitter.copy() as! SKEmitterNode
        emitter.targetNode = world
        projectile.addChild(emitter)
        
        world.addChild(projectile)
        let rot = zRotation
        
        let x = sin(rot) * Constants.projectileSpeed * CGFloat(Constants.projectileLifetime)
        let y = -cos(rot) * Constants.projectileSpeed * CGFloat(Constants.projectileLifetime)
        projectile.runAction(SKAction.moveByX(x, y: y, duration: Constants.projectileLifetime), completion:{
            self.detectionArea?.stopAndHit = false
            let fadeAction = SKAction.fadeOutWithDuration(Constants.projectileFadeOutDuration)
            let removeAction = SKAction.removeFromParent()
            let sequence = [fadeAction, removeAction]
            
            projectile.runAction(SKAction.sequence(sequence))
            
        })
        
        //        projectile.runAction(projectileSoundAction)
        
        //        projectile.userData = [Player.Keys.projectileUserDataPlayer: player]
    }
        
}

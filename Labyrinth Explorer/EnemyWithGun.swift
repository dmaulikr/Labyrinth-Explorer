//
//  EnemyWithGun.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 4/16/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

final class EnemyWithGun: LongRangeCombatEnemy, SharedAssetProvider {
    
    class func loadSharedAssets() {
        idleAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type2_Idle")
        walkAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type2_Walk")
        runAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type2_Run")
        attackAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type2_Hit")
        alarmedAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type2_Alarmed")
        deathAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type2_Death")
        inspectAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type2_Inspect")
        
        projectile = Projectile(imageNamed: "bullet.png")
        projectile.configurePhysicsBody()
        LongRangeCombatEnemy.Constants.projectileSpeed = 350.0
        
        //projectileEmitter = SKEmitterNode(fileNamed: "ArcherProjectile")
        
        let actions = [
            SKAction.colorizeWithColor(SKColor.whiteColor(), colorBlendFactor: 10.0, duration: 0.0),
            SKAction.waitForDuration(0.75),
            SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.25)
        ]
        
        damageAction = SKAction.sequence(actions)
        
    }
    
    convenience init(atPosition position: CGPoint, name:String, paths:[SKNode], motionType:MotionType) {
        let atlas = SKTextureAtlas(named: "Enemy_Type2_Idle")
        let enemyType1Texture = atlas.textureNamed("enemy_type2_idle_0001.png")
        self.init(texture: enemyType1Texture, atPosition: position)
        size = CGSizeMake(200, 200)
        zPosition = 98
        collisionRadius = 300
        self.name = name
        self.paths = paths
        self.motionType = motionType
        world.addChild(self)
        activateDetectionArea(initializeDetectionAreaTopRightX: 200.0, initializeDetectionAreaTopRightY: -600.0, initializeDetectionAreaTopLeftX: -200.0, initializeDetectionAreaTopLeftY: -600.0, initializeDetectionAreaBottomRightX: 200.0, initializeDetectionAreaBottomLeftX: -200.0)
        
    }
    
    // MARK: Setup
    
    override func configurePhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: 20)
        physicsBody!.categoryBitMask = PhysicsCategory.Enemy
        physicsBody!.contactTestBitMask = PhysicsCategory.All
    }
    
    // MARK: Scene Processing Support
    
    override func collidedWith(other: SKPhysicsBody) {
        
        if isDying  {
            return
        }
        
        if other.categoryBitMask == 13 || other.categoryBitMask == 15 {
            if other.categoryBitMask == 15 {
                if !trapEmitterInAction {
                    let trapEmitterTemplate = other.node as! SKEmitterNode
                    trapEmitterInAction = true
                    runAction(SKAction.sequence([SKAction.runBlock({
                        trapEmitterTemplate.particleBirthRate = 455.28
                    }), SKAction.waitForDuration(1.0),SKAction.runBlock({
                        trapEmitterTemplate.particleBirthRate = 0
                        self.trapEmitterInAction = false
                    })]))
                    
                }
            }
            
            controlLivesCount(decrease: true, count: 1)
        }
        
    }
    
}

//
//  Enemy.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 4/1/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

final class EnemyWithSword: EnemyCharacter, SharedAssetProvider {
    
    class func loadSharedAssets() {
        idleAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type1_Idle")
        walkAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type1_Walk")
        runAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type1_Run")
        attackAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type1_Hit")
        alarmedAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type1_Alarmed")
        deathAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type1_Death")
        inspectAnimationFrames = loadFramesFromAtlasWithName("Enemy_Type1_Inspect")
    }
    
    convenience init(atPosition position: CGPoint, name:String, paths:[SKNode], motionType:MotionType) {
        let atlas = SKTextureAtlas(named: "Enemy_Type1_Idle")
        let enemyType1Texture = atlas.textureNamed("enemy_type1_idle_0001.png")
        self.init(texture: enemyType1Texture, atPosition: position)
        size = CGSizeMake(200, 200)
        zPosition = 98
        self.name = name
        self.paths = paths
        self.motionType = motionType
        world.addChild(self)
        activateDetectionArea(initializeDetectionAreaTopRightX: 100.0, initializeDetectionAreaTopRightY: -400.0, initializeDetectionAreaTopLeftX: -100.0, initializeDetectionAreaTopLeftY: -400.0, initializeDetectionAreaBottomRightX: 100.0, initializeDetectionAreaBottomLeftX: -100.0)
    }
    
    // MARK: Setup
    
    override func configurePhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: collisionRadius)
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

//
//  Lvl3.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 4/13/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class Lvl3: MainScene {
    
    var enemy:EnemyWithSword!
    var blockingGates1 = SKSpriteNode()
    var blockingGates2 = SKSpriteNode()
    var secretButton1IsPressed = false
    var secretButton2IsPressed = false
    var spearTrap1 = SKSpriteNode()
    var spearTrap2 = SKSpriteNode()
    var spearTrap3 = SKSpriteNode()
    var spearTrap4 = SKSpriteNode()
    var spearTrap5 = SKSpriteNode()
    var spearTrap6 = SKSpriteNode()
    var spearTrap7 = SKSpriteNode()
    var spearTrap8 = SKSpriteNode()
    var enemyInAction = false
    
    override func didMoveToView(view: SKView) {
        
        GameScene.sceneView = self
        
        loadWorld()
        
        self.view?.addGestureRecognizer(slowMotionModeGestureRecognizer)
        
    }
    
    override func loadWorld() {
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        addChild(world)
        
        /*self.size.height *= 3
        self.size.width *= 3
        world.position = CGPointMake(0, 0)*/
        
        gameScene = SKScene(fileNamed:gameMapsHUD.lvl3hudNodeName)
        gameConstantProperties = GameConstants(heroLivesCount: 3, rotateCharacterToAngle: leftAngle)
        populateWallsFromWorld()
        loadBackgroundTiles(CGPointMake(0, 0), areaSize: CGSizeMake(gameScene.size.width+256, gameScene.size.height+256), tiles: gameBackgroundTiles.stonyTiles, sizeOfTile: CGSizeMake(256, 256), blendMode: SKBlendMode.Alpha)
        populateMaterialUsableAreasFromWorld()
        populateHideoutsFromWorld()
        populateTrapsFromWorld()
        populateGatesFromWorld()
        
        let spearVertical = loadFramesFromAtlasWithName("SpearVertical")
        let spearHorizontal = loadFramesFromAtlasWithName("SpearHorizontal")
        
        spearTrap1 = setupSpearTrap(node: world.childNodeWithName("spearTrap1")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 10, waitingDuration: 2) as! SKSpriteNode
        spearTrap2 = setupSpearTrap(node: world.childNodeWithName("spearTrap2")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 10, waitingDuration: 3) as! SKSpriteNode
        spearTrap3 = setupSpearTrap(node: world.childNodeWithName("spearTrap3")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 10, waitingDuration: 4) as! SKSpriteNode
        spearTrap4 = setupSpearTrap(node: world.childNodeWithName("spearTrap4")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 10, waitingDuration: 2) as! SKSpriteNode
        spearTrap5 = setupSpearTrap(node: world.childNodeWithName("spearTrap5")!, animationFrames: spearHorizontal, beginningPosition: 0, endingPosition: 14, waitingDuration: 2) as! SKSpriteNode
        spearTrap6 = setupSpearTrap(node: world.childNodeWithName("spearTrap6")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 14, waitingDuration: 2) as! SKSpriteNode
        spearTrap7 = setupSpearTrap(node: world.childNodeWithName("spearTrap7")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 14, waitingDuration: 2) as! SKSpriteNode
        spearTrap8 = setupSpearTrap(node: world.childNodeWithName("spearTrap8")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 14, waitingDuration: 2) as! SKSpriteNode
        
        addTrapFireEmitter(node: world.childNodeWithName("fireTrap")!, nodeName: "fireTrap")
        
        blockingGates1 = world.childNodeWithName("Gates_Type2_1")! as! SKSpriteNode
        setPhysicsBodyForGates(node: blockingGates1, size: blockingGates1.size
            , centerForPhysicsBody: CGPointMake(0, 0))
        blockingGates2 = world.childNodeWithName("Gates_Type2_2")! as! SKSpriteNode
        setPhysicsBodyForGates(node: blockingGates2, size: blockingGates2.size, centerForPhysicsBody: CGPointMake(0, 0))
        
        enemy = addEnemyCharacter(characterName: "enemyCharacter", spawnPoint: "Enemy_Path_0", characterType: EnemyWithSword(), paths: [gameScene.childNodeWithName("Enemy_Path_0")!], motionType: .Fixed, angle: topAngle) as! EnemyWithSword

    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if let character = contact.bodyA.node as? GameCharacter {
            character.collidedWith(contact.bodyB)
        }
        
        if let character = contact.bodyB.node as? GameCharacter {
            character.collidedWith(contact.bodyA)
        }
        
    }
    
    // MARK: Scene Processing Support
    
    override func updateWithTimeSinceLastUpdate(timeSinceLast: NSTimeInterval) {
        ron.updateWithTimeSinceLastUpdate(timeSinceLast)
        if !ron.isDying {
            enemy.updateWithTimeSinceLastUpdate(timeSinceLast)
            if !ron.isDetected {
                if gameScene.childNodeWithName("Enemy_Path_0")!.containsPoint(enemy.position) {
                    if !enemyInAction {
                        enemyInAction = true
                        enemy.runAction(SKAction.repeatActionForever(SKAction.sequence([
                            SKAction.runBlock({
                                self.enemy.faceToPosition(gameScene.childNodeWithName("starePoint1")!.position, withDuration: 2, isItCounterClockWiseRotation: false)
                            }),
                            SKAction.waitForDuration(3),
                            SKAction.runBlock({
                    self.enemy.faceToPosition(gameScene.childNodeWithName("starePoint2")!.position, withDuration: 2, isItCounterClockWiseRotation: true)
                            }),
                            SKAction.waitForDuration(3),
                            ])), withKey: "enemyAction")
                    }
                }
                else {
                    if enemyInAction {
                        enemy.removeActionForKey("enemyAction")
                    }
                    enemyInAction = false
                    enemyIsOnEscapeArea(enemies: [enemy], escapePathsNames: [["Escape_Path_0","Escape_Path_1","Escape_Path_2","Escape_Path_3",["Escape_Path_4","Escape_Path_5"]]], locations: [[["spot1","spot2"],["spot3","spot4"],["spot5"],["spot6"],["spot7"]]], withTimeInterval: 0.2, currentPathsIndexes: [0])
                }
            }
            else {
                enemy.removeActionForKey("enemyAction")
            }
        }
        
        if !ron.isDetected && ((gameScene.childNodeWithName("hidingArea1") as! SKShapeNode).containsPoint(ron.position) || (gameScene.childNodeWithName("hidingArea2") as! SKShapeNode).containsPoint(ron.position)) {
            isOnHidingArea()
        }
        else {
            if ron.heroIsHidden {
                ron.runAction(SKAction.colorizeWithColorBlendFactor(0, duration:0.15), completion:{
                })
                ron.heroIsHidden = false
            }
        }

        if !secretButton1IsPressed && (world.childNodeWithName("SecretButtonUsableArea1") as! SKSpriteNode).containsPoint(ron.position) {
            secretButton1IsPressed = true
            (world.childNodeWithName("SecretButtonUsableArea1") as! SKSpriteNode).texture = SKTexture(imageNamed: "Secret_Tile_Button_Type1_Pressed.png")
            blockingGates1.runAction(SKAction.animateWithTextures(loadFramesFromAtlasWithName("Gates_Type2"), timePerFrame: 1/20), completion: {
                self.blockingGates1.physicsBody!.categoryBitMask = PhysicsCategory.None
            })
        }
        if !secretButton2IsPressed && (world.childNodeWithName("SecretButtonUsableArea2") as! SKSpriteNode).containsPoint(ron.position) {
            secretButton2IsPressed = true
            (world.childNodeWithName("SecretButtonUsableArea2") as! SKSpriteNode).texture = SKTexture(imageNamed: "Secret_Tile_Button_Type1_Pressed.png")
            blockingGates2.runAction(SKAction.animateWithTextures(loadFramesFromAtlasWithName("Gates_Type2"), timePerFrame: 1/20), completion: {
                self.blockingGates2.physicsBody!.categoryBitMask = PhysicsCategory.None
            })
        }
        
        if (gameScene.childNodeWithName("MissionComplete") as! SKSpriteNode).containsPoint(ron.position) {
            if !levelIsComplete {
                levelIsComplete = true
                checkLevelStatus(won: true, nextLevel:Lvl4(size:GameScene.sceneView!.size))
            }
        }
        
        gameConstantProperties.updateMove()
        
        if screenSize.size.width == 480 {
            
        }
        else if screenSize.size.width == 568 {
            centerWorldOnPosition(ron.position, topRestriction: 560, bottomRestriction: -560, rightRestriction: -385, leftRestriction: 385)
        }
        else if screenSize.size.width == 667 {
            
        }
        else if screenSize.size.width == 736 {
            
        }
        else if screenSize.size.width == 768 {
            
        }
        else if screenSize.size.width == 1024 {
            centerWorldOnPosition(ron.position, topRestriction: 440, bottomRestriction: -430, rightRestriction: -270, leftRestriction: 275)
        }
        
    }
    
}

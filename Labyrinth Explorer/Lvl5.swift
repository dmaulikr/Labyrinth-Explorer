//
//  Lvl5.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 5/8/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class Lvl5: MainScene {
    
    var blockingGates1 = SKSpriteNode()
    var blockingGates2 = SKSpriteNode()
    var secretButton1IsPressed = false
    var secretButton2IsPressed = false
    var spearTrap1 = SKSpriteNode()
    var spearTrap2 = SKSpriteNode()
    var spearTrap3 = SKSpriteNode()
    var spearTrap4 = SKSpriteNode()
    var spearTrap5 = SKSpriteNode()
    var enemy1:EnemyWithSword!
    var enemy2:EnemyWithSword!
    var enemy3:EnemyWithSword!
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
        
        /*self.size.height *= 4
        self.size.width *= 4
        world.position = CGPointMake(0, 0)*/
        
        gameScene = SKScene(fileNamed:gameMapsHUD.lvl5hudNodeName)
        gameConstantProperties = GameConstants(heroLivesCount: 3, rotateCharacterToAngle: topAngle)
        populateWallsFromWorld()
        loadBackgroundTiles(CGPointMake(0, 0), areaSize: CGSizeMake(gameScene.size.width+256, gameScene.size.height+256), tiles: gameBackgroundTiles.stonyTiles, sizeOfTile: CGSizeMake(256, 256), blendMode: SKBlendMode.Alpha)
        populateMaterialUsableAreasFromWorld()
        populateHideoutsFromWorld()
        populateTrapsFromWorld()
        populateGatesFromWorld()
        
        let spearVertical = loadFramesFromAtlasWithName("SpearVertical")
        
        spearTrap1 = setupSpearTrap(node: world.childNodeWithName("spearTrap1")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 13, waitingDuration: 2) as! SKSpriteNode
        spearTrap2 = setupSpearTrap(node: world.childNodeWithName("spearTrap2")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 13, waitingDuration: 3) as! SKSpriteNode
        spearTrap3 = setupSpearTrap(node: world.childNodeWithName("spearTrap3")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 13, waitingDuration: 4) as! SKSpriteNode
        spearTrap4 = setupSpearTrap(node: world.childNodeWithName("spearTrap4")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 13, waitingDuration: 3) as! SKSpriteNode
        spearTrap5 = setupSpearTrap(node: world.childNodeWithName("spearTrap5")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 13, waitingDuration: 2) as! SKSpriteNode
        
        addTrapFireEmitter(node: world.childNodeWithName("fireTrap")!, nodeName: "fireTrap")
        
        blockingGates1 = world.childNodeWithName("Gates_Type2_1")! as! SKSpriteNode
        setPhysicsBodyForGates(node: blockingGates1, size: blockingGates1.size
            , centerForPhysicsBody: CGPointMake(0, 0))
        blockingGates2 = world.childNodeWithName("Gates_Type2_2")! as! SKSpriteNode
        setPhysicsBodyForGates(node: blockingGates2, size: blockingGates2.size, centerForPhysicsBody: CGPointMake(0, 0))
        
        let loadedWarningAnimationFrames = loadFramesFromAtlasWithName("FireMineBomb")
        let loadedEffectAnimationFrames = loadFramesFromAtlasWithName("ExplosionType1")
        
        MineBomb(node: gameScene.childNodeWithName("fireMineBomb0")!, mineBombType: .Explosive, effectAreaSize: CGSizeMake(500, 500), alarmArea: 200, warningAnimationFrames: loadedWarningAnimationFrames, effectAnimationFrames: loadedEffectAnimationFrames)
        MineBomb(node: gameScene.childNodeWithName("fireMineBomb1")!, mineBombType: .Explosive, effectAreaSize: CGSizeMake(500, 500),alarmArea:200, warningAnimationFrames: loadedWarningAnimationFrames, effectAnimationFrames: loadedEffectAnimationFrames)
        MineBomb(node: gameScene.childNodeWithName("fireMineBomb2")!, mineBombType: .Explosive, effectAreaSize: CGSizeMake(700, 700),alarmArea:300, warningAnimationFrames: loadedWarningAnimationFrames, effectAnimationFrames: loadedEffectAnimationFrames)
        MineBomb(node: gameScene.childNodeWithName("fireMineBomb3")!, mineBombType: .Explosive, effectAreaSize: CGSizeMake(600, 600),alarmArea:250, warningAnimationFrames: loadedWarningAnimationFrames, effectAnimationFrames: loadedEffectAnimationFrames)
        MineBomb(node: gameScene.childNodeWithName("fireMineBomb4")!, mineBombType: .Explosive, effectAreaSize: CGSizeMake(800, 800),alarmArea:350, warningAnimationFrames: loadedWarningAnimationFrames, effectAnimationFrames: loadedEffectAnimationFrames)
        MineBomb(node: gameScene.childNodeWithName("fireMineBomb5")!, mineBombType: .Explosive, effectAreaSize: CGSizeMake(600, 600),alarmArea:250, warningAnimationFrames: loadedWarningAnimationFrames, effectAnimationFrames: loadedEffectAnimationFrames)
        MineBomb(node: gameScene.childNodeWithName("fireMineBomb6")!, mineBombType: .Explosive, effectAreaSize: CGSizeMake(700, 700),alarmArea:300, warningAnimationFrames: loadedWarningAnimationFrames, effectAnimationFrames: loadedEffectAnimationFrames)
        MineBomb(node: gameScene.childNodeWithName("fireMineBomb7")!, mineBombType: .Explosive, effectAreaSize: CGSizeMake(600, 600),alarmArea:250, warningAnimationFrames: loadedWarningAnimationFrames, effectAnimationFrames: loadedEffectAnimationFrames)
        for var i=8;i<29;i++ {
            MineBomb(node: gameScene.childNodeWithName("fireMineBomb\(i)")!, mineBombType: .Explosive, effectAreaSize: CGSizeMake(500, 500),alarmArea:200, warningAnimationFrames: loadedWarningAnimationFrames, effectAnimationFrames: loadedEffectAnimationFrames)
        }
        
        var paths:[SKNode] = pathsAssignment(pathName: "Enemy_Path", initialIndex: 0, finalIndex: 3)
        enemy1 = addEnemyCharacter(characterName: "enemyCharacter1", spawnPoint: "Enemy_Path_0", characterType: EnemyWithSword(), paths: paths, motionType: .Cycled, angle: bottomAngle) as! EnemyWithSword
        paths = pathsAssignment(pathName: "Enemy_Path", initialIndex: 3, finalIndex: 5)
        enemy2 = addEnemyCharacter(characterName: "enemyCharacter2", spawnPoint: "Enemy_Path_3", characterType: EnemyWithSword(), paths: paths, motionType: .Cycled, angle: topAngle) as! EnemyWithSword
        paths = pathsAssignment(pathName: "Enemy_Path", initialIndex: 5, finalIndex: 7)
        enemy3 = addEnemyCharacter(characterName: "enemyCharacter3", spawnPoint: "Enemy_Path_5", characterType: EnemyWithSword(), paths: paths, motionType: .Cycled, angle: rightAngle) as! EnemyWithSword
        paths.removeAll(keepCapacity: false)

    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if let character = contact.bodyA.node as? GameCharacter {
            character.collidedWith(contact.bodyB)
        }
        
        if let character = contact.bodyB.node as? GameCharacter {
            character.collidedWith(contact.bodyA)
        }
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.LivingCreatures != 0) && (secondBody.categoryBitMask & PhysicsCategory.MineBomb != 0)) {
            (secondBody.node as? MineBomb)?.collidedWith(firstBody)
        }
        
    }
    
    // MARK: Scene Processing Support
    
    override func updateWithTimeSinceLastUpdate(timeSinceLast: NSTimeInterval) {
        ron.updateWithTimeSinceLastUpdate(timeSinceLast)
        enemy1.updateWithTimeSinceLastUpdate(timeSinceLast)
        enemy2.updateWithTimeSinceLastUpdate(timeSinceLast)
        enemy3.updateWithTimeSinceLastUpdate(timeSinceLast)

        enemyIsOnEscapeArea(enemies: [enemy1, enemy2], escapePathsNames: [["Escape_Path_17","Escape_Path_16","Escape_Path_15","Escape_Path_11","Escape_Path_10","Escape_Path_14","Escape_Path_13","Escape_Path_12","Escape_Path_1"],["Escape_Path_0","Escape_Path_1","Escape_Path_2","Escape_Path_3",["Escape_Path_4","Escape_Path_5"],"Escape_Path_7","Escape_Path_8"]], locations: [[["spot16","spot15"],["spot14"],["spot13","spot12"],["spot11","spot10"],["spot19"],["spot18","spot17"],["spot12"],["spot11"],["spot20"]],[["spot0","spot3"],["spot1","spot2"],["spot2"],["spot3","spot4"],["spot21","spot5"],["spot7","spot6"],["spot6"]]], withTimeInterval: 1, currentPathsIndexes:[1,0])
        enemyIsOnEscapeArea(enemies: [enemy1,enemy2,enemy3], escapePathsNames: [[["Escape_Path_2","Escape_Path_4"],["Escape_Path_5","Escape_Path_6"],"Escape_Path_7","Escape_Path_8","Escape_Path_9"],["Escape_Path_17","Escape_Path_16","Escape_Path_15","Escape_Path_11","Escape_Path_14","Escape_Path_13","Escape_Path_12","Escape_Path_10"],["Escape_Path_0","Escape_Path_1","Escape_Path_2","Escape_Path_3","Escape_Path_4","Escape_Path_6","Escape_Path_7","Escape_Path_9","Escape_Path_17","Escape_Path_16","Escape_Path_15","Escape_Path_11","Escape_Path_14","Escape_Path_13","Escape_Path_12","Escape_Path_10"]], locations: [[["spot2","spot4","spot3"],["spot21"],["spot7","spot6"],["spot6","spot5","spot21"],["spot8","spot5","spot21"]],[["spot16","spot15"],["spot14"],["spot13","spot12"],["spot11","spot10"],["spot18","spot17"],["spot12"],["spot11"],["spot9","spot8"]],
            [["spot0","spot3"],["spot1","spot2"],["spot2"],["spot3","spot4"],["spot21","spot5"],["spot5"],["spot7"],["spot6"],["spot16","spot15"],["spot14"],["spot13","spot12"],["spot11","spot10"],["spot18","spot17"],["spot12"],["spot11"],["spot9","spot8","spot5"]]], withTimeInterval: 1, currentPathsIndexes: [0,0,0])
        
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
                checkLevelStatus(won: true, nextLevel:Lvl9(size:GameScene.sceneView!.size))
            }
        }
     
        gameConstantProperties.updateMove()
        
        if screenSize.size.width == 480 {
            
        }
        else if screenSize.size.width == 568 {
            centerWorldOnPosition(ron.position, topRestriction: 610, bottomRestriction: -610, rightRestriction: 620, leftRestriction: -610)
        }
        else if screenSize.size.width == 667 {
            
        }
        else if screenSize.size.width == 736 {
            
        }
        else if screenSize.size.width == 768 {
            
        }
        else if screenSize.size.width == 1024 {
            centerWorldOnPosition(ron.position, topRestriction: 490, bottomRestriction: -490, rightRestriction: 725, leftRestriction: -725)
        }
    }
    
}


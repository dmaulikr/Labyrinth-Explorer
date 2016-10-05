//
//  Lvl2.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 4/1/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class Lvl2: MainScene {

    var finalKeyToCompleteTheMission = Item(nodeName: "finalKeyToCompleteTheMission", nodeImageName: "KeyType2_2.png", position: CGPointMake(2143, 395), size: CGSizeMake(39, 39))
    
    var enemy:EnemyWithSword!
    
    var secretButtonIsPressed = false
    
    override func didMoveToView(view: SKView) {
        
        GameScene.sceneView = self
        
        loadWorld()
        
        self.view?.addGestureRecognizer(slowMotionModeGestureRecognizer)
        
    }
    
    override func loadWorld() {
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        if world.parent == nil {
            addChild(world)
        }
        
        gameScene = SKScene(fileNamed:gameMapsHUD.lvl2hudNodeName)!
        gameConstantProperties = GameConstants(heroLivesCount: 3, rotateCharacterToAngle: bottomAngle)
        populateWallsFromWorld()
        loadBackgroundTiles(CGPointMake(0, 0), areaSize: CGSizeMake(gameScene.size.width+256, gameScene.size.height+256), tiles: gameBackgroundTiles.stonyTiles, sizeOfTile: CGSizeMake(256, 256), blendMode: SKBlendMode.Alpha)
        populateDoorsFromWorld()
        populateGatesFromWorld()
        populateTrapsFromWorld()
        populateHideoutsFromWorld()
        populateMaterialUsableAreasFromWorld()
        
        addTrapFireEmitter(node: world.childNodeWithName("fireTrap")!, nodeName: "fireTrap")
        
        world.addChild(finalKeyToCompleteTheMission)
        
        var paths:[SKNode] = pathsAssignment(pathName: "Enemy_Path", initialIndex: 0, finalIndex: 14)
        enemy = addEnemyCharacter(characterName: "enemyCharacter", spawnPoint: "Enemy_Path_0", characterType: EnemyWithSword(), paths: paths, motionType: .Direct, angle: topAngle) as! EnemyWithSword
        paths.removeAll(keepCapacity: false)
        
        world.childNodeWithName("Door")!.runAction(SKAction.rotateToAngle(leftAngle, duration: 0))
        setPhysicsBodyForGates(node: world.childNodeWithName("Gates_Type2")!, size: CGSizeMake(364, 104), centerForPhysicsBody: CGPointMake(0, 0))
        
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

        if ((firstBody.categoryBitMask & PhysicsCategory.UsableItem != 0) && (secondBody.categoryBitMask & PhysicsCategory.Player != 0)) {
            if firstBody.categoryBitMask == 2 {
                gameConstantProperties.createItemSKSpriteNode(parentNodeInHUD: gameConstantProperties.itemsHud, itemKey: finalKeyToCompleteTheMission.name!, itemImageName: "KeyType2_HUD_Item.png", collectedItem:finalKeyToCompleteTheMission)
            }
        }
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) && (secondBody.categoryBitMask & PhysicsCategory.Door != 0)) {
            if secondBody.categoryBitMask == 48 && finalKeyToCompleteTheMission.parent == nil {
                checkLevelStatus(won: true, nextLevel:Lvl3(size:GameScene.sceneView!.size))
            }
        }
    }
    
    // MARK: Scene Processing Support
    
    override func updateWithTimeSinceLastUpdate(timeSinceLast: NSTimeInterval) {
        ron.updateWithTimeSinceLastUpdate(timeSinceLast)
        if !ron.isDying {
            enemy.updateWithTimeSinceLastUpdate(timeSinceLast)
            enemyIsOnEscapeArea(enemies: [enemy], escapePathsNames: [["Escape_Path_4","Escape_Path_1","Escape_Path_2","Escape_Path_3","Escape_Path_0"]], locations: [[["spot1","Enemy_Path_0"],["Enemy_Path_8"],["Enemy_Path_1"],["Enemy_Path_13"],["Enemy_Path_6"]]], withTimeInterval: 0.2, currentPathsIndexes: [1,9,2,0,7])
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
        
        if !secretButtonIsPressed && (world.childNodeWithName("SecretButtonUsableArea") as! SKSpriteNode).containsPoint(ron.position) {
            secretButtonIsPressed = true
            (world.childNodeWithName("SecretButtonUsableArea") as! SKSpriteNode).texture = SKTexture(imageNamed: "Secret_Tile_Button_Type1_Pressed.png")
            (world.childNodeWithName("Gates_Type2") as! SKSpriteNode).runAction(SKAction.animateWithTextures(loadFramesFromAtlasWithName("Gates_Type2"), timePerFrame: 1/20), completion: {
                (world.childNodeWithName("Gates_Type2") as! SKSpriteNode).physicsBody!.categoryBitMask = PhysicsCategory.None
            })
        }
        
        gameConstantProperties.updateMove()
        
        if screenSize.size.width == 480 {
            
        }
        else if screenSize.size.width == 568 {
            centerWorldOnPosition(ron.position, topRestriction: 132, bottomRestriction: -140, rightRestriction: -20, leftRestriction: 40)
        }
        else if screenSize.size.width == 667 {
            
        }
        else if screenSize.size.width == 736 {
            
        }
        else if screenSize.size.width == 768 {
            
        }
        else if screenSize.size.width == 1024 {
            centerWorldOnPosition(ron.position, topRestriction: 0, bottomRestriction: 0, rightRestriction: 85, leftRestriction: -75)
        }
        
    }
    
}

//
//  Lvl1.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 3/5/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class Lvl1: MainScene {
    
    var simpleGates = SKNode()
    
    var spearTrap1 = SKSpriteNode()
    var spearTrap2 = SKSpriteNode()
    var insideWoodStash = InteractingWithStuff(nodeName: "InternalPartOfWoodStash", nodeImageName: "InternalPartOfStashType1.png")
    var keyInsideStash = HiddenItem(nodeName: "KeyForOpeningTheGates", nodeImageName: "KeyType1_1.png", zPosition: 95)
    var finalKeyToCompleteTheMission = Item(nodeName: "finalKeyToCompleteTheMission", nodeImageName: "KeyType2_2.png", position: CGPointMake(1595, 1398), size: CGSizeMake(39, 39))
    
    var gatesAreOpened = false
    
    override func didMoveToView(view: SKView) {
        
        GameScene.sceneView = self
        
        loadWorld()
        
        self.view?.addGestureRecognizer(slowMotionModeGestureRecognizer)

    }
    
    override func loadWorld() {
        
        /*self.size.height *= 4
        self.size.width *= 4
        world.position = CGPointMake(500, 500)*/
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        addChild(world)
        gameScene = SKScene(fileNamed:gameMapsHUD.lvl1hudNodeName)!
        gameConstantProperties = GameConstants(heroLivesCount: 3, rotateCharacterToAngle: rightAngle)
        populateWallsFromWorld()
        loadBackgroundTiles(CGPointMake(0, 0), areaSize: CGSizeMake(gameScene.size.width+256, gameScene.size.height+256), tiles: gameBackgroundTiles.stonyTiles, sizeOfTile: CGSizeMake(256, 256), blendMode: SKBlendMode.Alpha)
        populateMaterialUsableAreasFromWorld()
        populateDoorsFromWorld()
        populateStashesFromWorld()
        populateTrapsFromWorld()
        populateGatesFromWorld()
        
        let spearVertical = loadFramesFromAtlasWithName("SpearVertical")
        
        spearTrap1 = setupSpearTrap(node: world.childNodeWithName("spearTrap1")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 11, waitingDuration: 2) as! SKSpriteNode
        spearTrap2 = setupSpearTrap(node: world.childNodeWithName("spearTrap2")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 11, waitingDuration: 3) as! SKSpriteNode
        
        simpleGates = world.childNodeWithName("Gates_Type1")!
        
        setPhysicsBodyForGates(node:simpleGates, size: CGSizeMake(267, 10), centerForPhysicsBody: CGPointMake(0, 40))
        
        addTrapFireEmitter(node: world.childNodeWithName("fireTrap")!, nodeName: "fireTrap")
        
        if screenSize.size.width == 480 {
            
        }
        else if screenSize.size.width == 568 {
            insideWoodStash.position = CGPointMake(570, 300)
            insideWoodStash.size = CGSizeMake(GameScene.sceneView!.frame.size.width+150, GameScene.sceneView!.frame.size.height+150)
            
            keyInsideStash.position = CGPointMake(200, 100)
            keyInsideStash.size = CGSizeMake(100, 100)
        }
        else if screenSize.size.width == 667 {
            
        }
        else if screenSize.size.width == 736 {
            
        }
        else if screenSize.size.width == 768 {
            
        }
        else if screenSize.size.width == 1024 {
            insideWoodStash.position = CGPointMake(518, 363)
            insideWoodStash.size = CGSizeMake(GameScene.sceneView!.frame.size.width+150, GameScene.sceneView!.frame.size.height+150)
            keyInsideStash.position = CGPointMake(145, 160)
            keyInsideStash.size = CGSizeMake(100, 100)
        }
        
        world.addChild(finalKeyToCompleteTheMission)
        insideWoodStash.addChild(keyInsideStash)
        
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

        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) && (secondBody.categoryBitMask & PhysicsCategory.BlockingTrap != 0)) {
            if secondBody.categoryBitMask == 14 && keyInsideStash.parent == nil && !gatesAreOpened {
                if (secondBody.node == simpleGates) {
                    gatesAreOpened = true
                    gameConstantProperties.removeItemFromItemsHUD(keyForItem: self.keyInsideStash.name!)
                    simpleGates.runAction(SKAction.animateWithTextures(loadFramesFromAtlasWithName("Gates_Type1"), timePerFrame: 1/18), completion: {
                        BlockingArea(nodeName: "BlockingArea1", position: gameScene.childNodeWithName("BlockingArea1")!.position, size: gameScene.childNodeWithName("BlockingArea1")!.frame.size)
                        
                        BlockingArea(nodeName: "BlockingArea2", position: gameScene.childNodeWithName("BlockingArea2")!.position, size: gameScene.childNodeWithName("BlockingArea2")!.frame.size)
                        self.simpleGates.physicsBody!.categoryBitMask = PhysicsCategory.None
                    })
                }
            }
        }
        if ((firstBody.categoryBitMask & PhysicsCategory.UsableItem != 0) && (secondBody.categoryBitMask & PhysicsCategory.Player != 0)) {
            if firstBody.categoryBitMask == 2 {
                gameConstantProperties.createItemSKSpriteNode(parentNodeInHUD: gameConstantProperties.itemsHud, itemKey: finalKeyToCompleteTheMission.name!, itemImageName: "KeyType2_HUD_Item.png", collectedItem:finalKeyToCompleteTheMission)
            }
        }
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) && (secondBody.categoryBitMask & PhysicsCategory.Door != 0)) {
            if secondBody.categoryBitMask == 48 && finalKeyToCompleteTheMission.parent == nil {
                checkLevelStatus(won: true, nextLevel:Lvl2(size:GameScene.sceneView!.size))
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    //MARK: Inside Stash
        
        for touchOnShelf in touches {
            let shelfNode = world.childNodeWithName("woodStash_Stuff") as SKNode!
            let shelfNodeUsableArea = world.childNodeWithName("woodstashUsableArea") as! SKShapeNode
            let touchedNode:SKNode = nodeAtPoint((touchOnShelf ).locationInNode(self))
            
            if touchedNode.name == "woodStash_Stuff" && shelfNodeUsableArea.containsPoint(ron.position)
            {
                addChild(insideWoodStash)
                addBackButton()
                moveJoystick.removeFromParent()
            }
            else if back_Button.containsPoint((touchOnShelf ).locationInNode(self)) && back_Button.parent != nil {
                back_Button.removeFromParent()
                insideWoodStash.removeFromParent()
                addChild(moveJoystick)
            }
            else if keyInsideStash == touchedNode && keyInsideStash.parent != nil {
                gameConstantProperties.createItemSKSpriteNode(parentNodeInHUD: gameConstantProperties.itemsHud, itemKey: keyInsideStash.name!, itemImageName: "KeyType1_HUD_Item.png", collectedItem:keyInsideStash)
            }
        }
        
        for touch in touches {
            gameConstantProperties.eventIsOnProcess(touch , event: 2)
        }
    }
    
    // MARK: Scene Processing Support
    
    override func updateWithTimeSinceLastUpdate(timeSinceLast: NSTimeInterval) {
        ron.updateWithTimeSinceLastUpdate(timeSinceLast)
        
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
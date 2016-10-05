//
//  Lvl3.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 4/12/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class Lvl9: MainScene {
    
    var spearTrap1 = SKSpriteNode()
    var spearTrap2 = SKSpriteNode()
    var spearTrap3 = SKSpriteNode()
    var spearTrap4 = SKSpriteNode()
    var spearTrap5 = SKSpriteNode()
    var spearTrap6 = SKSpriteNode()
    var spearTrap7 = SKSpriteNode()
    var spearTrap8 = SKSpriteNode()
    var spearTrap9 = SKSpriteNode()
    var spearTrap10 = SKSpriteNode()
    var spearTrap11 = SKSpriteNode()
    var spearTrap12 = SKSpriteNode()
    var spearTrap13 = SKSpriteNode()
    var spearTrap14 = SKSpriteNode()
    var spearTrap15 = SKSpriteNode()
    var spearTrap16 = SKSpriteNode()
    var spearTrap17 = SKSpriteNode()
    
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
        
        gameScene = SKScene(fileNamed:gameMapsHUD.lvl9hudNodeName)
        gameConstantProperties = GameConstants(heroLivesCount: 3, rotateCharacterToAngle: rightAngle)
        populateWallsFromWorld()
        loadBackgroundTiles(CGPointMake(0, 0), areaSize: CGSizeMake(gameScene.size.width+256, gameScene.size.height+256), tiles: gameBackgroundTiles.stonyTiles, sizeOfTile: CGSizeMake(256, 256), blendMode: SKBlendMode.Alpha)
        populateTrapsFromWorld()
        
        let spearVertical = loadFramesFromAtlasWithName("SpearVertical")
        let spearHorizontal = loadFramesFromAtlasWithName("SpearHorizontal")
        
        spearTrap1 = setupSpearTrap(node: world.childNodeWithName("spearTrap1")!, animationFrames: spearHorizontal, beginningPosition: 0, endingPosition: 14, waitingDuration: 2) as! SKSpriteNode
        spearTrap2 = setupSpearTrap(node: world.childNodeWithName("spearTrap2")!, animationFrames: spearHorizontal, beginningPosition: 0, endingPosition: 14, waitingDuration: 3) as! SKSpriteNode
        spearTrap3 = setupSpearTrap(node: world.childNodeWithName("spearTrap3")!, animationFrames: spearHorizontal, beginningPosition: 0, endingPosition: 14, waitingDuration: 4) as! SKSpriteNode
        spearTrap4 = setupSpearTrap(node: world.childNodeWithName("spearTrap4")!, animationFrames: spearHorizontal, beginningPosition: 0, endingPosition: 14, waitingDuration: 3) as! SKSpriteNode
        spearTrap5 = setupSpearTrap(node: world.childNodeWithName("spearTrap5")!, animationFrames: spearHorizontal, beginningPosition: 0, endingPosition: 12, waitingDuration: 2) as! SKSpriteNode
        spearTrap6 = setupSpearTrap(node: world.childNodeWithName("spearTrap6")!, animationFrames: spearHorizontal, beginningPosition: 0, endingPosition: 9, waitingDuration: 3) as! SKSpriteNode
        spearTrap7 = setupSpearTrap(node: world.childNodeWithName("spearTrap7")!, animationFrames: spearHorizontal, beginningPosition: 0, endingPosition: 11, waitingDuration: 2) as! SKSpriteNode
        spearTrap8 = setupSpearTrap(node: world.childNodeWithName("spearTrap8")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 14, waitingDuration: 3) as! SKSpriteNode
        spearTrap9 = setupSpearTrap(node: world.childNodeWithName("spearTrap9")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 14, waitingDuration: 4) as! SKSpriteNode
        spearTrap10 = setupSpearTrap(node: world.childNodeWithName("spearTrap10")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 14, waitingDuration: 3) as! SKSpriteNode
        spearTrap11 = setupSpearTrap(node: world.childNodeWithName("spearTrap11")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 14, waitingDuration: 4) as! SKSpriteNode
        spearTrap12 = setupSpearTrap(node: world.childNodeWithName("spearTrap12")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 14, waitingDuration: 2) as! SKSpriteNode
        spearTrap13 = setupSpearTrap(node: world.childNodeWithName("spearTrap13")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 14, waitingDuration: 3) as! SKSpriteNode
        spearTrap14 = setupSpearTrap(node: world.childNodeWithName("spearTrap14")!, animationFrames: spearHorizontal, beginningPosition: 0, endingPosition: 13, waitingDuration: 2) as! SKSpriteNode
        spearTrap15 = setupSpearTrap(node: world.childNodeWithName("spearTrap15")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 14, waitingDuration: 2) as! SKSpriteNode
        spearTrap16 = setupSpearTrap(node: world.childNodeWithName("spearTrap16")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 14, waitingDuration: 4) as! SKSpriteNode
        spearTrap17 = setupSpearTrap(node: world.childNodeWithName("spearTrap17")!, animationFrames: spearVertical, beginningPosition: 0, endingPosition: 14, waitingDuration: 3) as! SKSpriteNode
        
        addTrapFireEmitter(node: world.childNodeWithName("fireTrap1")!, nodeName: "fireTrap1")
        addTrapFireEmitter(node: world.childNodeWithName("fireTrap2")!, nodeName: "fireTrap2")
        addTrapFireEmitter(node: world.childNodeWithName("fireTrap3")!, nodeName: "fireTrap3")
        addTrapFireEmitter(node: world.childNodeWithName("fireTrap4")!, nodeName: "fireTrap4")
        addTrapFireEmitter(node: world.childNodeWithName("fireTrap5")!, nodeName: "fireTrap5")
        addTrapFireEmitter(node: world.childNodeWithName("fireTrap6")!, nodeName: "fireTrap6")
        addTrapFireEmitter(node: world.childNodeWithName("fireTrap7")!, nodeName: "fireTrap7")
        
        populateDoorsFromWorld()
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
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) && (secondBody.categoryBitMask & PhysicsCategory.Door != 0)) {
            if secondBody.categoryBitMask == 48 {
                let reveal = SKTransition.doorsCloseHorizontalWithDuration(0.5)
                let sceneStatus = LevelStatus(size: GameScene.sceneView!.size, won: true, nextLevel:MainScene())
                GameScene.sceneView!.view!.presentScene(sceneStatus, transition: reveal)
            }
        }
        
    }
    
    // MARK: Scene Processing Support
    
    override func updateWithTimeSinceLastUpdate(timeSinceLast: NSTimeInterval) {
        ron.updateWithTimeSinceLastUpdate(timeSinceLast)
        gameConstantProperties.updateMove()
        
        if screenSize.size.width == 480 {
            
        }
        else if screenSize.size.width == 568 {
            centerWorldOnPosition(ron.position, topRestriction: 911, bottomRestriction: -900, rightRestriction: -12, leftRestriction: 40)
        }
        else if screenSize.size.width == 667 {
            
        }
        else if screenSize.size.width == 736 {
            
        }
        else if screenSize.size.width == 768 {
            
        }
        else if screenSize.size.width == 1024 {
            centerWorldOnPosition(ron.position, topRestriction: 770, bottomRestriction: -775, rightRestriction: 80, leftRestriction: -80)
        }
    }
    
}

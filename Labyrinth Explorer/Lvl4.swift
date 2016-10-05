//
//  Lvl4.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 4/16/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import UIKit
import SpriteKit

class Lvl4: MainScene {
    
    var enemy:EnemyWithGun!
    var blockingGates1 = SKSpriteNode()
    var blockingGates2 = SKSpriteNode()
    var callNumberNoteOnTable = SKSpriteNode()
    var insideWoodStash = InteractingWithStuff(nodeName: "InternalPartOfWoodStash", nodeImageName: "InternalPartOfStashType1.png")
    var leverBoneInsideStash = HiddenItem(nodeName: "leverBoneInsideStash", nodeImageName: "LeverBoneType1.png", zPosition: 97)
    var headBoneInsideStash = HiddenItem(nodeName: "headBoneInsideStash", nodeImageName: "HeadBoneType1.png", zPosition: 96)
    var radioTransmitterInsideStash = HiddenItem(nodeName: "radioTransmitterInsideStash", nodeImageName: "RadioTransmitter.png", zPosition: 97)
    var wallBackground = InteractingWithStuff(nodeName: "wallBackground", nodeImageName: "WallBackgroundType2.png")
    var leverStock = HiddenItem(nodeName: "StockWithoutLever", nodeImageName: "StockWithoutLever.png", zPosition: 96)
    var table = InteractingWithStuff(nodeName: "table", nodeImageName: "TableType1Background.png")
    var tableNote = SKSpriteNode(color: UIColor(red: 225/255, green: 225/255, blue: 188/255, alpha: 1), size: CGSizeMake(250, 250))
    var numberToCall = SKLabelNode(fontNamed: "AvenirNext-DemiBoldItalic")
    var TNT = HiddenItem(nodeName: "TNT", nodeImageName: "TNT.png", zPosition: 0)
    var radioTransmitter = RadioTransmitter(zPosition: 100, size: CGSizeMake(200, 455))
    var enemyIsAway = false
    var heroIsAway = false
    var guardIsDismissed = false
    var TNTplacingPosition = SKSpriteNode(texture: SKTexture(imageNamed: "ActivationPoint_0020.png"))
    var explosion1 = HiddenItem(nodeName: "explosion1", nodeImageName: "ExplosionType1_40.png", zPosition: 51)
    var explosion2 = HiddenItem(nodeName: "explosion2", nodeImageName: "ExplosionType1_40.png", zPosition: 51)
    var explosion3 = HiddenItem(nodeName: "explosion3", nodeImageName: "ExplosionType1_40.png", zPosition: 51)
    var explosion4 = HiddenItem(nodeName: "explosion4", nodeImageName: "ExplosionType1_40.png", zPosition: 51)
    
    //CURRENT ATTRIBUTES FOR iPhone 5s
    
    var leverStockActivationPoint1 = PointToUseForSomeAction(nodeName: "leverStockActivationPoint1", position: CGPointMake(145, 180), size: CGSizeMake(100, 100), zPosition: 97, pointBlinkingInterval: 0.03, blinkingPointAtlasTextures: loadFramesFromAtlasWithName("ActivationPoint"))
    
    var leverStockActivationPoint2 = PointToUseForSomeAction(nodeName: "leverStockActivationPoint2", position: CGPointMake(155, 25), size: CGSizeMake(100, 100), zPosition: 97, pointBlinkingInterval: 0.03, blinkingPointAtlasTextures: loadFramesFromAtlasWithName("ActivationPoint"))
    
    var leverStockActivationPoint3 = PointToUseForSomeAction(nodeName: "leverStockActivationPoint3", position: CGPointMake(150, -50), size: CGSizeMake(100, 100), zPosition: 97, pointBlinkingInterval: 0.03, blinkingPointAtlasTextures: loadFramesFromAtlasWithName("ActivationPoint"))
    
    var enemyInAction = false
    
    override func didMoveToView(view: SKView) {
        
        GameScene.sceneView = self
        
        self.backgroundColor = UIColor.blackColor()
        
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
        
        gameScene = SKScene(fileNamed:gameMapsHUD.lvl4hudNodeName)
        gameConstantProperties = GameConstants(heroLivesCount: 3, rotateCharacterToAngle: topAngle)
        
        populateWallsFromWorld()
        loadBackgroundTiles(CGPointMake(0, 0), areaSize: CGSizeMake(gameScene.size.width+256, gameScene.size.height+256), tiles: gameBackgroundTiles.stonyTiles, sizeOfTile: CGSizeMake(256, 256), blendMode: SKBlendMode.Alpha)
        populateMaterialUsableAreasFromWorld()
        populateStashesFromWorld()
        populateGatesFromWorld()

        gameConstantProperties.initializeSelectionIndicator()
        
        enemy = addEnemyCharacter(characterName: "enemyCharacter", spawnPoint: "Enemy_Path_0", characterType: EnemyWithGun(), paths: [], motionType: .None, angle: bottomAngle) as! EnemyWithGun
        
        blockingGates1 = world.childNodeWithName("Gates_Type2_1")! as! SKSpriteNode
        setPhysicsBodyForGates(node: blockingGates1, size: blockingGates1.size
            , centerForPhysicsBody: CGPointMake(0, 0))
        blockingGates2 = world.childNodeWithName("Gates_Type2_2")! as! SKSpriteNode
        setPhysicsBodyForGates(node: blockingGates2, size: blockingGates2.size, centerForPhysicsBody: CGPointMake(0, 0))
        
        if screenSize.size.width == 480 {
            
        }
        else if screenSize.size.width == 568 {
            insideWoodStash.position = CGPointMake(570, 300)
            
            headBoneInsideStash.position = CGPointMake(200, 200)
            
            leverBoneInsideStash.position = CGPointMake(-100, 120)
            
            radioTransmitterInsideStash.position = CGPointMake(-200, -200)
            
            wallBackground.position = CGPointMake(570, 300)
            
            leverStock.position = CGPointMake(30, 30)
            
            table.position = CGPointMake(568, 300)
            
            tableNote.position = CGPointMake(-200, 0)
            
            TNT.position = CGPointMake(400, -50)
            
        }
        else if screenSize.size.width == 667 {
            
        }
        else if screenSize.size.width == 736 {
            
        }
        else if screenSize.size.width == 768 {
            
        }
        else if screenSize.size.width == 1024 {
            
            insideWoodStash.position = CGPointMake(518, 363)
            
            headBoneInsideStash.position = CGPointMake(120, 230)
            
            
            leverBoneInsideStash.position = CGPointMake(-180, 170)
            
            
            radioTransmitterInsideStash.position = CGPointMake(-160, -220)
            
            
            wallBackground.position = CGPointMake(518, 363)
            
            
            leverStock.position = CGPointMake(30, 30)
            
            
            table.position = CGPointMake(515, 363)
            
            
            tableNote.position = CGPointMake(-200, 0)
            
            TNT.position = CGPointMake(300, -150)
            
        }
        
        insideWoodStash.size = CGSizeMake(GameScene.sceneView!.frame.size.width+150, GameScene.sceneView!.frame.size.height+150)
        
        headBoneInsideStash.size = CGSizeMake(200, 200)
        leverBoneInsideStash.size = CGSizeMake(200, 200)
        radioTransmitterInsideStash.size = CGSizeMake(100, 100)
        wallBackground.size = CGSizeMake(GameScene.sceneView!.frame.size.width+150, GameScene.sceneView!.frame.size.height+150)
        leverStock.size = CGSizeMake(300, 600)
        table.size = CGSizeMake(GameScene.sceneView!.frame.size.width+10, GameScene.sceneView!.frame.size.width)
        TNT.size = CGSizeMake(300, 300)
        
        radioTransmitter.position = CGPointMake(GameScene.sceneView!.frame.size.width-150, 350-self.frame.height)
        
        radioTransmitter.radioTransmitterSurface.position = CGPointMake(0, -100)
        radioTransmitter.digitsDisplay.size = CGSizeMake(180, 40)
        radioTransmitter.digitsDisplay.position = CGPointMake(0, 20)
        
        radioTransmitter.callButton.position = CGPointMake(-65, -35)
        radioTransmitter.callButton.size = CGSizeMake(50, 50)
        
        radioTransmitter.oneButton.position = CGPointMake(-65, -95)
        radioTransmitter.oneButton.size = CGSizeMake(50, 50)
        
        radioTransmitter.fourButton.position = CGPointMake(-65, -155)
        radioTransmitter.fourButton.size = CGSizeMake(50, 50)
        
        radioTransmitter.sevenButton.position = CGPointMake(-65, -215)
        radioTransmitter.sevenButton.size = CGSizeMake(50, 50)
        
        radioTransmitter.zeroButton.position = CGPointMake(0, -35)
        radioTransmitter.zeroButton.size = CGSizeMake(50, 50)
        
        radioTransmitter.twoButton.position = CGPointMake(0, -95)
        radioTransmitter.twoButton.size = CGSizeMake(50, 50)
        
        radioTransmitter.fiveButton.position = CGPointMake(0, -155)
        radioTransmitter.fiveButton.size = CGSizeMake(50, 50)
        
        radioTransmitter.eightButton.position = CGPointMake(0, -215)
        radioTransmitter.eightButton.size = CGSizeMake(50, 50)
        
        radioTransmitter.denyCallButton.position = CGPointMake(65, -35)
        radioTransmitter.denyCallButton.size = CGSizeMake(50, 50)
        
        radioTransmitter.threeButton.position = CGPointMake(65, -95)
        radioTransmitter.threeButton.size = CGSizeMake(50, 50)
        
        radioTransmitter.sixButton.position = CGPointMake(65, -155)
        radioTransmitter.sixButton.size = CGSizeMake(50, 50)
        
        radioTransmitter.nineButton.position = CGPointMake(65, -215)
        radioTransmitter.nineButton.size = CGSizeMake(50, 50)
        
        radioTransmitter.sattelite.position = CGPointMake(95, 130)
        radioTransmitter.satteliteBall.position = CGPointMake(95, 218)
        
        insideWoodStash.addChild(headBoneInsideStash)
        
        insideWoodStash.addChild(leverBoneInsideStash)
        
        insideWoodStash.addChild(radioTransmitterInsideStash)
        
        wallBackground.addChild(leverStock)
        
        tableNote.runAction(SKAction.rotateByAngle(CGFloat(M_PI_2/3), duration: 0))
        
        table.addChild(tableNote)
        
        numberToCall.fontColor = UIColor.blackColor()
        for number in gameConstantProperties.generateRandomFigures(8, itIsNumbers: true, figures: []) {
            numberToCall.text+=number as! String
        }
        
        tableNote.addChild(numberToCall)
        
        table.addChild(TNT)
        
        TNTplacingPosition.size = gameScene.childNodeWithName("Enemy_Path_0")!.frame.size
        TNTplacingPosition.position = gameScene.childNodeWithName("Enemy_Path_0")!.position
        world.addChild(TNTplacingPosition)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if let character = contact.bodyA.node as? GameCharacter {
            character.collidedWith(contact.bodyB)
        }
        
        if let character = contact.bodyB.node as? GameCharacter {
            character.collidedWith(contact.bodyA)
        }

    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //MARK: Inside Stash
        
        if !ron.lockTouchActions {
            for touchOnStuff in touches {
                
                let touchedNode:SKNode = nodeAtPoint((touchOnStuff ).locationInNode(self))
                
                let shelfNode = world.childNodeWithName("woodStash_Stuff") as SKNode!
                let shelfNodeUsableArea = world.childNodeWithName("woodstashUsableArea") as! SKShapeNode
                
                let leverNode = world.childNodeWithName("lever_Stuff") as SKNode!
                let leverNodeUsableArea = world.childNodeWithName("leverUsableArea") as! SKShapeNode
                
                let tableNode = world.childNodeWithName("table_Stuff") as SKNode!
                let tableNodeUsableArea = world.childNodeWithName("tableUsableArea") as! SKShapeNode
                
                if radioTransmitter.actionForKey("radioTransmitterAppearance") == nil {
                    if gameConstantProperties.itemsHud.childNodeWithName(leverBoneInsideStash.name!) == touchedNode {
                        
                        gameConstantProperties.enableSelectionForItem(leverBoneInsideStash, targets: [leverStock])
                        
                        if !radioTransmitter.dismissed {
                            radioTransmitter.dismissRadioTransmitter()
                        }
                        
                    }
                    else if gameConstantProperties.itemsHud.childNodeWithName(radioTransmitterInsideStash.name!) == touchedNode {
                        
                        gameConstantProperties.enableSelectionForItem(radioTransmitterInsideStash, targets: [])
                        
                        var fixedPositionOfRadioTransmitter:CGPoint?
                        
                        if radioTransmitterInsideStash.isAboutToBeUsedOnTarget {
                            radioTransmitter.dismissed = false
                            
                            addChild(radioTransmitter)
                            
                            fixedPositionOfRadioTransmitter = CGPointMake(self.radioTransmitter.position.x, self.radioTransmitter.position.y+self.frame.height)
                            
                            radioTransmitter.runAction(SKAction.moveTo(fixedPositionOfRadioTransmitter!, duration: 1), withKey:"radioTransmitterAppearance")
                            
                        }
                        else {
                            radioTransmitter.dismissRadioTransmitter()
                        }
                        
                    }
                    else if gameConstantProperties.itemsHud.childNodeWithName(TNT.name!) == touchedNode && enemy.parent == nil {
                        gameConstantProperties.enableSelectionForItem(TNT, targets: [TNTplacingPosition])
                        
                        if !radioTransmitter.dismissed {
                            radioTransmitter.dismissRadioTransmitter()
                        }
                        
                    }
                    else if !gameConstantProperties.selectionIndicator.hidden && radioTransmitterInsideStash.isAboutToBeUsedOnTarget {
                        let action = SKAction.sequence([
                            SKAction.runBlock({
                                back_Button.removeFromParent()
                                moveJoystick.removeFromParent()
                                
                                gameConstantProperties.selectionIndicator.hidden = true
                                gameConstantProperties.removeItemFromItemsHUD(keyForItem: self.radioTransmitterInsideStash.name!)
                                
                                self.enemy.removeActionForKey("enemyAction")
                                
                                self.radioTransmitter.dismissRadioTransmitter()
                                
                            }),
                            SKAction.fadeOutWithDuration(2),
                            SKAction.runBlock({
                                self.table.removeFromParent()
                                let expectedPositionOfWorld = CGPoint(x:-self.enemy.position.x + CGRectGetMidX(self.frame),
                                    y: -self.enemy.position.y + CGRectGetMidY(self.frame))
                                world.runAction(SKAction.moveTo(
                                    expectedPositionOfWorld, duration: 0))
                            }),
                            SKAction.fadeInWithDuration(1),
                            SKAction.runBlock({
                                self.enemyIsAway = true
                            })
                            ])
                        
                        radioTransmitter.animateDialing(numberToCall.text, touchedNode: touchedNode, action:action)
                        
                    }
                    else if !gameConstantProperties.selectionIndicator.hidden {
                        gameConstantProperties.selectionIndicator.hidden = true
                        if leverBoneInsideStash.isAboutToBeUsedOnTarget && leverStock == touchedNode {
                            
                            gameConstantProperties.removeIndicatorsForTargets(gameConstantProperties.lastSelectedItem, enableUseForItem: false, targets: gameConstantProperties.lastTargets)
                            
                            leverStock.texture = SKTexture(imageNamed: "BoneLeverInAction_0001.png")
                            
                            wallBackground.addChild(leverStockActivationPoint1)
                            
                            gameConstantProperties.removeItemFromItemsHUD(keyForItem: leverBoneInsideStash.name!)
                            
                        }
                        else if TNT.isAboutToBeUsedOnTarget && TNTplacingPosition.containsPoint(ron.position) && TNTplacingPosition == touchedNode {
                            
                            gameConstantProperties.removeIndicatorsForTargets(gameConstantProperties.lastSelectedItem, enableUseForItem: false, targets: gameConstantProperties.lastTargets)
                            
                            gameConstantProperties.removeItemFromItemsHUD(keyForItem: TNT.name!)
                            
                            moveJoystick.removeFromParent()
                            TNT.removeFromParent()
                            TNT.size = CGSizeMake(70, 70)
                            TNT.position = CGPointMake(0, 0)
                            TNTplacingPosition.addChild(TNT)
                            ron.lockTouchActions = true
                            heroIsAway = true
                            
                        }
                        else {
                            gameConstantProperties.removeIndicatorsForTargets(gameConstantProperties.lastSelectedItem, enableUseForItem: false, targets: gameConstantProperties.lastTargets)
                            return
                        }
                    }
                }
                
                if touchedNode.name == "woodStash_Stuff" && shelfNodeUsableArea.containsPoint(ron.position) {
                    addChild(insideWoodStash)
                    addBackButton()
                    moveJoystick.removeFromParent()
                }
                else if touchedNode.name == "lever_Stuff" && leverNodeUsableArea.containsPoint(ron.position) {
                    addChild(wallBackground)
                    addBackButton()
                    moveJoystick.removeFromParent()
                }
                else if touchedNode.name == "table_Stuff" && tableNodeUsableArea.containsPoint(ron.position) {
                    addChild(table)
                    addBackButton()
                    moveJoystick.removeFromParent()
                }
                
                if back_Button == touchedNode && back_Button.parent != nil {
                    wallBackground.removeFromParent()
                    insideWoodStash.removeFromParent()
                    table.removeFromParent()
                    back_Button.removeFromParent()
                    addChild(moveJoystick)
                }
                
                if leverBoneInsideStash == touchedNode && leverBoneInsideStash.parent != nil {
                    gameConstantProperties.createItemSKSpriteNode(parentNodeInHUD: gameConstantProperties.itemsHud, itemKey: leverBoneInsideStash.name!, itemImageName: "BoneType1_HUD_Item.png", collectedItem:leverBoneInsideStash)
                }
                else if radioTransmitterInsideStash == touchedNode && radioTransmitterInsideStash.parent != nil {
                    gameConstantProperties.createItemSKSpriteNode(parentNodeInHUD: gameConstantProperties.itemsHud, itemKey: radioTransmitterInsideStash.name!, itemImageName: "RadioTransmitter_HUD_Item.png", collectedItem:radioTransmitterInsideStash)
                }
                else if TNT == touchedNode && TNT.parent != nil {
                    gameConstantProperties.createItemSKSpriteNode(parentNodeInHUD: gameConstantProperties.itemsHud, itemKey: TNT.name!, itemImageName: "TNT_HUD_Item.png", collectedItem:TNT)
                }
                
                if leverStockActivationPoint1 == touchedNode && !leverStock.animated {
                    leverStock.animateAltasWithTexturesOfTheHiddenItem(frameFromAtlas: loadFramesFromAtlasWithName("BoneLeverInAction"), beginningPosition: 0, endingPosition: 14, durationAnimationPerTexture: 0.05, cycledAnimation: false, momentOfExpectationForTheNextAnimationCycle: 0, completion: {
                        self.leverStockActivationPoint1.removeFromParent()
                        self.wallBackground.addChild(self.leverStockActivationPoint2)
                    })
                }
                else if leverStockActivationPoint2 == touchedNode && !leverStock.animated {
                    leverStock.animateAltasWithTexturesOfTheHiddenItem(frameFromAtlas: loadFramesFromAtlasWithName("BoneLeverInAction"), beginningPosition: 14, endingPosition: 29, durationAnimationPerTexture: 0.05, cycledAnimation: false, momentOfExpectationForTheNextAnimationCycle: 0, completion: {
                        self.leverStockActivationPoint2.removeFromParent()
                        self.wallBackground.addChild(self.leverStockActivationPoint3)
                    })
                }
                else if leverStockActivationPoint3 == touchedNode && !leverStock.animated {
                    leverStock.animateAltasWithTexturesOfTheHiddenItem(frameFromAtlas: loadFramesFromAtlasWithName("BoneLeverInAction"), beginningPosition: 29, endingPosition: 44, durationAnimationPerTexture: 0.05, cycledAnimation: false, momentOfExpectationForTheNextAnimationCycle: 0, completion: {
                        self.leverStockActivationPoint3.removeFromParent()
                        self.blockingGates1.runAction(SKAction.animateWithTextures(loadFramesFromAtlasWithName("Gates_Type2"), timePerFrame: 1/20), completion: {
                            self.blockingGates1.physicsBody!.categoryBitMask = PhysicsCategory.None
                        })
                    })
                }
            }
            
            for touch in touches {
                gameConstantProperties.eventIsOnProcess(touch , event: 2)
            }
        }
        
    }
    
    // MARK: Scene Processing Support
    
    override func updateWithTimeSinceLastUpdate(timeSinceLast: NSTimeInterval) {
        ron.updateWithTimeSinceLastUpdate(timeSinceLast)
        if !ron.isDying {
            enemy.updateWithTimeSinceLastUpdate(timeSinceLast)
            if !ron.isDetected && !enemyIsAway {
                if !enemyInAction {
                    enemyInAction = true
                    enemy.runAction(SKAction.repeatActionForever(SKAction.sequence([
                        SKAction.runBlock({
                            self.enemy.faceToPosition(gameScene.childNodeWithName("starePoint1")!.position, withDuration: 2, isItCounterClockWiseRotation: false)
                        }),
                        SKAction.waitForDuration(3),
                        SKAction.runBlock({
                            self.enemy.faceToPosition(gameScene.childNodeWithName("starePoint2")!.position, withDuration: 2, isItCounterClockWiseRotation: false)
                        }),
                        SKAction.waitForDuration(3),
                        ])), withKey: "enemyAction")
                }
            }
            else if ron.isDetected {
                if enemyInAction {
                    enemy.removeActionForKey("enemyAction")
                }
                enemyInAction = false
            }
            
            if enemyIsAway {
            self.enemy.moveTowardsPosition(gameScene.childNodeWithName("EnemyAway")!.position, withTimeInterval: timeSinceLast)
                
                self.enemy.movementSpeed = self.enemy.movementSpeed+10
                self.enemy.requestedAnimation = .Run
                
                if self.enemy.position == gameScene.childNodeWithName("EnemyAway")!.position && !guardIsDismissed {
                    
                    guardIsDismissed = true
                    self.enemy.removeFromParent()
                    
                    self.runAction(SKAction.sequence([
                        SKAction.fadeOutWithDuration(2),
                        SKAction.runBlock({
                            self.enemyIsAway = false
                            ron.lockTouchActions = false
                            self.radioTransmitter.removeFromParent()
                        }),
                        SKAction.fadeInWithDuration(2),
                        SKAction.runBlock({
                            self.addChild(moveJoystick)
                            self.guardIsDismissed = false
                        })
                        ]))
                    
                }
                
            }
            
            if heroIsAway {
                
                if !guardIsDismissed {
                    ron.moveTowardsPosition(gameScene.childNodeWithName("HeroAway")!.position, withTimeInterval: timeSinceLast, running: true)
                }
                
                if ron.position == gameScene.childNodeWithName("HeroAway")!.position && !guardIsDismissed {
                    guardIsDismissed = true
                    ron.movementSpeed = 0
                    ron.runAction(SKAction.sequence([SKAction.runBlock({ron.faceToPosition(
                        self.TNTplacingPosition.position, withDuration: 1, isItCounterClockWiseRotation: true)
                    }), SKAction.waitForDuration(2.0)]), completion:{
                        self.TNTplacingPosition.removeFromParent()
                        ron.runAction(SKAction.sequence([
                            SKAction.runBlock({
                                self.bigBang(self.explosion1)
                                self.bigBang(self.explosion2)
                            }),
                            SKAction.waitForDuration(0.3),
                            SKAction.runBlock({
                                self.bigBang(self.explosion4)
                            }),
                            SKAction.waitForDuration(0.2),
                            SKAction.runBlock({
                                self.bigBang(self.explosion3)
                            })
                            ]))
                        
                        self.blockingGates2.runAction(SKAction.sequence([SKAction.waitForDuration(5.0),SKAction.animateWithTextures(loadFramesFromAtlasWithName("Gates_Type2_Explosion"), timePerFrame: 0.1, resize: false, restore: false),SKAction.waitForDuration(0.3)
                            ]), completion:{
                                self.runAction(SKAction.sequence([
                                    SKAction.fadeOutWithDuration(2),
                                    SKAction.runBlock({
                                        self.heroIsAway = false
                                        ron.lockTouchActions = false
                                        self.blockingGates2.physicsBody?.categoryBitMask = PhysicsCategory.None
                                    }),
                                    SKAction.fadeInWithDuration(2),
                                    SKAction.runBlock({
                                        self.addChild(moveJoystick)
                                    })
                                    ]))
                                
                        })
                        
                    })
                }

            }
        }
        if !ron.lockTouchActions {
            gameConstantProperties.updateMove()
            
            if screenSize.size.width == 480 {
                
            }
            else if screenSize.size.width == 568 {
                centerWorldOnPosition(ron.position, topRestriction: 360, bottomRestriction: -350, rightRestriction: -20, leftRestriction: 40)
            }
            else if screenSize.size.width == 667 {
                
            }
            else if screenSize.size.width == 736 {
                
            }
            else if screenSize.size.width == 768 {
                
            }
            else if screenSize.size.width == 1024 {
                centerWorldOnPosition(ron.position, topRestriction: 240, bottomRestriction: -230, rightRestriction: 85, leftRestriction: -75)
            }
            
            if (gameScene.childNodeWithName("MissionComplete") as! SKSpriteNode).containsPoint(ron.position) {
                if !levelIsComplete {
                    levelIsComplete = true
                    checkLevelStatus(won: true, nextLevel:Lvl5(size:GameScene.sceneView!.size))
                }
            }
        }
    }
    
    func bigBang(explosion:HiddenItem) {
        let source = gameScene.childNodeWithName(explosion.name!)!
        explosion.position = source.position
        explosion.size = source.frame.size
        world.addChild(explosion)
        
        explosion.runAction(SKAction.repeatAction(SKAction.sequence([SKAction.animateWithTextures(loadFramesFromAtlasWithName("ExplosionType1"), timePerFrame: 0.01, resize: false, restore: true),SKAction.waitForDuration(0.3)
            ]), count: 5),completion:{
                explosion.removeFromParent()
        })
    }
    
}

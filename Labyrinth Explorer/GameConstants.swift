//
//  GameConstants.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 3/6/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

var slowMotionModeGestureRecognizer = UILongPressGestureRecognizer(target: GameScene.sceneView!, action:"turnOnSlowMotion:")
var lastUpdateTimeInterval: NSTimeInterval = 0
var gameConstantProperties:GameConstants!
var ron:RonCharacter!
let back_Button = SKSpriteNode(imageNamed: "Back_Button.png")
var livesHud = SKNode()
var world = SKNode()
var leanArea = SKShapeNode()
var moveJoystick = Joystick()
var moveJoystickDefaultSpeed:CGFloat = 8
var slowModeActivated = false
var gameScene = SKScene()
let screenSize: CGRect = UIScreen.mainScreen().bounds
var ronPreviousPosition = CGPointMake(0, 0)
var levelIsComplete = false

var topAngle = CGFloat(M_PI)
var bottomAngle = CGFloat(0)
var rightAngle = CGFloat(0.5*M_PI)
var leftAngle = -CGFloat(0.5*M_PI)

struct gameMapsHUD {
    static let lvl1hudNodeName = "Lvl1World"
    static let lvl2hudNodeName = "Lvl2World"
    static let lvl3hudNodeName = "Lvl3World"
    static let lvl4hudNodeName = "Lvl4World"
    static let lvl5hudNodeName = "Lvl5World"
    static let lvl9hudNodeName = "Lvl9World"
}

struct gameBackgroundTiles {
    static let stonyTiles = ["stonyTileType1.jpg","stonyTileType2.jpg","stonyTileType3.jpg","stonyTileType4.jpg"]
}

struct GameScene {
    static var sceneView:SKScene?
    static let minimumUpdateInterval = 1.0 / 60.0
}

func escapePathContainsEnemy(enemy:EnemyCharacter,location:[String],currentPathIndex:Int) {
    enemy.assignedLocations = location
    enemy.currentPathIndex = currentPathIndex
    enemy.inEscapeArea = true
    enemy.detectionArea?.actionsExist = true
}

func enemyIsOnEscapeArea(enemies enemies:[EnemyCharacter], escapePathsNames:[[Any]], locations:[[[String]]], withTimeInterval:NSTimeInterval, currentPathsIndexes:[Int]) {
    
    if !ron.isDetected {
        
        for var a=0;a<enemies.count;a++ {
            let enemy = enemies[a]
            if !enemy.detectionArea!.targetWasSeen && !enemy.isDying && enemy.distracted {
                for var b=0;b<escapePathsNames[a].count;b++ {
                    if enemy.assignedLocations.isEmpty && !enemy.inEscapeArea {
                        var escapePath:SKSpriteNode
                        if let stringArray = escapePathsNames[a][b] as? [String] {
                            for escapePathName in stringArray {
                                escapePath = gameScene.childNodeWithName(escapePathName) as! SKSpriteNode
                                if escapePath.containsPoint(enemy.position) {
                                    escapePathContainsEnemy(enemy, location: locations[a][b], currentPathIndex: currentPathsIndexes[a])
                                    break
                                }
                            }
                        }
                        else {
                            escapePath = gameScene.childNodeWithName(escapePathsNames[a][b] as! String) as! SKSpriteNode
                            if escapePath.containsPoint(enemy.position) {
                                if enemies.count > 1 {
                                    escapePathContainsEnemy(enemy, location: locations[a][b], currentPathIndex: currentPathsIndexes[a])
                                }
                                else {
                                    if currentPathsIndexes.count > 1 {
                                        escapePathContainsEnemy(enemy, location: locations[a][b], currentPathIndex: currentPathsIndexes[b])
                                    }
                                    else if currentPathsIndexes.count == 1 {
                                        escapePathContainsEnemy(enemy, location: locations[a][b], currentPathIndex: currentPathsIndexes[0])
                                    }
                                }
                            }
                        }
                    }
                }
                
                if !enemy.assignedLocations.isEmpty && enemy.inEscapeArea {
                    var locationToMove = gameScene.childNodeWithName(enemy.assignedLocations[0])!
                    if !enemy.isAttacking {
                        enemy.requestedAnimation = .Walk
                    }
                    
                    let deltaX = locationToMove.position.x - enemy.position.x
                    let deltaY = locationToMove.position.y - enemy.position.y
                    let targetPosition = CGPoint(x: enemy.position.x + deltaX, y: enemy.position.y + deltaY)
                    
                    let angle = adjustAssetOrientation(targetPosition.radiansToPoint(enemy.position))
                    
                    enemy.faceToPosition(targetPosition, withDuration: 0, isItCounterClockWiseRotation:false)
                    
                    let maximumDistance = enemy.movementSpeed * CGFloat(withTimeInterval)
                    
                    let distRemaining = hypot(deltaX, deltaY)
                    if distRemaining < maximumDistance {
                        enemy.position = targetPosition
                    } else {
                        let x = enemy.position.x - (maximumDistance * sin(angle))
                        let y = enemy.position.y + (maximumDistance * cos(angle))
                        enemy.position = CGPoint(x: x, y: y)
                    }
                    
                    if enemy.containsPoint(targetPosition) {
                        enemy.assignedLocations.removeAtIndex(0)
                    }
                }
                else if enemy.assignedLocations.isEmpty {
                    enemy.detectionArea?.actionsExist = false
                    enemy.inEscapeArea = false
                }
            }
        }
    }
}

func pathsAssignment(pathName pathName:String, initialIndex:Int, finalIndex:Int) -> [SKNode] {
    var paths:[SKNode] = []
    for var i=initialIndex;i<finalIndex;i++ {
        paths.append(gameScene.childNodeWithName("\(pathName)_\(i)")!)
    }
    return paths
}

func centerWorldOnPosition(position:CGPoint, topRestriction:CGFloat, bottomRestriction:CGFloat, rightRestriction:CGFloat, leftRestriction:CGFloat) {
    
    let expectedPositionOfWorld = CGPoint(x:-position.x + CGRectGetMidX(GameScene.sceneView!.frame),
        y: -position.y + CGRectGetMidY(GameScene.sceneView!.frame))
    
    let caseTopAndBottom = expectedPositionOfWorld.y >= -(gameScene.frame.height/2+topRestriction) && expectedPositionOfWorld.y+GameScene.sceneView!.frame.size.height <= gameScene.frame.height/2+bottomRestriction
    let caseRightAndLeft = expectedPositionOfWorld.x >= -(gameScene.frame.width/2+rightRestriction) && expectedPositionOfWorld.x+GameScene.sceneView!.frame.size.width <= gameScene.frame.width/2+leftRestriction
    
    if caseRightAndLeft {
        world.position.x = expectedPositionOfWorld.x
    }
    else {
        if expectedPositionOfWorld.x < -(gameScene.size.width-GameScene.sceneView!.frame.size.width) {
            world.position.x = -(gameScene.size.width-GameScene.sceneView!.frame.size.width)
        }
        else {
            world.position.x = 0
        }
    }
    if caseTopAndBottom {
        world.position.y = expectedPositionOfWorld.y
    }
    else {
        if expectedPositionOfWorld.y < -(gameScene.size.height-GameScene.sceneView!.frame.size.height) {
            world.position.y = -(gameScene.size.height-GameScene.sceneView!.frame.size.height)
        }
        else {
            world.position.y = 0
        }
    }
}

// MARK: Character Support

func canSee(point: CGPoint, from vantagePoint: CGPoint) -> Bool {
    let rayStart = vantagePoint
    let rayEnd = point
    
    var wallFound = false
    GameScene.sceneView!.physicsWorld.enumerateBodiesAlongRayStart(rayStart, end: rayEnd) { body, point, normal, stop in
        if body.categoryBitMask & PhysicsCategory.Wall == PhysicsCategory.Wall {
                wallFound = true
                stop.memory = true
        }
    }
    
    return !wallFound
}

func isOnLeaningArea(effectingLeanArea effectingLeanArea:SKShapeNode, inverseRotationAngle:CGFloat) {
    moveJoystick.speed = 3
    leanArea = effectingLeanArea
    ron.rotateCharacterToAngle(inverseRotationAngle, duration: 0)
    ronPreviousPosition = ron.position
    ron.isLeaning = true
    if inverseRotationAngle==topAngle {
        ron.direction = .Top
    }
    else if inverseRotationAngle==bottomAngle {
        ron.direction = .Bottom
    }
    else if inverseRotationAngle==rightAngle {
        ron.direction = .Right
    }
    else if inverseRotationAngle==leftAngle {
        ron.direction = .Left
    }
}

func isOnHidingArea() {
    if !ron.heroIsHidden {
        ron.runAction(SKAction.colorizeWithColor(UIColor.blackColor(), colorBlendFactor: 0.5, duration: 0.15))
        ron.heroIsHidden = true
    }
}

func removeEverything(node:SKNode) {
    if !node.children.isEmpty {
        for child in node.children {
            removeEverything(child )
        }
    }
    else {
        if node != GameScene.sceneView! {
            node.removeFromParent()
        }
    }
}

func checkLevelStatus(won won:Bool, nextLevel:MainScene) {
    let reveal = SKTransition.fadeWithDuration(0.5)
    if won {
        while !GameScene.sceneView!.children.isEmpty {
            removeEverything(GameScene.sceneView!)
        }
        slowModeActivated = false
        levelIsComplete = false
        GameScene.sceneView!.view!.presentScene(nextLevel, transition: reveal)
        GameScene.sceneView!.removeFromParent()
    }
    else {
        let sceneStatus = LevelStatus(size: GameScene.sceneView!.size, won: won, nextLevel:nextLevel)
        GameScene.sceneView!.view!.presentScene(sceneStatus, transition: reveal)
    }
}

func addBackButton() {
    back_Button.size = moveJoystick.outerControl.size
    back_Button.position = moveJoystick.position
    back_Button.zPosition = 200
    GameScene.sceneView!.addChild(back_Button)
}

func loadBackgroundTiles(startingPosition:CGPoint, areaSize:CGSize, tiles:[String], sizeOfTile:CGSize, blendMode:SKBlendMode) {
    
    var tilesCountOnYAxis = Int(((areaSize.height+startingPosition.y)-startingPosition.y)/sizeOfTile.height)
    var tilesCountOnXAxis = Int(((areaSize.width+startingPosition.x)-startingPosition.x)/sizeOfTile.width)
    
    while startingPosition.y + CGFloat(tilesCountOnYAxis) * sizeOfTile.height < (areaSize.height+startingPosition.y) {
        tilesCountOnYAxis++
    }
    while startingPosition.x + CGFloat(tilesCountOnXAxis) * sizeOfTile.width < (areaSize.width+startingPosition.x) {
        tilesCountOnXAxis++
    }
    
    var angles = [rightAngle, topAngle, bottomAngle, leftAngle]
    for var i=0;i<tilesCountOnYAxis;i++ {
        for var j=0;j<tilesCountOnXAxis;j++ {
            let tileNode = SKSpriteNode(texture: SKTexture(imageNamed:tiles[Int(arc4random_uniform(UInt32(tiles.count-1)))]), size:CGSizeMake(sizeOfTile.width, sizeOfTile.height))
            tileNode.runAction(SKAction.rotateToAngle(angles[Int(arc4random_uniform(UInt32(angles.count-1)))], duration: 0))
            tileNode.blendMode = blendMode
            tileNode.zPosition = -1
            tileNode.position = CGPointMake(startingPosition.x+sizeOfTile.width*CGFloat(j), startingPosition.y+sizeOfTile.height*CGFloat(i))
            world.addChild(tileNode)
        }
    }
}

func populateWallsFromWorld() {
    gameScene.enumerateChildNodesWithName("wall*") { node, stop in
        let a = node.copy() as! SKNode
        a.zPosition = 50
        a.physicsBody = SKPhysicsBody(rectangleOfSize: a.frame.size)
        a.physicsBody?.dynamic = false
        a.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        a.physicsBody?.contactTestBitMask = PhysicsCategory.All
        world.addChild(a)
    }
}

func addEnemyCharacter(characterName characterName:String, spawnPoint:String, characterType:EnemyCharacter, paths:[SKNode], motionType:MotionType, angle:CGFloat) -> EnemyCharacter! {
    let characterSpawnPoint = gameScene.childNodeWithName(spawnPoint) as SKNode!
    var character:EnemyCharacter!
    if characterType is EnemyWithSword {
        character = EnemyWithSword(atPosition: characterSpawnPoint.position, name:characterName, paths:paths, motionType: motionType)
    }
    else if characterType is EnemyWithGun {
        character = EnemyWithGun(atPosition: characterSpawnPoint.position, name:characterName, paths:paths, motionType: motionType)
    }
    if UI_USER_INTERFACE_IDIOM() == .Pad {
        character.enemyRunSpeed = 18
    }
    character.configurePhysicsBody()
    character.rotateCharacterToAngle(angle, duration: 0)
    return character
}

func populateDoorsFromWorld() {
    gameScene.enumerateChildNodesWithName("*Door") { node, stop in
        let a = node.copy() as! SKNode
        a.zPosition = 50
        a.physicsBody = SKPhysicsBody(rectangleOfSize: a.frame.size)
        a.physicsBody?.dynamic = false
        a.physicsBody?.categoryBitMask = PhysicsCategory.Door
        a.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        world.addChild(a)
    }
}

func populateStashesFromWorld() {
    gameScene.enumerateChildNodesWithName("*Stuff*") { node, stop in
        let a = node.copy() as! SKNode
        a.physicsBody = SKPhysicsBody(rectangleOfSize: a.frame.size)
        a.physicsBody?.dynamic = false
        a.physicsBody?.categoryBitMask = PhysicsCategory.Undestroyable
        world.addChild(a)
    }
}

func populateHideoutsFromWorld() {
    gameScene.enumerateChildNodesWithName("hideout") { node, stop in
        let a = node.copy() as! SKNode
        world.addChild(a)
    }
    populateHidingAreaFromWorld()
}

func populateHidingAreaFromWorld() {
    gameScene.enumerateChildNodesWithName("hidingArea*") { node, stop in
        let a = node.copy() as! SKNode
        //world.addChild(a)
    }
}

func populateMaterialUsableAreasFromWorld() {
    gameScene.enumerateChildNodesWithName("*UsableArea*") { node, stop in
        let a = node.copy() as! SKNode
        world.addChild(a)
    }
}

func populateTrapsFromWorld() {
    gameScene.enumerateChildNodesWithName("*Trap*") { node, stop in
        let a = node.copy() as! SKNode
        world.addChild(a)
    }
}

func populateGatesFromWorld() {
    gameScene.enumerateChildNodesWithName("*Gates*") { node, stop in
        let a = node.copy() as! SKNode
        world.addChild(a)
    }
}

func setPhysicsBodyForGates(node node:SKNode, size:CGSize, centerForPhysicsBody:CGPoint) {
    node.physicsBody = SKPhysicsBody(rectangleOfSize: size, center: centerForPhysicsBody)
    node.physicsBody!.dynamic = false
    node.physicsBody!.categoryBitMask = PhysicsCategory.BlockingTrap
    node.physicsBody!.contactTestBitMask = PhysicsCategory.LivingCreatures
}

func populateWallLeaningAreasFromWorld() {
    gameScene.enumerateChildNodesWithName("wallLeaningArea*") { node, stop in
        let a = node.copy() as! SKNode
        world.addChild(a)
    }
}

func addTrapFireEmitter(node node:SKNode, nodeName:String) {
    var a = SKEmitterNode(fileNamed: "trapFire")
    a.name = nodeName
    a.zPosition = 6
    a.position = node.position
    a.particleBirthRate = 0
    a.physicsBody = SKPhysicsBody(circleOfRadius: node.frame.size.width)
    a.physicsBody?.dynamic = false
    a.physicsBody?.categoryBitMask = PhysicsCategory.TrapEmitter
    a.physicsBody!.contactTestBitMask = PhysicsCategory.LivingCreatures
    a.physicsBody!.collisionBitMask = PhysicsCategory.LivingCreatures
    world.addChild(a)
}

func setupSpearTrap(node node:SKNode, animationFrames:[SKTexture], beginningPosition:Int, endingPosition:Int, waitingDuration:NSTimeInterval) -> SKNode {
    
    node.zPosition = 6
    node.physicsBody = SKPhysicsBody(rectangleOfSize: (node as! SKSpriteNode).size)
    node.physicsBody!.dynamic = false
    node.physicsBody!.categoryBitMask = PhysicsCategory.BlockingTrap
    node.physicsBody!.contactTestBitMask = PhysicsCategory.LivingCreatures
    node.physicsBody!.collisionBitMask = PhysicsCategory.LivingCreatures
    
    let spearIsKillingTextures:[SKTexture] = editAnimationTextures(oldTexture: animationFrames, begin: beginningPosition, end: endingPosition, reversed: false)
    let spearIsSafeTextures:[SKTexture] = editAnimationTextures(oldTexture: animationFrames, begin: beginningPosition, end: endingPosition, reversed: true)
    
    node.runAction(SKAction.repeatActionForever(SKAction.sequence([
        SKAction.runBlock({
            node.physicsBody = SKPhysicsBody(rectangleOfSize: (node as! SKSpriteNode).size)
            node.physicsBody!.dynamic = false
            node.physicsBody!.categoryBitMask = PhysicsCategory.Trap
            node.physicsBody!.contactTestBitMask = PhysicsCategory.LivingCreatures
            node.physicsBody!.collisionBitMask = PhysicsCategory.LivingCreatures
        }),
        SKAction.animateWithTextures(spearIsKillingTextures, timePerFrame: 1/28),
        SKAction.runBlock({
            node.physicsBody!.categoryBitMask = PhysicsCategory.BlockingTrap
        }),
        SKAction.waitForDuration(2.0),
        SKAction.animateWithTextures(spearIsSafeTextures, timePerFrame: 1/28),
        SKAction.runBlock({
            node.physicsBody!.categoryBitMask = PhysicsCategory.None
        }),
        SKAction.waitForDuration(waitingDuration)
        ])
        ))
    return node
    
}

func editAnimationTextures(oldTexture oldTexture:[SKTexture], begin:Int, end:Int, reversed:Bool) -> [SKTexture] {
    var newTexture:[SKTexture] = []
    if !reversed {
        for var i=begin; i<=end;i++ {
            newTexture.append(oldTexture[i])
        }
    }
    else {
        for var i=end; i>=begin;i-- {
            newTexture.append(oldTexture[i])
        }
    }
    return newTexture
}

class GameConstants:SKNode  {
    
    enum UIEventType: Int {
        case TouchBegan = 0
        case TouchMoved
        case TouchEnded
    }
    
    struct Constants {
        static let hudLivesNodeName = "LivesHUD"
        static let hudItemsNodeName = "ItemsHUD"
        static let hudLifeName = "hudLife"
        static let hudItemName = "hudItem"
    }
    
    var itemsHud = SKNode()
    typealias tupleOfItem = (key:String,imageName:String)
    var itemsArray = [tupleOfItem](count: 20, repeatedValue: (key:"",imageName:""))
    
    init(heroLivesCount:Int, rotateCharacterToAngle:CGFloat) {
        
        // Main Hero
        
        ron = RonCharacter(atPosition:gameScene.childNodeWithName("defaultSpawnPoint")!.position)
        ron.name = "Ron"
        world.addChild(ron)
        ron.rotateCharacterToAngle(rotateCharacterToAngle, duration: 0)
        ron.configurePhysicsBody()
        ron.livesCount = heroLivesCount
        RonCharacter.loadSharedAssets()
        EnemyWithSword.loadSharedAssets()
        EnemyWithGun.loadSharedAssets()
        
        // Joystick
        
        moveJoystick.setOuterControl(imageName: "outer", withAlpha: 0.25)
        moveJoystick.setInnerControl(imageName: "inner", withAlpha: 0.5, withName: "MoveJoystick")
        
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            moveJoystickDefaultSpeed = 6
        }
        
        moveJoystick.speed = moveJoystickDefaultSpeed
        moveJoystick.alpha = 1
        moveJoystick.zPosition = 99
        moveJoystick.position = CGPointMake(GameScene.sceneView!.frame.origin.x+150, GameScene.sceneView!.frame.origin.y+130)
        moveJoystick.outerControl.size = CGSizeMake(150, 150)
        moveJoystick.innerControl.size = CGSizeMake(70, 70)
        GameScene.sceneView!.addChild(moveJoystick)
        
        super.init()

        loadHUDForPlayer()
    }
    
    var selectionIndicator = SKSpriteNode(color: UIColor.clearColor(), size: CGSizeMake(40, 40))
    
    var selectionIndicatorPartTopRightVertical = SKSpriteNode(color:UIColor.whiteColor(), size: CGSizeMake(3, 10))
    var selectionIndicatorPartTopRightHorizontal = SKSpriteNode(color:UIColor.whiteColor(), size: CGSizeMake(15, 3))
    var selectionIndicatorPartBottomRightVertical = SKSpriteNode(color:UIColor.whiteColor(), size: CGSizeMake(3, 10))
    var selectionIndicatorPartBottomRightHorizontal = SKSpriteNode(color:UIColor.whiteColor(), size: CGSizeMake(15, 3))
    var selectionIndicatorPartTopLeftVertical = SKSpriteNode(color:UIColor.whiteColor(), size: CGSizeMake(3, 10))
    var selectionIndicatorPartTopLeftHorizontal = SKSpriteNode(color:UIColor.whiteColor(), size: CGSizeMake(15, 3))
    var selectionIndicatorPartBottomLeftVertical = SKSpriteNode(color:UIColor.whiteColor(), size: CGSizeMake(3, 10))
    var selectionIndicatorPartBottomLeftHorizontal = SKSpriteNode(color:UIColor.whiteColor(), size: CGSizeMake(15, 3))

    
    func initializeSelectionIndicator() {
        
        itemsHud.addChild(selectionIndicator)
        selectionIndicator.hidden = true
        selectionIndicator.zPosition = 101
        
        selectionIndicator.addChild(selectionIndicatorPartTopRightVertical)
        selectionIndicator.addChild(selectionIndicatorPartTopRightHorizontal)
        selectionIndicator.addChild(selectionIndicatorPartBottomRightVertical)
        selectionIndicator.addChild(selectionIndicatorPartBottomRightHorizontal)
        selectionIndicator.addChild(selectionIndicatorPartTopLeftVertical)
        selectionIndicator.addChild(selectionIndicatorPartTopLeftHorizontal)
        selectionIndicator.addChild(selectionIndicatorPartBottomLeftVertical)
        selectionIndicator.addChild(selectionIndicatorPartBottomLeftHorizontal)
        
        selectionIndicatorPartTopRightVertical.position = CGPointMake(18,12)
        selectionIndicatorPartTopRightHorizontal.position = CGPointMake(12,18)
        selectionIndicatorPartBottomRightVertical.position = CGPointMake(18,-12)
        selectionIndicatorPartBottomRightHorizontal.position = CGPointMake(12,-18)
        selectionIndicatorPartTopLeftVertical.position = CGPointMake(-18,12)
        selectionIndicatorPartTopLeftHorizontal.position = CGPointMake(-12,18)
        selectionIndicatorPartBottomLeftVertical.position = CGPointMake(-18,-12)
        selectionIndicatorPartBottomLeftHorizontal.position = CGPointMake(-12,-18)
        
        selectionIndicatorPartTopRightVertical.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.5),SKAction.fadeAlphaTo(1, duration: 0.5)])))
        selectionIndicatorPartTopRightHorizontal.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.5),SKAction.fadeAlphaTo(1, duration: 0.5)])))
        selectionIndicatorPartBottomRightVertical.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.5),SKAction.fadeAlphaTo(1, duration: 0.5)])))
        selectionIndicatorPartBottomRightHorizontal.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.5),SKAction.fadeAlphaTo(1, duration: 0.5)])))
        selectionIndicatorPartTopLeftVertical.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.5),SKAction.fadeAlphaTo(1, duration: 0.5)])))
        selectionIndicatorPartTopLeftHorizontal.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.5),SKAction.fadeAlphaTo(1, duration: 0.5)])))
        selectionIndicatorPartBottomLeftVertical.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.5),SKAction.fadeAlphaTo(1, duration: 0.5)])))
        selectionIndicatorPartBottomLeftHorizontal.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.5),SKAction.fadeAlphaTo(1, duration: 0.5)])))
        
    }
    
    var lastSelectedItem:SKNode!
    var lastItem:SKNode!
    var lastTargets:[SKNode] = []
    
    func enableSelectionForItem(selectedItem:SKNode, targets:[SKNode]) {
        
        if lastItem != nil && lastItem != selectedItem {
            removeIndicatorsForTargets(lastItem, enableUseForItem: false, targets: lastTargets)
        }
        
        let item = itemsHud.childNodeWithName(selectedItem.name!)!
        
        if selectionIndicator.hidden || lastSelectedItem != item {
            selectionIndicator.position = item.position
            selectionIndicator.hidden = false
            removeIndicatorsForTargets(selectedItem, enableUseForItem: true, targets: lastTargets)
            lastTargets = targets
            for target in targets {
                target.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 1, duration: 0.5),
                    SKAction.colorizeWithColorBlendFactor(0, duration:0.5)])), withKey:"targetDetected")
            }
        }
        else {
            selectionIndicator.hidden = true
            removeIndicatorsForTargets(selectedItem, enableUseForItem: false, targets: targets)
        }
        
        lastSelectedItem = item
        lastItem = selectedItem
        
    }
    
    func removeIndicatorsForTargets(selectedItem:SKNode, enableUseForItem:Bool, targets:[SKNode]){
        
        if selectedItem is HiddenItem {
            (selectedItem as! HiddenItem).isAboutToBeUsedOnTarget = enableUseForItem ? true : false
        }
        else if selectedItem is Item {
            (selectedItem as! Item).isAboutToBeUsedOnTarget = enableUseForItem ? true : false
        }
        
        for target in targets {
            target.removeActionForKey("targetDetected")
            target.runAction(SKAction.colorizeWithColorBlendFactor(0, duration:0))
        }
        
    }
    
    // MARK: HUD
    
    func loadHUDForPlayer() {
        
        // MARK: LivesHUD Setup
        
        // Get Parent Node in LivesHUD.sks
        
        let livesHudScene: SKScene = SKScene(fileNamed: Constants.hudLivesNodeName)
        livesHud = livesHudScene.children.first!.copy() as! SKNode
        livesHud.name = Constants.hudLivesNodeName
        livesHud.position = CGPoint(x:GameScene.sceneView!.frame.origin.x+10, y: GameScene.sceneView!.frame.origin.y+GameScene.sceneView!.frame.size.height-10)
        livesHud.zPosition = 102
        GameScene.sceneView!.addChild(livesHud)
        
        for lifeOrderNumber in 0..<ron.livesCount {
            
            switch lifeOrderNumber {
            case 0:
                createLifeSKSpriteNode(livesHud, positionX: 20, positionY: -22)
            case 1:
                createLifeSKSpriteNode(livesHud, positionX: 51, positionY: -22)
            case 2:
                createLifeSKSpriteNode(livesHud, positionX: 82, positionY: -22)
            case 3:
                createLifeSKSpriteNode(livesHud, positionX: 113, positionY: -22)
            case 4:
                createLifeSKSpriteNode(livesHud, positionX: 144, positionY: -22)
            case 5:
                createLifeSKSpriteNode(livesHud, positionX: 20, positionY: -62)
            case 6:
                createLifeSKSpriteNode(livesHud, positionX: 51, positionY: -62)
            case 7:
                createLifeSKSpriteNode(livesHud, positionX: 82, positionY: -62)
            case 8:
                createLifeSKSpriteNode(livesHud, positionX: 113, positionY: -62)
            case 9:
                createLifeSKSpriteNode(livesHud, positionX: 144, positionY: -62)
            default: break
            }
            
        }
        
        // MARK: ItemsHUD Setup
        
        // Get Parent Node in ItemsHUD.sks
        
        let hudScene: SKScene = SKScene(fileNamed: Constants.hudItemsNodeName)
        itemsHud = hudScene.children.first!.copy() as! SKNode
        itemsHud.name = Constants.hudItemsNodeName
        itemsHud.position = CGPoint(x:GameScene.sceneView!.frame.origin.x+GameScene.sceneView!.frame.size.width-435, y: GameScene.sceneView!.frame.origin.y+20)
        itemsHud.zPosition = 102
        GameScene.sceneView!.addChild(itemsHud)
        
    }
    
    func createLifeSKSpriteNode(parentNodeInHUD:SKNode, positionX:CGFloat, positionY:CGFloat) {
        let lifeOfRon = SKSpriteNode(imageNamed: "Life.png")
        lifeOfRon.name = Constants.hudLifeName
        lifeOfRon.zPosition = 100
        lifeOfRon.size = CGSizeMake(40, 40)
        lifeOfRon.position = CGPointMake(positionX, positionY)
        parentNodeInHUD.addChild(lifeOfRon)
    }
    
    func createItemSKSpriteNode(parentNodeInHUD parentNodeInHUD:SKNode, itemKey:String,itemImageName:String, collectedItem:SKNode) {
        
        var itemDoesntExistYet = false
        var itemIndex = 0
        var positionOfItem = CGPointMake(0, 0)
        
        // 1 row of items
        
        if itemsArray[0].key.isEmpty && !itemDoesntExistYet {
            itemDoesntExistYet = true
            itemIndex = 0
            positionOfItem = CGPointMake(410, 5)
        }
        
        if itemsArray[1].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 1
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(365, 5)
        }
        
        if itemsArray[2].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 2
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(320, 5)
        }
        
        if itemsArray[3].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 3
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(275, 5)
        }
        
        if itemsArray[4].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 4
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(230, 5)
        }
        
        if itemsArray[5].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 5
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(185, 5)
        }
        
        if itemsArray[6].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 6
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(140, 5)
        }
        
        if itemsArray[7].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 7
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(95, 5)
        }
        
        if itemsArray[8].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 8
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(50, 5)
        }
        
        if itemsArray[9].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 9
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(5, 5)
        }
        
        // 2 row of items
        
        if itemsArray[10].key.isEmpty && !itemDoesntExistYet {
            itemDoesntExistYet = true
            itemIndex = 10
            positionOfItem = CGPointMake(410, 50)
        }
        
        if itemsArray[11].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 11
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(365, 50)
        }
        
        if itemsArray[12].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 12
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(320, 50)
        }
        
        if itemsArray[13].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 13
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(275, 50)
        }
        
        if itemsArray[14].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 14
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(230, 50)
        }
        
        if itemsArray[15].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 15
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(185, 50)
        }
        
        if itemsArray[16].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 16
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(140, 50)
        }
        
        if itemsArray[17].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 17
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(95, 50)
        }
        
        if itemsArray[18].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 18
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(50, 50)
        }
        
        if itemsArray[19].key.isEmpty && !itemDoesntExistYet {
            itemIndex = 19
            itemDoesntExistYet = true
            positionOfItem = CGPointMake(5, 50)
        }
        
        if itemDoesntExistYet {
            collectedItem.removeFromParent()
            let item = SKSpriteNode(imageNamed: itemImageName)
            item.name = itemKey
            item.zPosition = parentNodeInHUD.zPosition
            item.size = CGSizeMake(40, 40)
            item.position = positionOfItem
            itemsArray[itemIndex].key = itemKey
            itemsArray[itemIndex].imageName = itemImageName
            parentNodeInHUD.addChild(item)
        }
        
    }
    
    func removeItemFromItemsHUD(keyForItem keyForItem:String) {
        for itemIndex in 0..<itemsArray.count {
            if itemsArray[itemIndex].key == keyForItem {
                itemsArray[itemIndex].key = ""
                itemsArray[itemIndex].imageName = ""
                var positionsOfHUDitems:[CGPoint] = []
                for var i=0;i<itemsHud.children.count;i++ {
                    positionsOfHUDitems.append((itemsHud.children[i] ).position)
                }
                for var i=itemIndex+1;i<itemsHud.children.count;i++ {
                    if i<itemsHud.children.count-1 {
                        itemsArray.withUnsafeMutableBufferPointer({ (inout ptr: UnsafeMutableBufferPointer<tupleOfItem>) -> Void in
                            swap(&ptr[i-1], &ptr[i])
                        })
                        (itemsHud.children[i+1] ).position = positionsOfHUDitems[i]
                    }
                }
                positionsOfHUDitems.removeAll(keepCapacity: false)
                itemsHud.childNodeWithName(keyForItem)!.removeFromParent()
                break;
            }
        }
    }
    
    var innerControlMidX:CGFloat = 0
    var innerControlMidY:CGFloat = 0

    func eventIsOnProcess(touch: UITouch, event:Int) {
        if !ron.lockTouchActions {
            if event == UIEventType.TouchBegan.rawValue {
                let location:CGPoint = touch.locationInNode(GameScene.sceneView!)
                
                let touchedNode:SKNode = GameScene.sceneView!.nodeAtPoint(location)
                if touchedNode.name == "MoveJoystick" {
                    moveJoystick.startControlFromTouch(touch:touch as UITouch, andLocation:location)
                }
            }
            else if event == UIEventType.TouchMoved.rawValue {
                if touch == moveJoystick.startTouch {
                    moveJoystick.moveControlToLocation(touch: touch as UITouch, andLocation: touch.locationInNode(GameScene.sceneView!))
                }
            }
            else if event == UIEventType.TouchEnded.rawValue {
                if touch == moveJoystick.startTouch {
                    moveJoystick.endControl()
                }
            }
        }
    }
    
    func updateMove() {
        
        if !ron.isDying {
            innerControlMidX = CGRectGetMidX(moveJoystick.innerControl.frame)
            
            innerControlMidY = CGRectGetMidY(moveJoystick.innerControl.frame)
            
            if (moveJoystick.isMoving &&
                (innerControlMidX>25||innerControlMidX<(-25)||innerControlMidY>25||innerControlMidY<(-25))
                ){
                    
                    if !ron.isLeaning {
                        
                        if !slowModeActivated {
                            ron.requestedAnimation = .Walk
                        }
                        else {
                            ron.requestedAnimation = .SneakUp
                        }
                        
                        ron.rotateCharacterToAngle(adjustAssetOrientation(innerControlPositionRadiansToPoint(CGPointMake(innerControlMidX, innerControlMidY))), duration: 0)
                        
                    }
                    else {
                        
                        ron.requestedAnimation = .LeanSliding
                        
                    }
                    
                    var adjustedSpritePosition:CGPoint = CGPointMake(ron.position.x + moveJoystick.moveSize.width, ron.position.y + moveJoystick.moveSize.height)
                    
                    if adjustedSpritePosition.x > gameScene.size.width  {
                        adjustedSpritePosition.x = gameScene.size.width
                    }
                    else if adjustedSpritePosition.x < gameScene.position.x  {
                        adjustedSpritePosition.x = gameScene.position.x
                    }
                    if adjustedSpritePosition.y > gameScene.size.height {
                        adjustedSpritePosition.y = gameScene.size.height
                    }
                    else if adjustedSpritePosition.y < gameScene.position.y  {
                        adjustedSpritePosition.y = gameScene.position.y
                    }
                    
                    
                    if !ron.isLeaning {
                        ron.position = adjustedSpritePosition
                    }
                    else {
                        
                        if ((ron.direction == .Top || ron.direction == .Bottom) && (ron.position.x < leanArea.position.x-(leanArea.frame.size.width/2) || ron.position.x > leanArea.position.x+(leanArea.frame.size.width/2))) || ((ron.direction == .Right || ron.direction == .Left) && (ron.position.y < leanArea.position.y-(leanArea.frame.size.height/2) || ron.position.y > leanArea.position.y+(leanArea.frame.size.height/2))) {
                            moveJoystick.freeFromLean = true
                            ron.isLeaning = false
                        }
                        
                        if !moveJoystick.freeFromLean {
                            
                            if (ron.direction == .Top || ron.direction == .Bottom) && ronPreviousPosition.y != adjustedSpritePosition.y {
                                adjustedSpritePosition.y = ronPreviousPosition.y
                            }
                            else if (ron.direction == .Left || ron.direction == .Right) && ronPreviousPosition.x != adjustedSpritePosition.x {
                                adjustedSpritePosition.x = ronPreviousPosition.x
                            }
                            
                            ronPreviousPosition = adjustedSpritePosition
                            ron.position = adjustedSpritePosition
                            
                        }
                        else {
                            if ron.isLeaning {
                                
                                if ron.direction == .Top && moveJoystick.angle < 105 && moveJoystick.angle > 75 {
                                    ron.isLeaning = false
                                    ron.position.y += leanArea.frame.size.height
                                }
                                else if ron.direction == .Bottom && moveJoystick.angle > -105 && moveJoystick.angle < -75 {
                                    ron.isLeaning = false
                                    ron.position.y -= leanArea.frame.size.height
                                }
                                else if ron.direction == .Right && moveJoystick.angle > -15 && moveJoystick.angle < 15 {
                                    ron.isLeaning = false
                                    ron.position.x += leanArea.frame.size.width
                                }
                                else if ron.direction == .Left && (moveJoystick.angle < -165 && moveJoystick.angle > -180) || (moveJoystick.angle > 165 && moveJoystick.angle < 180) {
                                    ron.isLeaning = false
                                    ron.position.x -= leanArea.frame.size.width
                                }
                                
                            }
                        }
                        
                    }
                    
            }
        }
        
    }
    
    func generateRandomFigures(count:Int, itIsNumbers:Bool, figures:[SKSpriteNode]) -> [AnyObject] {
        var numbers:[AnyObject] = []
        if itIsNumbers {
            for var i=0;i<count;i++ {
                let number = arc4random_uniform(9)
                numbers.append(String(number))
            }
        }
        else {
        
        }
        return numbers
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

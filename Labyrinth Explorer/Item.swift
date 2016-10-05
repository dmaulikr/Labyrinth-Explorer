//
//  Item.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 4/1/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class Item: SKSpriteNode {
    
    var isAboutToBeUsedOnTarget = false
    
    init(nodeName:String, nodeImageName:String, position:CGPoint, size:CGSize) {
    let texture = SKTexture(imageNamed: nodeImageName)
    super.init(texture: texture, color: UIColor.clearColor(), size: size)
        self.name = nodeName
        self.position = position
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody!.dynamic = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.UsableItem
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
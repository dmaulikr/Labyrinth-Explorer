//
//  BlockingArea.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 4/16/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class BlockingArea: SKNode {
    
    init(nodeName:String, position:CGPoint, size:CGSize) {
        super.init()
        let a = gameScene.childNodeWithName(nodeName)!.copy() as! SKNode
        a.physicsBody = SKPhysicsBody(rectangleOfSize: a.frame.size)
        a.physicsBody?.dynamic = false
        a.physicsBody?.categoryBitMask = PhysicsCategory.Undestroyable
        world.addChild(a)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
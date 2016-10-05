//
//  InsideStash.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 3/31/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class InteractingWithStuff: SKSpriteNode {
    
    init(nodeName:String, nodeImageName:String) {
        let texture = SKTexture(imageNamed: nodeImageName)
        super.init(texture: texture, color: UIColor.blackColor(), size: texture.size())
        if nodeImageName.isEmpty {
            self.texture = nil
        }
        self.name = nodeName
        self.zPosition = 99
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
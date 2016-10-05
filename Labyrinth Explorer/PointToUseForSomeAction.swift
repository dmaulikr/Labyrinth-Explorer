//
//  SelectionPoint.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 4/22/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class PointToUseForSomeAction: SKSpriteNode {
    
    init(nodeName:String, position:CGPoint, size:CGSize, zPosition:CGFloat, pointBlinkingInterval:NSTimeInterval, blinkingPointAtlasTextures:[SKTexture]) {
        
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
        self.name = nodeName
        self.position = position
        self.zPosition = zPosition
        
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(blinkingPointAtlasTextures, timePerFrame: pointBlinkingInterval, resize: false, restore: false)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

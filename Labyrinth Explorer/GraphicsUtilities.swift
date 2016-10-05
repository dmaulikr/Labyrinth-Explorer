//
//  GraphicsUtilities.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 3/18/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

func loadFramesFromAtlasWithName(atlasName: String) -> [SKTexture] {
    let atlas = SKTextureAtlas(named: atlasName)
    return (atlas.textureNames ).sort().map { atlas.textureNamed($0) }
}

func adjustAssetOrientation(r: CGFloat) -> CGFloat {
    return r + (CGFloat(M_PI) * 0.5)
}

func innerControlPositionRadiansToPoint(point: CGPoint) -> CGFloat {
    return atan2(point.y, point.x)
}

extension CGPoint {
    func distanceToPoint(point: CGPoint) -> CGFloat {
        return hypot(x - point.x, y - point.y)
    }
    func radiansToPoint(point: CGPoint) -> CGFloat {
        let deltaX = point.x - x
        let deltaY = point.y - y
        
        return atan2(deltaY, deltaX)
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
}
//
//  HiddenItems.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 3/31/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class HiddenItem: SKSpriteNode {
    
    init(nodeName:String, nodeImageName:String, zPosition:CGFloat) {
        let texture = SKTexture(imageNamed: nodeImageName)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.name = nodeName
        self.position = position
        self.zPosition = zPosition
    }
    
    var isAboutToBeUsedOnTarget = false
    
    var animated = false
    
    func animateAltasWithTexturesOfTheHiddenItem(frameFromAtlas frameFromAtlas:[SKTexture], beginningPosition:Int, endingPosition:Int, durationAnimationPerTexture:NSTimeInterval, cycledAnimation:Bool, momentOfExpectationForTheNextAnimationCycle:NSTimeInterval, completion block: () -> Void) {
        
        animated = true
        
        if !cycledAnimation {
            
            let animationTextures = editAnimationTextures(originalFramesFromAtlas: frameFromAtlas, begin: beginningPosition, end: endingPosition, reversed: false)
            
            runAction(SKAction.animateWithTextures(animationTextures, timePerFrame: durationAnimationPerTexture), completion:{
                block()
                self.animated = false
            })
            
        }
        else {
            
            let animationTextures = editAnimationTextures(originalFramesFromAtlas: frameFromAtlas, begin: beginningPosition, end: endingPosition, reversed: false)
            let reversedAnimationTextures = editAnimationTextures(originalFramesFromAtlas: frameFromAtlas, begin: beginningPosition, end: endingPosition, reversed: true)
            
            runAction(SKAction.repeatActionForever(SKAction.sequence([
                SKAction.runBlock({
                    self.animated = true
                }),
                SKAction.animateWithTextures(animationTextures, timePerFrame: durationAnimationPerTexture),
                SKAction.runBlock({
                    self.animated = false
                }),
                SKAction.waitForDuration(momentOfExpectationForTheNextAnimationCycle),
                SKAction.runBlock({
                    self.animated = true
                }),
                SKAction.animateWithTextures(animationTextures, timePerFrame: durationAnimationPerTexture),
                SKAction.runBlock({
                    self.animated = false
                }),
                SKAction.waitForDuration(momentOfExpectationForTheNextAnimationCycle)
                
                ])))
            
        }
    }
    
    func editAnimationTextures(originalFramesFromAtlas originalFramesFromAtlas:[SKTexture], begin:Int, end:Int, reversed:Bool) -> [SKTexture] {
        var newTexture:[SKTexture] = []
        if !reversed {
            for var i=begin; i<=end;i++ {
                newTexture.append(originalFramesFromAtlas[i])
            }
        }
        else {
            for var i=end; i>=begin;i-- {
                newTexture.append(originalFramesFromAtlas[i])
            }
        }
        return newTexture
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

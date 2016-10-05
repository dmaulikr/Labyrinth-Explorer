//
//  Joystick.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 3/5/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class Joystick: SKNode {

    var outerControl = SKSpriteNode()
    var innerControl = SKSpriteNode()
    var startPoint:CGPoint
    
    var isMoving: Bool
    var autoShowHide: Bool = true
    var moveSize:CGSize
    var startTouch:UITouch
    var angle:CGFloat = 0
    var defaultAngle:CGFloat = 0
    var freeFromLean = true
    
    override init() {
        self.startPoint = CGPointMake(0, 0)
        self.isMoving = false
        self.moveSize = CGSizeMake(0, 0)
        self.startTouch = UITouch()
        super.init()
    }
    
    func setInnerControl(imageName imageName: String, withAlpha alpha:CGFloat, withName nodeName: String) {
        setInnerControl(imageName: imageName, withAlpha: alpha)
        innerControl.name = nodeName
    }
    
    func setInnerControl(imageName imageName: String, withAlpha alpha:CGFloat) {
        if innerControl.name != nil {
            innerControl.removeFromParent()
        }
        
        innerControl = SKSpriteNode(imageNamed: imageName)
        innerControl.alpha = alpha
        addChild(innerControl)
    }
    
    func setOuterControl(imageName imageName: String, withAlpha alpha:CGFloat) {
        if outerControl.name != nil {
            outerControl.removeFromParent()
        }
        
        outerControl = SKSpriteNode(imageNamed: imageName)
        outerControl.alpha = alpha
        addChild(outerControl)
    }
    
    func startControlFromTouch(touch touch: UITouch, andLocation location: CGPoint) {
        if self.autoShowHide {
            outerControl.alpha = 0.5
            innerControl.alpha = 0.75
        }
        self.startTouch = touch
        startPoint = location
        self.isMoving = true
    }
    
    func moveControlToLocation(touch touch: UITouch, andLocation location: CGPoint) {
        
        let outerRadius:CGFloat = outerControl.size.width/2
        
        var movePoints:CGFloat = speed
        
        let deltaX:CGFloat = location.x - startPoint.x
        
        let deltaY:CGFloat = location.y - startPoint.y
        
        let distance:CGFloat = sqrt((deltaX * deltaX) + (deltaY * deltaY))
        
        self.angle = atan2(CGFloat(deltaY), CGFloat(deltaX)) * 180 / CGFloat(M_PI)
        
        let isLeft:Bool = abs(self.angle) > 90
        
        let radians:CGFloat = self.angle * CGFloat(M_PI) / 180
        
        if ( distance < outerRadius ){
            
            innerControl.position = touch.locationInNode(self)
            
            movePoints = distance / outerRadius * speed
            
            freeFromLean = false
            
        } else {
            
            freeFromLean = true
            
            let maxY:CGFloat = outerRadius * sin(radians)
            var maxX:CGFloat = sqrt(( outerRadius * outerRadius ) - ( maxY * maxY ) )
            if ( isLeft ){
                maxX *= -1
            }
            innerControl.position = CGPointMake(maxX, maxY)
            movePoints = speed
        }

        let moveY:CGFloat = movePoints * sin(radians)
        
        var moveX:CGFloat = sqrt(( movePoints * movePoints ) - ( moveY * moveY ) )
        
        if ( isLeft ){
            moveX *= -1
        }
        
        self.moveSize = CGSizeMake(moveX, moveY)
        
    }
    
    func endControl() {
        self.isMoving = false
        reset()
    }
    
    func reset() {
        if self.autoShowHide {
            outerControl.alpha = 0.25
            innerControl.alpha = 0.5
        }
        self.moveSize = CGSizeMake(0, 0)
        self.angle = self.defaultAngle
        innerControl.position = CGPointMake(0, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

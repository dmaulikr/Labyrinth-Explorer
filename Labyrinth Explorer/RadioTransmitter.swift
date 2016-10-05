//
//  RadioTransmitter.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 4/28/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import SpriteKit

class RadioTransmitter: SKSpriteNode {
    
    var radioTransmitterSurface = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(200, 300))
    var digitsDisplay = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(0, 0))
    var callButton = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeMake(50, 50))
    var denyCallButton = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(50, 50))
    var zeroButton = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50, 50))
    var oneButton = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50, 50))
    var twoButton = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50, 50))
    var threeButton = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50, 50))
    var fourButton = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50, 50))
    var fiveButton = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50, 50))
    var sixButton = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50, 50))
    var sevenButton = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50, 50))
    var eightButton = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50, 50))
    var nineButton = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50, 50))
    
    var digitsDisplayField = SKLabelNode(text: "")
    var digitZero = SKLabelNode(text: "0")
    var digitOne = SKLabelNode(text: "1")
    var digitTwo = SKLabelNode(text: "2")
    var digitThree = SKLabelNode(text: "3")
    var digitFour = SKLabelNode(text: "4")
    var digitFive = SKLabelNode(text: "5")
    var digitSix = SKLabelNode(text: "6")
    var digitSeven = SKLabelNode(text: "7")
    var digitEight = SKLabelNode(text: "8")
    var digitNine = SKLabelNode(text: "9")
    
    var sattelite = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(10, 160))
    var satteliteBall = SKShapeNode(circleOfRadius: 10)
    
    init(zPosition:CGFloat, size:CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
        self.position = position
        self.zPosition = zPosition
        addChild(radioTransmitterSurface)
        addChild(digitsDisplay)
        digitsDisplay.addChild(digitsDisplayField)
        digitsDisplayField.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        addChild(callButton)
        addChild(denyCallButton)
        addChild(zeroButton)
        zeroButton.addChild(digitZero)
        digitZero.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        addChild(oneButton)
        oneButton.addChild(digitOne)
        digitOne.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        addChild(twoButton)
        twoButton.addChild(digitTwo)
        digitTwo.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        addChild(threeButton)
        threeButton.addChild(digitThree)
        digitThree.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        addChild(fourButton)
        fourButton.addChild(digitFour)
        digitFour.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        addChild(fiveButton)
        fiveButton.addChild(digitFive)
        digitFive.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        addChild(sixButton)
        sixButton.addChild(digitSix)
        digitSix.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        addChild(sevenButton)
        sevenButton.addChild(digitSeven)
        digitSeven.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        addChild(eightButton)
        eightButton.addChild(digitEight)
        digitEight.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        addChild(nineButton)
        nineButton.addChild(digitNine)
        digitNine.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        addChild(sattelite)
        satteliteBall.fillColor = UIColor.grayColor()
        satteliteBall.strokeColor = UIColor.clearColor()
        addChild(satteliteBall)
    }
    
    var callInAction = false
    
    func animateDialing(numbersToDial:String, touchedNode:SKNode, action:SKAction) {
        if callButton == touchedNode && !callInAction {
            callInAction = true
            blinkButton(callButton, previousColor: callButton.color)
            let dialedNumber = self.digitsDisplayField.text
            self.runAction(SKAction.repeatActionForever(SKAction.sequence([
                SKAction.waitForDuration(0.5), SKAction.runBlock({
                    self.digitsDisplayField.text = "-"
                }),
                SKAction.waitForDuration(0.5), SKAction.runBlock({
                    self.digitsDisplayField.text = "- -"
                }),
                SKAction.waitForDuration(0.5), SKAction.runBlock({
                    self.digitsDisplayField.text = "- - -"
                })
                ])), withKey:"Calling")
            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(4.0),SKAction.runBlock({
                    self.removeActionForKey("Calling")
                    if dialedNumber == numbersToDial {
                        self.digitsDisplayField.text = "ACTIVE"
                        ron.lockTouchActions = true
                        self.callSucceed(action)
                    }
                    else {
                        self.digitsDisplayField.text = "ERROR"
                        self.runAction(SKAction.sequence([
                            SKAction.waitForDuration(2.0),SKAction.runBlock({
                                self.digitsDisplayField.text = ""
                                self.callInAction = false
                            })
                            ]), withKey:"errorCall")
                    }
                })]), withKey:"expectation")
        }
        else if denyCallButton == touchedNode && digitsDisplayField.text!.characters.count > 0 {
            blinkButton(denyCallButton, previousColor: denyCallButton.color)
            if !callInAction {
                digitsDisplayField.text = digitsDisplayField.text.substringToIndex(digitsDisplayField.tex!t.endIndex.predecessor())
            }
            else
            {
                callInAction = false
                self.removeActionForKey("Calling")
                self.removeActionForKey("errorCall")
                self.removeActionForKey("expectation")
                digitsDisplayField.text = ""
            }
        }
        else if digitsDisplayField.tex!t.characters.count < 8 {
            if zeroButton == touchedNode || digitZero == touchedNode {
                blinkButton(zeroButton, previousColor: zeroButton.color)
                digitsDisplayField.text+="0"
            }
            else if oneButton == touchedNode || digitOne == touchedNode {
                blinkButton(oneButton, previousColor: oneButton.color)
                digitsDisplayField.text+="1"
            }
            else if twoButton == touchedNode || digitTwo == touchedNode {
                blinkButton(twoButton, previousColor: twoButton.color)
                digitsDisplayField.text+="2"
            }
            else if threeButton == touchedNode || digitThree == touchedNode {
                blinkButton(threeButton, previousColor: threeButton.color)
                digitsDisplayField.text+="3"
            }
            else if fourButton == touchedNode || digitFour == touchedNode {
                blinkButton(fourButton, previousColor: fourButton.color)
                digitsDisplayField.text+="4"
            }
            else if fiveButton == touchedNode || digitFive == touchedNode {
                blinkButton(fiveButton, previousColor: fiveButton.color)
                digitsDisplayField.text+="5"
            }
            else if sixButton == touchedNode || digitSix == touchedNode {
                blinkButton(sixButton, previousColor: sixButton.color)
                digitsDisplayField.text+="6"
            }
            else if sevenButton == touchedNode || digitSeven == touchedNode {
                blinkButton(sevenButton, previousColor: sevenButton.color)
                digitsDisplayField.text+="7"
            }
            else if eightButton == touchedNode || digitEight == touchedNode {
                blinkButton(eightButton, previousColor: eightButton.color)
                digitsDisplayField.text+="8"
            }
            else if nineButton == touchedNode || digitNine == touchedNode {
                blinkButton(nineButton, previousColor: nineButton.color)
                digitsDisplayField.text+="9"
            }
        }
    }
    
    func callSucceed (action:SKAction) {
        self.parent!.runAction(action)
    }
    
    func blinkButton(button:SKNode, previousColor:UIColor) {
        button.runAction(SKAction.sequence([SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1, duration: 0.2),
            SKAction.colorizeWithColor(previousColor, colorBlendFactor: 1, duration: 0.2)]),completion:{
                let onlyDigits:[SKSpriteNode] = [self.zeroButton,self.oneButton,self.twoButton,self.threeButton,self.fourButton,self.fiveButton,self.sixButton,self.sevenButton,self.eightButton,self.nineButton]
                for digit in onlyDigits {
                    if digit.color != UIColor.grayColor() {
                        digit.color = UIColor.grayColor()
                    }
                }
                if self.callButton.color != UIColor.greenColor() {
                    self.callButton.color = UIColor.greenColor()
                }
                if self.denyCallButton.color != UIColor.redColor() {
                    self.denyCallButton.color = UIColor.redColor()
                }
        })
    }
    
    var dismissed = true
    
    func dismissRadioTransmitter() {
        
        let fixedPositionOfRadioTransmitter = CGPointMake(position.x, position.y-GameScene.sceneView!.frame.height)
        
        self.runAction(SKAction.sequence([SKAction.moveTo(fixedPositionOfRadioTransmitter, duration: 1),SKAction.runBlock({
            self.removeFromParent()
            self.dismissed = true
        })]), withKey:"radioTransmitterAppearance")
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
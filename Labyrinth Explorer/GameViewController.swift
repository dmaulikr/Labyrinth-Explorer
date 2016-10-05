//
//  GameViewController.swift
//  Labyrinth Explorer
//
//  Created by Muratbek Bauyrzhan on 3/5/15.
//  Copyright (c) 2015 Dimension. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var scene: MainScene!
    var skView:SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewSize = self.view.bounds.size
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            viewSize.height *= 2
            viewSize.width *= 2
        }
        
        skView = view as! SKView
        //skView.showsNodeCount = true
        //skView.showsFPS = true
        
        self.scene = Lvl4(size:CGSizeMake(1024, 768))
        scene.size = viewSize
        scene.scaleMode = .AspectFill
        
        let reveal = SKTransition.doorsCloseHorizontalWithDuration(0.5)
        skView?.presentScene(self.scene, transition: reveal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


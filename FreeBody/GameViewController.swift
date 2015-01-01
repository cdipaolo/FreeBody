//
//  GameViewController.swift
//  FreeBody
//
//  Created by Conner DiPaolo on 12/22/14.
//  Copyright (c) 2014 Applications of Computer Science Club. All rights reserved.
//

import UIKit
import SpriteKit



class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let skView = self.view as SKView
        
        if skView.scene == nil{
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            let mainMenu = MainMenuScene(size: skView.bounds.size)
            mainMenu.scaleMode = .AspectFill
            
            skView.presentScene(mainMenu)
        }
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

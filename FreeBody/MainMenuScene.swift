//
//  MainMenuScene.swift
//  FreeBody
//
//  Created by Conner DiPaolo on 12/30/14.
//  Copyright (c) 2014 Applications of Computer Science Club. All rights reserved.
//

import SpriteKit


class MainMenuScene: SKScene {

    override func didMoveToView(view: SKView) {
        self.backgroundColor = FBColors.BlueDark
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let freeBodyButton = FBButtonNode(text: "Free Body", identifier: "freebody", size: 100)
        freeBodyButton.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*3/4)
        self.addChild(freeBodyButton)

        let oneBodyButton = FBButtonNode(text: "One Body", identifier: "onebody", size: 60)
        oneBodyButton.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*3/4 - 100)
        self.addChild(oneBodyButton)

        let twoBodiesButton = FBButtonNode(text: "Two Bodies", identifier: "twobodies", size: 60)
        twoBodiesButton.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*3/4 - 180)
        self.addChild(twoBodiesButton)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        
        if let nodeTouchedName = self.nodeAtPoint(touch.locationInNode(self)).name? {
            switch nodeTouchedName{
            case "onebody":
                let oneBodyScene = OneBodyScene(size: self.size)
                self.view?.presentScene(oneBodyScene, transition: .doorsOpenHorizontalWithDuration(0.5))
                println("Touched 'One Body' Label")
            case "twobodies":
                let twoBodiesScene = TwoBodiesScene(size: self.size)
                self.view?.presentScene(twoBodiesScene, transition: .doorsOpenHorizontalWithDuration(0.5))
                println("Touched 'Two Bodies' Label")
            default:
                println("Touched away from buttons")
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

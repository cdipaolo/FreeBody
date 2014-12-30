//
//  MainMenuScene.swift
//  FreeBody
//
//  Created by Conner DiPaolo on 12/30/14.
//  Copyright (c) 2014 Applications of Computer Science Club. All rights reserved.
//

import SpriteKit


class MainMenuScene: SKScene {
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColorFromRGB(0x182C59)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        let freeBodyLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        freeBodyLabel.name = "freebody"
        freeBodyLabel.fontSize = 100
        freeBodyLabel.text = "Free Body"
        freeBodyLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*3/4)
        self.addChild(freeBodyLabel)
        
        let oneBodyLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        oneBodyLabel.fontColor = Colors.color("yellowBright")
        oneBodyLabel.name = "onebody"
        oneBodyLabel.fontSize = 60
        oneBodyLabel.text = "One Body"

        
        let oneBodyBox = SKShapeNode(rectOfSize: CGSizeMake(oneBodyLabel.frame.size.width+5, oneBodyLabel.frame.size.height+5))
        oneBodyBox.fillColor = Colors.color("blueDark")
        oneBodyBox.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*3/4 - 100)

        self.addChild(oneBodyBox)
        oneBodyBox.addChild(oneBodyLabel)
        oneBodyLabel.position = CGPointMake(0,-1*oneBodyLabel.parent!.frame.size.height/4)
        
        
        let twoBodiesLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        twoBodiesLabel.fontColor = Colors.color("yellowBright")
        twoBodiesLabel.name = "twobodies"
        twoBodiesLabel.fontSize = 60
        twoBodiesLabel.text = "Two Bodies"
        
        
        let twoBodiesBox = SKShapeNode(rectOfSize: CGSizeMake(twoBodiesLabel.frame.size.width+5, twoBodiesLabel.frame.size.height+5))
        twoBodiesBox.fillColor = Colors.color("blueDark")
        twoBodiesBox.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*3/4 - 180)
        self.addChild(twoBodiesBox)
        twoBodiesBox.addChild(twoBodiesLabel)
        twoBodiesLabel.position = CGPointMake(0,-1*twoBodiesLabel.parent!.frame.size.height/2.5)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        
        if let nodeTouchedName = self.nodeAtPoint(touch.locationInNode(self)).name? {
            switch nodeTouchedName{
            case "onebody":
                let oneBodyScene = OneBodyScene(size: self.size)
                self.view?.presentScene(oneBodyScene)
                println("Touched 'One Body' Label")
            case "twobodies":
                let twoBodiesScene = TwoBodiesScene(size: self.size)
                self.view?.presentScene(twoBodiesScene)
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

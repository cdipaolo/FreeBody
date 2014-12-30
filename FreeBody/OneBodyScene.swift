//
//  OneBodyScene.swift
//  FreeBody
//
//  Created by Conner DiPaolo on 12/30/14.
//  Copyright (c) 2014 Applications of Computer Science Club. All rights reserved.
//

import SpriteKit

class OneBodyScene: SKScene {
    var isOptionVisible:Bool = false

    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColorFromRGB(0x455E98)
    }

    override init(size: CGSize) {
        super.init(size: size)
        let node = SKShapeNode(rectOfSize: CGSizeMake(self.size.width/4, self.size.width/4));
        node.fillColor = UIColorFromRGB(0xE3CB58)
        node.lineWidth = 0
        node.name = "Node"
        node.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(node)

        let backText = SKLabelNode(fontNamed: "GillSans-Bold")
        backText.text = "Main Menu"

        let back = SKShapeNode(rectOfSize: backText.frame.size)
        back.addChild(backText)
        

        let options = SKShapeNode(rectOfSize: CGSizeMake(self.size.width/3, self.size.height))
        options.fillColor = UIColorFromRGB(0xD49A6A)
        options.position = CGPointMake(self.size.width*7/6, self.size.height/2)
        options.name = "Options"
        options.lineWidth = 0
        self.addChild(options)

        self.name = "Background"



    }

    func showOptionPane() {
        if !isOptionVisible {
            for child in children {
                (child as SKNode).runAction(SKAction.moveBy(CGVectorMake(-self.frame.width/3, 0), duration: 0.25))
            }
            isOptionVisible = true
        }
    }

    func hideOptionPane() {
        if isOptionVisible {
            for child in children {
                (child as SKNode).runAction(SKAction.moveBy(CGVectorMake(+self.frame.width/3, 0), duration: 0.25))
            }
            isOptionVisible = false
        }
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let nodeTouched = nodeAtPoint(touch.locationInNode(self))
        if (nodeTouched.name? != nil) {
            switch nodeTouched.name! {
            case "Node":
                showOptionPane()
            case "Background":
                hideOptionPane()
            default:
                println("Nothing Special Touched")
            }
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

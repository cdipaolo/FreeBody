//
//  OneBodyScene.swift
//  FreeBody
//
//  Created by Conner DiPaolo on 12/30/14.
//  Copyright (c) 2014 Applications of Computer Science Club. All rights reserved.
//

import SpriteKit

class OneBodyScene: SKScene {
    let node:SKShapeNode?
    let options:SKShapeNode?
    var isOptionVisible:Bool = false

    override func didMoveToView(view: SKView) {
        self.backgroundColor = FBColors.BlueDark
    }

    override init(size: CGSize) {
        super.init(size: size)

        let node = SKShapeNode(rectOfSize: CGSizeMake(self.size.width/4, self.size.width/4));
        node.fillColor = Colors.color("yellow")
        node.lineWidth = 0
        node.name = "Node"
        node.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(node)

        let backButton = FBButtonNode(text: "Main Menu", identifier: "Back", size: 24)
        self.addChild(backButton)
        backButton.position = CGPointMake(backButton.size.width/2+backButton.size.height/2, backButton.size.height)


        let options = SKShapeNode(rectOfSize: CGSizeMake(self.size.width/3, self.size.height))
        options.fillColor = Colors.color("brown")
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
            case "Options":
                print()
            case "Background":
                hideOptionPane()
            case "Back":
                self.view!.presentScene(MainMenuScene(size: self.size), transition: .doorsCloseHorizontalWithDuration(0.5))
            default:
                println("Nothing Touched")
            }
        }

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

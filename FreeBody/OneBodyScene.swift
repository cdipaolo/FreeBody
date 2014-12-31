//
//  OneBodyScene.swift
//  FreeBody
//
//  Created by Jackson Kearl on 12/30/14.
//  Copyright (c) 2014 Applications of Computer Science Club. All rights reserved.
//

import SpriteKit

class OneBodyScene: SKScene {

    var isOptionVisible:Bool = false
    var isRunning = false

    override func didMoveToView(view: SKView) {
        self.backgroundColor = FBColors.BlueDark
    }

    override init(size: CGSize) {
        super.init(size: size)

        let node = SKShapeNode(rectOfSize: CGSizeMake(self.size.width/4, self.size.width/4));
        node.fillColor = FBColors.Yellow
        node.lineWidth = 0
        node.name = "Node"
        node.position = CGPointMake(self.size.width/2, self.size.height/2)
        node.physicsBody = SKPhysicsBody(rectangleOfSize: node.frame.size)
        node.physicsBody?.dynamic = false
        self.addChild(node)

        let backButton = FBButtonNode(text: "Main Menu", identifier: "Back", size: 24)
        self.addChild(backButton)
        backButton.position = CGPointMake(backButton.size.width/2+backButton.size.height/2, backButton.size.height)


        let startButton = FBButtonNode(text: "Start", identifier: "Start/Stop", size: 24)
        startButton.name = "play"
        addChild(startButton)
        startButton.position = CGPointMake(startButton.size.width/2+startButton.size.height/2, self.size.height-startButton.size.height)

        let stopButton = FBButtonNode(text: "Stop", identifier: "Start/Stop", size: 24)
        stopButton.name = "pause"
        addChild(stopButton)
        stopButton.position = CGPointMake(stopButton.size.width/2+stopButton.size.height/2, self.size.height-stopButton.size.height)

        switchPlayButton()

        let options = SKShapeNode(rectOfSize: CGSizeMake(self.size.width/3, self.size.height))
        options.fillColor = FBColors.Brown
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

    func switchPlayButton() {
        let startButton = self.childNodeWithName("play")

        let stopButton = self.childNodeWithName("pause")

        if isRunning {
            startButton!.hidden = true
            startButton?.zPosition--
            stopButton!.hidden = false
            stopButton?.zPosition++
        }
        else {
            stopButton!.hidden = true
            stopButton?.zPosition--
            startButton!.hidden = false
            startButton?.zPosition++

        }
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let nodeTouched = nodeAtPoint(touch.locationInNode(self))
        if (nodeTouched.parent?.parent is FBButtonNode) {
            (nodeTouched.parent!.parent as FBButtonNode).setTouched(true)
        }
    }

    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch

        let nodeTouched = nodeAtPoint(touch.previousLocationInNode(self))

        if (nodeTouched !== nodeAtPoint(touch.locationInNode(self))) {
            if (nodeTouched.parent?.parent is FBButtonNode) {
                (nodeTouched.parent!.parent as FBButtonNode).setTouched(false)
            }
        }
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let nodeTouched = nodeAtPoint(touch.locationInNode(self))

        if (nodeTouched.parent?.parent is FBButtonNode) {
            (nodeTouched.parent!.parent as FBButtonNode).setTouched(false)
        }

        if (nodeTouched.name? != nil) {
            switch nodeTouched.name! {
            case "Node":
                showOptionPane()
            case "Background":
                hideOptionPane()
            case "Start/Stop":
                isRunning = !isRunning
                for node in self.children {
                    (node as SKNode).physicsBody?.dynamic = isRunning
                }
                switchPlayButton()

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

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
    let basePosition: CGPoint?

    override func didMoveToView(view: SKView) {
        self.backgroundColor = FBColors.BlueDark
    }

    override init(size: CGSize) {
        super.init(size: size)
        
        basePosition = CGPointMake(self.size.width/2, self.size.height/2)

        let node = SKShapeNode(rectOfSize: CGSizeMake(self.size.width/4, self.size.width/4));
        node.fillColor = FBColors.Yellow
        node.lineWidth = 0
        node.name = "Node"
        node.position = basePosition!
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
        stopButton.hidden = true

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
        isRunning = !isRunning
        
        let startButton = self.childNodeWithName("play")
        let stopButton = self.childNodeWithName("pause")

        if isRunning {
            // if physics is changed to running, start physics
            for node in self.children {
                (node as SKNode).physicsBody?.dynamic = isRunning
            }
            startButton!.hidden = true
            stopButton!.hidden = false
        }
        else {
            // Physics is changed to not running, turn it off! Move node to center
            for node in self.children {
                (node as SKNode).physicsBody?.dynamic = isRunning
                if (node as SKNode).name=="Node"{
                    println("moving node back to center")
                    (node as SKNode).position = basePosition!
                }
            }
            stopButton!.hidden = true
            startButton!.hidden = false
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
                
            case "Start/Stop":
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

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
    
    func triangleInRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> SKShapeNode {
        let rect = CGRectMake(x, y, width, height)
        let offsetX: CGFloat = CGRectGetMidX(rect)
        let offsetY: CGFloat = CGRectGetMidY(rect)
        var bezierPath: UIBezierPath = UIBezierPath()
        
        bezierPath.moveToPoint(CGPointMake(offsetX, 0))
        bezierPath.addLineToPoint(CGPointMake(-offsetX, offsetY))
        bezierPath.addLineToPoint(CGPointMake(-offsetX, -offsetY))
        bezierPath.closePath()
        
        let shape: SKShapeNode = SKShapeNode()
        shape.path = bezierPath.CGPath
        
        return shape
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

        let startButton = triangleInRect(0, y: 0, width: 32, height: 32)
        startButton.strokeColor = FBColors.YellowBright
        startButton.fillColor = FBColors.YellowBright
        startButton.name = "Play"
        addChild(startButton)
        startButton.position = CGPointMake(startButton.frame.size.width/2+startButton.frame.size.height/2, self.size.height-startButton.frame.size.height)

        let stopButton = SKShapeNode(rectOfSize: CGSizeMake(32, 32))
        stopButton.strokeColor = FBColors.YellowBright
        stopButton.fillColor = FBColors.YellowBright
        stopButton.name = "Pause"
        addChild(stopButton)
        stopButton.position = CGPointMake(stopButton.frame.size.width/2+stopButton.frame.size.height/2, self.size.height-stopButton.frame.size.height)
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
        
        let startButton = self.childNodeWithName("Play")
        let stopButton = self.childNodeWithName("Pause")

        if isRunning {
            // if physics is changed to running, start physics
            for node in self.children {
                (node as SKNode).physicsBody?.dynamic = true
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
                
            case "Play":
                switchPlayButton()
                
            case "Pause":
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

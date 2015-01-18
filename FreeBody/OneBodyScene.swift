//
//  OneBodyScene.swift
//  FreeBody
//
//  Created by Jackson Kearl on 12/30/14.
//  Copyright (c) 2014 Applications of Computer Science Club. All rights reserved.
//

import SpriteKit
import Darwin



class OneBodyScene: SKScene {

    // initialize instance variables
    var isOptionVisible = false
    var isRunning = false
    let basePosition: CGPoint?
    var forces: Stack<Force> = Stack<Force>()

    
    // set background to dark blue
    override func didMoveToView(view: SKView) {
        self.backgroundColor = FBColors.BlueDark
    }

    // returns a triangularly shaped SKShapeNode based on given dimensions
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
        node.physicsBody?.affectedByGravity = false
        self.addChild(node)

        let nodeCircle = SKShapeNode(circleOfRadius: 10)
        nodeCircle.fillColor = FBColors.Red
        nodeCircle.lineWidth = 0
        nodeCircle.name = "Node"
        node.addChild(nodeCircle)
        
        let π = M_PI
        
        let gravity: Force = Force(0,-9.8)
        
        let force = gravity.shapeNode(0, 0)
        let rotate = SKAction.rotateToAngle(CGFloat(3*π/2), duration: 0.0)
        
        gravity.correspondingNode = force
        self.forces.push(gravity)
        println("adding gravity to forces")
        
        
        force.runAction(rotate)
        force.name = "Force"
        node.addChild(force)
        println(self.forces.data)

        let backButton = FBButtonNode(text: "Main Menu", identifier: "Back", size: 24)
        backButton.name = "MainMenu"
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

        let forcesAdd = FBButtonNode(text: "+", identifier: "AddForce", size: 24)
        options.addChild(forcesAdd)
        
        let forcesSubtract = FBButtonNode(text: "-", identifier: "SubtractForce", size: 24)
        options.addChild(forcesSubtract)
        forcesSubtract.position = CGPointMake(40, 0)


        self.name = "Background"

    }

    func showOptionPane() {
        if !isOptionVisible {
            for child in children {
                let name = (child as SKNode).name
                if (name == "Node" || (child as SKNode).parent?.name == "Node") {
                    // move central node and children (force arrows in future maybe) to be in new center
                    (child as SKNode).runAction(SKAction.moveBy(CGVectorMake(-self.frame.width/6, 0), duration: 0.25))
                } else if (name == "MainMenu" ) {
                    //stay in the same place
                }
                else {
                    //move all the way. acts on option pane and children, along with all other nodes
                    (child as SKNode).runAction(SKAction.moveBy(CGVectorMake(-self.frame.width/3, 0), duration: 0.25))

                }
            }
            isOptionVisible = true
        }
    }

    func hideOptionPane() {
        if isOptionVisible {
            for child in children {
                let name = (child as SKNode).name
                if (name == "Node" || (child as SKNode).parent?.name == "Node") {
                    // move central node and children (force arrows in future maybe) to be in new center
                    (child as SKNode).runAction(SKAction.moveBy(CGVectorMake(+self.frame.width/6, 0), duration: 0.25))
                } else if (name == "MainMenu" ) {
                    //stay in the same place
                }
                else {
                    //move all the way. acts on option pane and children, along with all other nodes
                    (child as SKNode).runAction(SKAction.moveBy(CGVectorMake(+self.frame.width/3, 0), duration: 0.25))

                }
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
            if let node: SKNode = self.childNodeWithName("Node"){
                println("starting dynamic movement")
                node.physicsBody?.dynamic = isRunning
            }
            startButton!.hidden = true
            startButton?.zPosition--
            stopButton!.hidden = false
            stopButton?.zPosition++
        }
        else {
            // Physics is changed to not running, turn it off! Move node to center
            
            if let node: SKNode = self.childNodeWithName("Node"){
                println("stopping dynamic movement, moving node back to center")
                node.physicsBody?.dynamic = false
                node.position = basePosition!
            }
            
            stopButton!.hidden = true
            stopButton?.zPosition--
            startButton!.hidden = false
            startButton?.zPosition++

        }
    }

    // add a force to the forces stack
    func addForce(){
        
        let exampleForce: Force = Force(5,0)

        
        println("adding force | \(self.forces.data.count) objects in stack")
        if let object = self.childNodeWithName("Node"){
            let node: VectorNode = (exampleForce.shapeNode(0, 0) as VectorNode)
            exampleForce.correspondingNode = node
            node.name = "Force"
            object.addChild(node)
            println(self.forces.data)
            
            self.forces.push(exampleForce)
        }
    }
    
    // subtract (pop) the most recently allocated force from the forces stack
    func subtractForce(){
        if let tmp: Force = forces.pop() { tmp.correspondingNode!.removeFromParent() }
    }
    
    // changes a force in both data and visual representation based on user moving touch
    func changeForce(node: SKNode,_ touch: UITouch){
        let x = touch.locationInNode(node.parent).x
        let y = touch.locationInNode(node.parent).y
        
        let i = x / 25
        let j = y / 25
        
        if node is VectorNode{
            let force = (node as VectorNode).correspondingVector
            force!.i = Double(i)
            force!.j = Double(j)
            
            node.removeFromParent()
            let angle: CGFloat = i<0 ? CGFloat(force!.angle() + M_PI) : CGFloat(force!.angle())
            
            
            let rotate = SKAction.rotateToAngle(angle, duration: 0.0)
            let newNode: VectorNode = (force! as Force).shapeNode(0,0)
            newNode.runAction(rotate)
            force?.correspondingNode = newNode
            
            if let object = self.childNodeWithName("Node"){
                object.addChild(newNode)
            }
            
        }
        
        
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let childOfSceneNodeTouched = nodeAtPoint(touch.locationInNode(self))

        if (childOfSceneNodeTouched.parent?.parent is FBButtonNode) {
            (childOfSceneNodeTouched.parent!.parent as FBButtonNode).setTouched(true)
        }
    }

    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch

        let childOfMainSceneTouched = nodeAtPoint(touch.previousLocationInNode(self))


        if (childOfMainSceneTouched !== nodeAtPoint(touch.locationInNode(self))) {
            if (childOfMainSceneTouched.parent?.parent is FBButtonNode) {
                (childOfMainSceneTouched.parent!.parent as FBButtonNode).setTouched(false)

            }
        }

        let mainNode = self.childNodeWithName("Node")
        let childOfMainNodeTouched = mainNode?.nodeAtPoint(touch.locationInNode(mainNode))
        
        // if node touch, moved, is a force, change the force relative to the location of the touch
        if (childOfMainNodeTouched?.name? == "Force") {
            changeForce(childOfMainNodeTouched!, touch)
        }

    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let childOfSceneNodeTouched = nodeAtPoint(touch.locationInNode(self))

        if (childOfSceneNodeTouched.parent?.parent is FBButtonNode) {
            (childOfSceneNodeTouched.parent!.parent as FBButtonNode).setTouched(false)
        }

        if (childOfSceneNodeTouched.name? != nil) {
            switch childOfSceneNodeTouched.name! {

            case "Node":
                // if node clicked, show options panel
                showOptionPane()

            case "Background":
                // if options is visible, hide the options panel
                if isOptionVisible{
                    hideOptionPane()
                }

            case "Play":
                // play physics and switch to pause button
                switchPlayButton()

            case "Pause":
                // pause the physics and switch to play button
                switchPlayButton()

            case "Back":
                // if main menu button pressed, present main menu scene
                self.view!.presentScene(MainMenuScene(size: self.size), transition: .doorsCloseHorizontalWithDuration(0.5))

            case "AddForce":
                // if add force button is clicked, add generic force
                addForce()
                
            case "SubtractForce":
                // more efficient to check if forces is empty rather than run function every time
                //      even when you don't need to
                if !forces.isEmpty(){
                    subtractForce()
                }

            default:
                println("Nothing Touched")
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        if (isRunning){
            let node = self.childNodeWithName("Node")
            for force:Force in forces.data {
                node!.physicsBody?.applyForce(force.cgVector())
            }
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

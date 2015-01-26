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
    var netForce : CGVector = CGVectorMake(0,0)

    var v: Velocity = Velocity(0,0)
    var velocityIsNotShowing: Bool = true
    
    var gravityEnabled = true
    
    var magnitudesVisible = false
    
    
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
        node.physicsBody!.mass = 1
        self.addChild(node)
        
        
        // TODO: make either 15/2 or 15. 10 looks kinda funky inbetween
        let nodeCircle = SKShapeNode(circleOfRadius: 10)
        nodeCircle.fillColor = FBColors.Red
        nodeCircle.lineWidth = 1
        nodeCircle.strokeColor = FBColors.Red
        nodeCircle.name = "Node"
        nodeCircle.zPosition = 6 //cover anything under
        node.addChild(nodeCircle)
        
        updateGravity()

        
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
        
        let velocity = v.shapeNode(0, 0)
        velocity.name = "Velocity"
        velocity.position = CGPointMake(0, node.frame.size.height * 0.75)
        self.v.correspondingNode = velocity
        velocity.hidden = velocityIsNotShowing
        node.physicsBody?.velocity = v.scaledVector()
        
        node.addChild(velocity)
        
        
        setupOptionPane()
        
        self.name = "Background"
        
    }
    
    func setupOptionPane(){
        
        let options = SKShapeNode(rectOfSize: CGSizeMake(self.size.width/3, self.size.height))
        options.fillColor = FBColors.Brown
        options.position = CGPointMake(self.size.width*7/6, self.size.height/2)
        options.name = "Options"
        options.lineWidth = 0
        self.addChild(options)
        
        let forcesOptionsPane = FBButtonNode(text: "Forces:", identifier: nil, size: 32)
        options.addChild(forcesOptionsPane)
        
        let forcesAdd = FBButtonNode(text: "+", identifier: "AddForce", size: 28)
        forcesOptionsPane.addChild(forcesAdd)
        forcesAdd.position = CGPointMake(25, -35)
        
        let forcesSubtract = FBButtonNode(text: "-", identifier: "SubtractForce", size: 28)
        forcesOptionsPane.addChild(forcesSubtract)
        forcesSubtract.position = CGPointMake(-25, -35)
        
        
        
        let massOptionPane = FBButtonNode(text: "Mass:", identifier: nil, size: 32)
        options.addChild(massOptionPane)
        massOptionPane.position = CGPointMake(0, -100)
        
        let massValue = FBButtonNode(text: "1 kg", identifier: nil, size: 24)
        massOptionPane.addChild(massValue)
        massValue.position = CGPointMake(0, -35)
        massValue.name = "MassValueNode"
        
        let massIncrement = FBButtonNode(text: "+", identifier: "Mass++", size: 28)
        massOptionPane.addChild(massIncrement)
        massIncrement.position = CGPointMake(65, -35)
        
        let massDecrement = FBButtonNode(text: "-", identifier: "Mass--", size: 28)
        massOptionPane.addChild(massDecrement)
        massDecrement.position = CGPointMake(-65, -35)
        
        let massShiftU = FBButtonNode(text: ">", identifier: "Mass>>", size: 28)
        massOptionPane.addChild(massShiftU)
        massShiftU.position = CGPointMake(100, -35)
        
        let massShiftD = FBButtonNode(text: "<", identifier: "Mass<<", size: 28)
        massOptionPane.addChild(massShiftD)
        massShiftD.position = CGPointMake(-100, -35)
        
        let showNetForceBoolButton = FBBooleanButton(text: "Show Net Force", identifier: "showNetForce", size:24)
        options.addChild(showNetForceBoolButton)
        showNetForceBoolButton.position = CGPointMake(0, -200)
        
        let showVelocityButton = FBBooleanButton(text: "Show Velocity", identifier: "showVelocity", size:24)
        options.addChild(showVelocityButton)
        showVelocityButton.position = CGPointMake(0, -250)
        
        let enableGravityButton = FBBooleanButton(text: "Enable Gravity", identifier: "enableGravity", size: 24)
        enableGravityButton.switchEnabled()
        enableGravityButton.position = CGPointMake(0,-300)
        options.addChild(enableGravityButton)
        
        let showValuesButton = FBBooleanButton(text: "Show Magnitudes", identifier: "showMagnitudes", size: 24)
        showValuesButton.position = CGPointMake(0, -350)
        options.addChild(showValuesButton)
        
        
        
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
            
            let node = self.childNodeWithName("Node")
            node?.physicsBody?.velocity = self.v.scaledVector()
            
        }
        else {
            // Physics is changed to not running, turn it off! Move node to center
            
            if let node: SKNode = self.childNodeWithName("Node"){
                println("stopping dynamic movement, moving node back to center")
                node.physicsBody?.dynamic = false
                node.position = basePosition!
            }
            
            let node = self.childNodeWithName("Node")!;
            
            let oldVelocity = node.childNodeWithName("Velocity")
            oldVelocity!.removeFromParent()
            
            self.v.i = 0.0
            self.v.j = 0.0
            let velocity = v.shapeNode(0, 0)
            velocity.name = "Velocity"
            velocity.position = CGPointMake(0, node.frame.size.height * 0.75)
            self.v.correspondingNode = velocity
            velocity.hidden = velocityIsNotShowing
            node.physicsBody?.velocity = v.scaledVector()
            
            node.addChild(velocity)
            
            stopButton!.hidden = true
            stopButton?.zPosition--
            startButton!.hidden = false
            startButton?.zPosition++
            
        }
    }
    
    // add a force to the forces stack
    func addForce(){
        
        let exampleForce: Force = Force(15,0)
        
        
        println("adding force | \(self.forces.data.count) objects in stack")
        if let object = self.childNodeWithName("Node"){
            let node: VectorNode = (exampleForce.shapeNode(0, 0) as VectorNode)
            exampleForce.correspondingNode = node
            node.name = "Force"
            node.childNodeWithName("ForceLabel")?.hidden = !magnitudesVisible
            object.addChild(node)
            println(self.forces.data)
            
            self.forces.push(exampleForce)
        }
        updateNetForce()
    }
    
    // subtract (pop) the most recently allocated force from the forces stack
    func subtractForce(){
        if let tmp: Force = forces.pop() { tmp.correspondingNode!.removeFromParent() }
        updateNetForce()
    }
    
    // changes a force in both data and visual representation based on user moving touch
    func changeForce(node: SKNode,_ touch: UITouch){
        
        let LENGTH_PER_NEWTON:CGFloat = 10.0
        let VALUE_PER_NEWTON:CGFloat = 75.0
        
        let x = touch.locationInNode(node.parent).x
        let y = touch.locationInNode(node.parent).y
        
        let i = x / LENGTH_PER_NEWTON
        let j = y / LENGTH_PER_NEWTON
        
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
            newNode.childNodeWithName("ForceLabel")?.hidden = !magnitudesVisible

            if let object = self.childNodeWithName("Node"){
                object.addChild(newNode)
            }
            
        }
        updateNetForce()
        
        
    }
    
    func calculateNetForce(){
        var xComponent : CGFloat = 0
        var yComponent : CGFloat = 0
        for force:Force in forces.data {
            xComponent += CGFloat(force.i)
            yComponent += CGFloat(force.j)
        }
        for force:Force in forces.namedData.values {
            xComponent += CGFloat(force.i)
            yComponent += CGFloat(force.j)
        }
        netForce = CGVectorMake(xComponent, yComponent)
        
    }
    
    func updateNetForce(){
        calculateNetForce()
        
        let shouldShowNetForce = (self.childNodeWithName("//showNetForce")?.parent?.parent as FBBooleanButton).enabled
        
        self.childNodeWithName("//NetForce")?.removeFromParent()

        
        if (shouldShowNetForce){
            let netForceNode = Force(Double(netForce.dx), Double(netForce.dy))
            let node: VectorNode = (netForceNode.shapeNode(0, 0) as VectorNode)
            node.name = "NetForce"
            node.childNodeWithName("ForceLabel")?.hidden = !magnitudesVisible
            node.fillColor = FBColors.Orange
            node.strokeColor = FBColors.Orange
            
            let angle: CGFloat = netForce.dx<0 ? CGFloat(netForceNode.angle() + M_PI) : CGFloat(netForceNode.angle())
            
            node.zRotation = angle
            
            self.childNodeWithName("Node")?.addChild(node)
        }
        
    }
    
    // changes a force in both data and visual representation based on user moving touch
    func changeVelocity(node: SKNode,_ touch: UITouch){
        let v = self.v.correspondingNode
        let x = touch.locationInNode(node.parent).x - v!.position.x
        let y = touch.locationInNode(node.parent).y - v!.position.y
        
        let i = x / 10
        let j = y / 10
        
        if node is VectorNode{
            let velocity = self.v
            self.v.i = Double(i)
            self.v.j = Double(j)
            let movingObject = self.childNodeWithName("Node")
            
            let position = node.position
            
            node.removeFromParent()
            let angle: CGFloat = i<0 ? CGFloat(self.v.angle() + M_PI) : CGFloat(self.v.angle())
            
            let newNode: VectorNode = self.v.shapeNode(0,0)
            newNode.position = position
            newNode.zRotation = angle
            newNode.name = "Velocity"
            self.v.correspondingNode = newNode
            
            if let object = self.childNodeWithName("Node"){
                object.addChild(newNode)
            }
        }
        
    }
    
    
    func updateVelocity(vector: Velocity){
        if let node = self.childNodeWithName("Node") {
            if let velocityNode = node.childNodeWithName("Velocity") {
                
                let newVelocityNode = vector.shapeNode(0, 0)
                newVelocityNode.position = velocityNode.position
                newVelocityNode.name = "Velocity"
                
                newVelocityNode.zRotation = vector.i<0 ? CGFloat(vector.angle() + M_PI) : CGFloat(vector.angle())
                newVelocityNode.hidden = self.velocityIsNotShowing
                
                velocityNode.removeFromParent()
                node.addChild(newVelocityNode)
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let childOfSceneNodeTouched = nodeAtPoint(touch.locationInNode(self))
        
        if (childOfSceneNodeTouched.parent?.parent is FBBooleanButton) {
            (childOfSceneNodeTouched.parent!.parent as FBBooleanButton).switchEnabled();
        }
        else if (childOfSceneNodeTouched.parent?.parent is FBButtonNode) {
            (childOfSceneNodeTouched.parent!.parent as FBButtonNode).setTouched(true);
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        
        let childOfMainSceneTouched = nodeAtPoint(touch.previousLocationInNode(self))
        
        
        if (childOfMainSceneTouched !== nodeAtPoint(touch.locationInNode(self))) {
            if (childOfMainSceneTouched.parent?.parent is FBBooleanButton) {
                (childOfMainSceneTouched.parent!.parent as FBBooleanButton).switchEnabled();
            }
            else if (childOfMainSceneTouched.parent?.parent is FBButtonNode) {
                (childOfMainSceneTouched.parent!.parent as FBButtonNode).setTouched(false);
            }
        }
        
        let mainNode = self.childNodeWithName("Node")
        let childOfMainNodeTouched = mainNode?.nodeAtPoint(touch.previousLocationInNode(mainNode))
        
        // if node touch, moved, is a force, change the force relative to the location of the touch
        if (childOfMainNodeTouched?.name? == "Force") {
            changeForce(childOfMainNodeTouched!, touch)
        } else if (childOfMainNodeTouched?.name? == "Velocity" && !velocityIsNotShowing) {
            changeVelocity(childOfMainNodeTouched!, touch)
        }
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        updateNetForce()
        let touch = touches.anyObject() as UITouch
        let childOfSceneNodeTouched = nodeAtPoint(touch.locationInNode(self))
        
        if (childOfSceneNodeTouched.parent?.parent is FBBooleanButton) {
        }
        else if (childOfSceneNodeTouched.parent?.parent is FBButtonNode) {
            (childOfSceneNodeTouched.parent!.parent as FBButtonNode).setTouched(false);
        }
        
        if (childOfSceneNodeTouched.name? != nil) {
            switch childOfSceneNodeTouched.name! {
                
            case "Node":
                // if node clicked, show options panel
                showOptionPane()
                
            case "Background":
                // if options is visible, hide the options panel
                if isOptionVisible && childNodeWithName("Node")?.nodeAtPoint(touch.locationInNode(childNodeWithName("Node"))).name != "Force"{
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
                
            case "Mass++":
                //Increments mass vaalue of node, changes label in option pane to refelct new value
                let newMass = ++(self.childNodeWithName("Node")!.physicsBody!.mass)
                (self.childNodeWithName("//MassValueNode") as FBButtonNode).buttonText!.text = "\(Int(newMass)) kg"
                updateGravity()
                updateNetForce()
                
            case "Mass--":
                //Same as above, but does not allow mass to go below 1 kg
                let newMass = (self.childNodeWithName("Node")!.physicsBody!.mass) - 1
                if newMass > 0 {
                    (self.childNodeWithName("Node")!.physicsBody!.mass) = newMass
                    (self.childNodeWithName("//MassValueNode") as FBButtonNode).buttonText!.text = "\(Int(newMass)) kg"
                }
                updateGravity()
                updateNetForce()
                
            case "Mass>>":
                //Increments mass vaalue of node one magnitude, changes label in option pane to refelct new value
                (self.childNodeWithName("Node")!.physicsBody!.mass) *= 10
                let newMass = (self.childNodeWithName("Node")!.physicsBody!.mass)
                (self.childNodeWithName("//MassValueNode") as FBButtonNode).buttonText!.text = "\(Int(newMass)) kg"
                updateGravity()
                updateNetForce()
                
            case "Mass<<":
                //Same as above, but does not allow mass to go below 1 kg
                let newMass = Int((self.childNodeWithName("Node")!.physicsBody!.mass)/10)
                if newMass >= 1 {
                    (self.childNodeWithName("Node")!.physicsBody!.mass) = CGFloat(newMass)
                    (self.childNodeWithName("//MassValueNode") as FBButtonNode).buttonText!.text = "\(newMass) kg"
                }
                updateGravity()
                updateNetForce()
                
            case "showNetForce":
                updateNetForce()

            case "showVelocity":
                let velocity = self.v.correspondingNode as SKShapeNode?
                velocityIsNotShowing = !velocityIsNotShowing
                velocity?.hidden = velocityIsNotShowing
                
            case "enableGravity":
                gravityEnabled = !gravityEnabled
                updateGravity()
                updateNetForce()
                
            case "showMagnitudes":
                magnitudesVisible = !magnitudesVisible
                for force in forces.data {
                    force.correspondingNode?.childNodeWithName("ForceLabel")?.hidden = !magnitudesVisible
                }
                for force in forces.namedData.values {
                    force.correspondingNode?.childNodeWithName("ForceLabel")?.hidden = !magnitudesVisible
                }
                self.childNodeWithName("//NetForce")?.childNodeWithName("ForceLabel")?.hidden = !magnitudesVisible
                
                
            default:
                println("Nothing Touched")
            }
        }
    }
    
    func updateGravity(){
        forces.namedData["gravity"]?.correspondingNode?.removeFromParent()
        
        if (gravityEnabled){
        let π = M_PI
        
        let mass = Double(self.childNodeWithName("Node")!.physicsBody!.mass)
        
        let gravity: Force = Force(0, mass * -9.8)
        
        let force = gravity.shapeNode(0, 0)
        let rotate = SKAction.rotateToAngle(CGFloat(3*π/2), duration: 0.0)
        
        gravity.correspondingNode = force
        
        /*
        self.forces.push(gravity)
        println("adding gravity to forces")
        */
        self.forces.namedData.updateValue(gravity, forKey: "gravity")
        println("adding gravity to namedForces")
        
        
        force.runAction(rotate)
        force.name = "Gravity"
        self.childNodeWithName("Node")?.addChild(force)
        println(self.forces.data)
        //updateNetForce()
        } else {
            forces.namedData.removeValueForKey("gravity")
        }
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        if (isRunning){
            let VALUE_PER_NEWTON:CGFloat = 75.0
            let VALUE_PER_METER_PER_SECOND = 75.0


            let node = self.childNodeWithName("Node")
            let scaledVector = CGVectorMake(netForce.dx * VALUE_PER_NEWTON, netForce.dy * VALUE_PER_NEWTON)
            node?.physicsBody?.applyForce(scaledVector)
            
            
            let i: CGFloat? = node?.physicsBody?.velocity.dx
            let j: CGFloat? = node?.physicsBody?.velocity.dy
            
            self.v.i = Double(i!) / VALUE_PER_METER_PER_SECOND
            self.v.j = Double(j!) / VALUE_PER_METER_PER_SECOND
            
            updateVelocity(self.v)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

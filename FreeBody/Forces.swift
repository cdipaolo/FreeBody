//
//  Forces.swift
//  FreeBody
//
//  Created by Conner DiPaolo on 1/3/15.
//  Copyright (c) 2015 Applications of Computer Science Club. All rights reserved.
//

import Darwin
import SpriteKit

extension UIBezierPath {
    
    // creates an arrow shaped path with middle of base as start point and pointed end as end point
    class func arrowPath(tailLength: CGFloat, tailWidth: CGFloat, headWidth: CGFloat) -> UIBezierPath {
        
        let midY: CGFloat = tailWidth / 2
        
        var polygonPath = UIBezierPath()
        polygonPath.moveToPoint(CGPointMake(0, 0))
        polygonPath.addLineToPoint(CGPointMake( 0, -midY))
        polygonPath.addLineToPoint(CGPointMake( tailLength, -midY))
        polygonPath.addLineToPoint(CGPointMake( tailLength, -headWidth))
        polygonPath.addLineToPoint(CGPointMake( tailLength + headWidth, 0))
        polygonPath.addLineToPoint(CGPointMake( tailLength, headWidth))
        polygonPath.addLineToPoint(CGPointMake( tailLength, midY))
        polygonPath.addLineToPoint(CGPointMake( 0, midY))
        
        polygonPath.closePath()
        
        
        return polygonPath
    }
}


// implementation of a stack data structure to hold forces
class Stack<T>{
    var namedData = [String: T]()
    
    var data: Array<T> = []
    
    func items() -> Int{
        return data.count
    }
    
    func isEmpty() -> Bool{
        return data.count == 0
    }
    
    func push(value: T) -> Void{
        data.append(value)
    }
    
    func pop() -> T?{
        if !self.isEmpty(){
            let tmp: T = data.last!
            data.removeLast()
            return tmp
        } else {
            return nil
        }
    }
}

class Vector{
    
    var correspondingNode: VectorNode? {
            didSet {
                if (self.correspondingNode!.correspondingVector !== self) {
                    self.correspondingNode!.correspondingVector = self
            }
        }
    }
    
    var i: Double
    var j: Double
    
    var magnitude: Double {
        get {
            return sqrt( self.i*self.i + self.j*self.j )
        }
    }
    
    // let gravity: Vector = Vector(0,-9.8)
    init (_ iVal: Double, _ jVal: Double){
        // i units (x axis)
        i = iVal
        
        // j units (y axis)
        j = jVal
    }
    
    // returns angle from x axis
    func angle() -> Double{
        let artan: Double = self.j / self.i
        return atan(artan)
    }
    
    // return CGVector with Vector's properties
    func scaledVector() -> CGVector{
        return CGVector(dx: CGFloat(self.i), dy: CGFloat(self.j))
    }
}

class Force: Vector{
    let LENGTH_PER_NEWTON = 10.0
    let VALUE_PER_NEWTON = 75.0
    // creates SKShapeNode which is sized relative to a CGFrame
    func shapeNode(x: CGFloat, _  y: CGFloat) -> VectorNode{
        let color = FBColors.Red
        let tailWidth: CGFloat = CGFloat(15)
        let headWidth: CGFloat = 2 * tailWidth

        let path: UIBezierPath = UIBezierPath.arrowPath(CGFloat(magnitude * LENGTH_PER_NEWTON), tailWidth: tailWidth, headWidth: headWidth)
        
        let shape: VectorNode = VectorNode()
        shape.path = path.CGPath
        shape.fillColor = color
        shape.strokeColor = color
        shape.name = "Force"
        
        
        let valueLabel = SKLabelNode(fontNamed: "Courier")
        
        valueLabel.text = String(format: "%.1f N", magnitude)
        valueLabel.fontSize = 22
        valueLabel.name = "ForceLabel"
        valueLabel.zPosition=7
        valueLabel.position = CGPointMake(CGFloat(magnitude / 2.0 * LENGTH_PER_NEWTON), -8)
        valueLabel.hidden = true
        shape.addChild(valueLabel)
        
        return shape
    }
    
    override func scaledVector() -> CGVector{
        return CGVector(dx: CGFloat(self.i * VALUE_PER_NEWTON), dy: CGFloat(self.j * VALUE_PER_NEWTON))
    }
}

class Velocity: Vector{
    let LENGTH_PER_METER_PER_SECOND = 10.0
    let VALUE_PER_METER_PER_SECOND = 75.0
    
    // creates SKShapeNode shaped like an arrow
    func shapeNode(x: CGFloat, _ y: CGFloat) -> VectorNode{
        let color = FBColors.Green
        let tailWidth: CGFloat = CGFloat(6)
        let headWidth: CGFloat = 2 * tailWidth
        
        let path: UIBezierPath = UIBezierPath.arrowPath(CGFloat(magnitude * LENGTH_PER_METER_PER_SECOND), tailWidth: tailWidth, headWidth: headWidth)
        
        let shape: VectorNode = VectorNode()
        shape.path = path.CGPath
        shape.fillColor = color
        shape.strokeColor = color
        
        return shape
    }
    // return CGVector with Vector's properties
    override func scaledVector() -> CGVector{
        return CGVector(dx: CGFloat(self.i * VALUE_PER_METER_PER_SECOND), dy: CGFloat(self.j * VALUE_PER_METER_PER_SECOND))
    }
}


class VectorNode: SKShapeNode {
    var correspondingVector: Vector? {
        didSet{
            if (self.correspondingVector?.correspondingNode? !== self) {
                self.correspondingVector?.correspondingNode? = self
            }
        }
    }
    
}
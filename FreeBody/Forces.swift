//
//  Forces.swift
//  FreeBody
//
//  Created by Conner DiPaolo on 1/3/15.
//  Copyright (c) 2015 Applications of Computer Science Club. All rights reserved.
//

import Darwin
import SpriteKit

// UIBezierPath extension from 'mwermuth' on GitHub Gist to add arrows with dimensions
extension UIBezierPath {
    
    class func getAxisAlignedArrowPoints(inout points: Array<CGPoint>, forLength: CGFloat, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat ) {
        
        let tailLength = forLength - headLength
        points.append(CGPointMake(0, tailWidth/2))
        points.append(CGPointMake(tailLength, tailWidth/2))
        points.append(CGPointMake(tailLength, headWidth/2))
        points.append(CGPointMake(forLength, 0))
        points.append(CGPointMake(tailLength, -headWidth/2))
        points.append(CGPointMake(tailLength, -tailWidth/2))
        points.append(CGPointMake(0, -tailWidth/2))
        
    }
    
    
    class func transformForStartPoint(startPoint: CGPoint, endPoint: CGPoint, length: CGFloat) -> CGAffineTransform{
        let cosine: CGFloat = (endPoint.x - startPoint.x)/length
        let sine: CGFloat = (endPoint.y - startPoint.y)/length
        
        return CGAffineTransformMake(cosine, sine, -sine, cosine, startPoint.x, startPoint.y)
    }
    
    
    class func bezierPathWithArrowFromPoint(startPoint:CGPoint, endPoint: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> UIBezierPath {
        
        let xdiff: Float = Float(endPoint.x) - Float(startPoint.x)
        let ydiff: Float = Float(endPoint.y) - Float(startPoint.y)
        let length = hypotf(xdiff, ydiff)
        
        var points = [CGPoint]()
        self.getAxisAlignedArrowPoints(&points, forLength: CGFloat(length), tailWidth: tailWidth, headWidth: headWidth, headLength: headLength)
        
        var transform: CGAffineTransform = self.transformForStartPoint(startPoint, endPoint: endPoint, length:  CGFloat(length))
        
        var cgPath: CGMutablePathRef = CGPathCreateMutable()
        CGPathAddLines(cgPath, &transform, points, 7)
        CGPathCloseSubpath(cgPath)
        
        var uiPath: UIBezierPath = UIBezierPath(CGPath: cgPath)
        return uiPath
    }
}


// implementation of a stack data structure to hold forces
class Stack<T>{
    var data: Array<T> = []
    
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
    
    var i: Double
    var j: Double
    var identifier: UInt32
    
    var magnitude: Double {
        get {
            return sqrt( self.i*self.i + self.j*self.j )
        }
    }
    
    // let gravity: Vector = Vector(0,-9.8)
    init (_ iVal: Double, _ jVal: Double, identifier bitmask: UInt32){
        // i units (x axis)
        i = iVal
        
        // j units (y axis)
        j = jVal
        
        // set bitmask identifier
        identifier = bitmask
    }
    
    // returns angle from x axis
    func angle() -> Double{
        let artan: Double = self.j / self.i
        return atan(artan)
    }
    
    // return CGVector with Vector's properties
    func cgVector() -> CGVector{
        return CGVector(dx: CGFloat(self.i), dy: CGFloat(self.j))
    }
}

class Force: Vector{
    
    // creates SKShapeNode which is sized relative to a CGFrame
    func shapeNode(x: CGFloat, y: CGFloat) -> SKShapeNode{
        let color = FBColors.Red
        let tailWidth: CGFloat = CGFloat(10)
        let headWidth: CGFloat = 2.5 * tailWidth
        let initial: CGPoint = CGPoint(x: x, y: y)
        let final : CGPoint = CGPoint(x: x + CGFloat(self.i), y: y + CGFloat(self.j))
        
        let path: UIBezierPath = UIBezierPath.bezierPathWithArrowFromPoint(initial, endPoint: final, tailWidth: tailWidth, headWidth: headWidth, headLength: CGFloat(self.magnitude))
        
        let shape: SKShapeNode = SKShapeNode()
        shape.path = path.CGPath
        shape.fillColor = color
        shape.strokeColor = color
        
        return shape
    }
}

class Velocity: Vector{
    
    // creates SKShapeNode which is sized relative to a CGFrame
    func shapeNode(x: CGFloat, y: CGFloat) -> SKShapeNode{
        let color = FBColors.Green
        let tailWidth: CGFloat = CGFloat(6)
        let headWidth: CGFloat = 2.5 * tailWidth
        let initial: CGPoint = CGPoint(x: x, y: y)
        let final : CGPoint = CGPoint(x: x + CGFloat(self.i * 10), y: y + CGFloat(self.j * 10))
        
        let path: UIBezierPath = UIBezierPath.bezierPathWithArrowFromPoint(initial, endPoint: final, tailWidth: tailWidth, headWidth: headWidth, headLength: CGFloat(self.magnitude * 100))
        
        let shape: SKShapeNode = SKShapeNode()
        shape.path = path.CGPath
        shape.fillColor = color
        shape.strokeColor = color
        
        return shape
    }
}
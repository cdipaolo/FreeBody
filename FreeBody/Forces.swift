//
//  Forces.swift
//  FreeBody
//
//  Created by Conner DiPaolo on 1/3/15.
//  Copyright (c) 2015 Applications of Computer Science Club. All rights reserved.
//

import Darwin

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

class Force{
    
    var i: Double
    var j: Double
    
    var magnitude: Double {
        get {
            return sqrt( self.i*self.i + self.j*self.j )
        }
    }
    
    // let gravity: Force = Force(0,-9.8)
    init (_ iVal: Double, _ jVal: Double){
        // i units (x axis)
        i = iVal
        println("setting force.i to \(iVal)...")
        println("force.i = \(self.i)")
        // j units (y axis)
        j = jVal
        println("setting force.j to \(jVal)...")
        println("force.j = \(self.j)")
    }
    
    // returns angle from x axis
    func angle() -> Double{
        let artan: Double = self.j / self.i
        return atan(artan)
    }
}
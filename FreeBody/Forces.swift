//
//  Forces.swift
//  FreeBody
//
//  Created by Conner DiPaolo on 1/3/15.
//  Copyright (c) 2015 Applications of Computer Science Club. All rights reserved.
//

import Darwin

// returns power of a double to an int
// pow(2,3) = 8
func power(x: Double, y: Int) -> Double{
    if y < 0 {
        return 1 / power(x, -y)
    } else if y == 0 {
        return 1
    } else if y == 1 {
        return x
    } else {
        var power = x
        for (var i = 0; i < y; i++) {
            power *= x
        }
        return power
    }
}

// returns the arc tangent of a number
// arctan(1) = pi/4 = .78539...
func arctan(x: Double) -> Double{
    let tmp: Double = x - (power(x,3)/3) + (power(x,5)/5) - (power(x, 7)/7) + (power(x,9)/9)
    return tmp
}

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
    private var _i: Double = 0
    private var _j: Double = 0
    private var _magnitude: Double = 0
    
    var i: Double {
        set{
            self._i = i
            self._magnitude = sqrt( self._i*self._i + self._j*self._j )
        } get {
            return self._i
        }
    }
    
    var j: Double {
        set{
            self._j = j
            self._magnitude = sqrt( self._i*self._i + self._j*self._j )
        } get {
            return self._j
        }
    }
    
    var magnitude: Double {
        get {
            return self._magnitude
        }
    }
    
    // let gravity: Force = Force(0,-9.8)
    init (_ iVal: Double, _ jVal: Double){
        // i units (x axis)
        i = iVal
        
        // j units (y axis)
        j = jVal
    }
    
    // returns angle from x axis
    func angle() -> Double{
        let artan: Double = self.j / self.i
        return arctan(artan)
    }
}
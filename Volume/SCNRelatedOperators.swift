//
//  SCNExtentions.swift
//  ScnTesting
//
//  Created by Justin Smith on 6/26/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import SceneKit

struct Degree {
    init(_ v: Float) { value = v }
    let value : Float
    var toRadians : Float {
        return GLKMathDegreesToRadians(value)
    }
}

extension Degree : Equatable
{
    
}

func == (lhs: Degree, rhs: Degree) -> Bool
{
    return lhs.value == rhs.value
}

struct Radian {
    init(_ v: Float) { value = v }
    let value : Float
    var toDegrees : Float {
        return GLKMathRadiansToDegrees(value)
    }
}



infix operator ^^
func ^^ (radix: Float, power: Float) -> Float { return Float(pow(Double(radix), Double(power))) }

func +(lhs:SCNVector3, rhs:SCNVector3)->SCNVector3
{
    return SCNVector3(x:lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
}


extension SCNVector3 : CustomStringConvertible{
    public var description : String {
        get { return "x:\(x),y:\(y),z:z\(z)" }
    }
}



func -(lhs:SCNVector3, rhs:SCNVector3) -> SCNVector3
{
    return SCNVector3(lhs.x-rhs.x, lhs.y-rhs.y, lhs.z-rhs.z)
}


func * ( lhs: SCNVector3, rhs:Float) -> SCNVector3
{
    return SCNVector3(lhs.x*rhs, lhs.y*rhs, lhs.z*rhs)
}


func / ( lhs: SCNVector3, rhs:Float) -> SCNVector3
{
    return SCNVector3(lhs.x/rhs, lhs.y/rhs, lhs.z/rhs)
}

extension SCNVector3 {
    init (x : Double, y : Double, z : Double) {
      self.init(Float(x), Float(y), Float(z))
    }
    
    init (_ vector:GLKVector3) {
      self.init(vector.x, vector.y, vector.z)
    }
}

extension SCNVector4 {
    init (x : Double, y : Double, z : Double, w : Double) {
        self.init(Float(x),   Float(y) ,  Float(z), Float(w))
    }
}


extension Int {
    func format(_ f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension Double {
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

extension CGFloat {
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

extension CGPoint {
    func format(_ f: String) -> String {
        let s = "(" + String(format: "%\(f)f", self.x) + ", " + String(format: "%\(f)f", self.y) + ")"
        return s
    }
}

extension SCNNode {
    convenience init(light:SCNLight) {
        self.init()
        self.light = light
    }
    
    
    convenience init(camera:SCNCamera) {
        self.init()
        self.camera = camera
    }
    
    
    convenience init(_ nodes:SCNNode ...) {
        self.init()
        
        for node in nodes {
            addChildNode(node)
        }
    }
}



extension Array {
    func baseAddress() -> UnsafePointer<Element> {
        return withUnsafeBufferPointer { $0.baseAddress! }
    }
}


func sizeofArray<T>(_ a:[T]) -> Int {
    return MemoryLayout<T>.size * a.count
}


extension SCNLight {
    convenience init(type:String) {
        self.init()
        self.type = SCNLight.LightType(rawValue: type)
    }
}


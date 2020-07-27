//
//  Camera.swift
//  Scaffolding
//
//  Created by Justin Smith on 7/23/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import Foundation



struct Camera {
    //distance
    var distance : Float
    //xFov // Can't set due to SCNCamera Issue
    var xFov : Float
    //yFov
    var yFov : Float
    //Orbit
    var orbitX : Float
    
    var orbitY : Float
    
    var orbitZ : Float
}

protocol CameraObserver {
    func owner(_: CameraOwner, didChange camera: Camera)
}

protocol CameraOwner {
    var camera : Camera { get set }
    func addObserver (observer: CameraObserver)
}

/*
 func zoomOut () {
 
 var  min2 = SCNVector3()
 var max2 = SCNVector3()
 contentNode.__getBoundingBoxMin(&min2, max: &max2)
 
 var strin = ""
 let orien = calculateCameraDirection(pointOfView!)
 guard let rot = pointOfView?.rotation else { fatalError() }
 strin += "rot:\(rot.x),\(rot.y),\(rot.z),\(rot.w)\n"
 let euler = (pointOfView?.eulerAngles)!
 strin += "euler:\(euler.x),\(euler.y),\(euler.z)"
 //strin += "orien:\(orien.x),\(orien.y),\(orien.z)"
 print(strin)
 
 scnpointOfView?.position = (pointOfView?.position)! - SCNVector3(orien) * 10.0
 }
*/

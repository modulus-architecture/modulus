//
//  CADView.swift
//  ScnTesting
//
//  Created by Justin Smith on 6/15/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import UIKit
import SceneKit

extension CADView : SCNContentContext // add child node content
{
  var sceneView : SCNView { return self.scnView }
  var bounder : SCNBounder { return self.scnView }
  var contentNode : SCNNode { return self.scnView.contentNode }
}



//This uses p0 as a starting point to, then, find the next point you want on a given direction. t is the length of the vector, or the distance you want to travel from p0.
//To find the direction the camera is pointing, you must get it's rotation and multiply by a Rotation Matrix.

class CADView : UIView
{
    var camera : Camera {
        set (newCamera) {
            scnView.cameraDistance = newCamera.distance
            scnView.fovDegrees =  (newCamera.xFov, newCamera.yFov)
            scnView.cameraOrbit.eulerAngles.x = GLKMathDegreesToRadians(newCamera.orbitX)
            scnView.cameraOrbit.eulerAngles.y = GLKMathDegreesToRadians(newCamera.orbitY)
            scnView.cameraOrbit.eulerAngles.z = GLKMathDegreesToRadians(newCamera.orbitZ)
        }
        get {
            
            let c = Camera(
                distance: scnView.cameraDistance
                , xFov: scnView.fovDegrees.x
                , yFov: scnView.fovDegrees.y
                , orbitX: GLKMathRadiansToDegrees(scnView.cameraOrbit.eulerAngles.x)
                , orbitY: GLKMathRadiansToDegrees(scnView.cameraOrbit.eulerAngles.y)
                , orbitZ: GLKMathRadiansToDegrees(scnView.cameraOrbit.eulerAngles.z)
            )
            return c
        }
    }
    
    
    private var scnView : _CADView
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
   init(frame: CGRect, view: CameraView) {
      self.scnView = _CADView(frame: frame, cameraAngle: cameraViewToGeo(view))
      super.init(frame: frame)
        addSubview(scnView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scnView.frame = self.frame
    }
    
    // MARK: Ortho Iso
    
    var  orthographic  = false
        {
        didSet {
            self.scnView.pointOfView?.camera?.usesOrthographicProjection = orthographic
        }
    }
    
    // MARK: Zoom
    
    
    
    
    // MARK: Zoom Extents
    
    // Zooming Functions
    
    // Depends on bounding3D, camDistance
    
    fileprivate func distanceToZoomExtents (withinFrame zoomFrame: CGRect) -> Float
    {
        let (_, max1) = scnView.boundingMinAndMax
        
        // Assume zoomframe is symmetrical to view.frame
        // get radians of origin as a projected point of the viewing pyramid
        
        let (xFOVWithMargins, yFOVWithMargins) = scnView.radiansOf(projectedPoint: zoomFrame.origin)
        
        // Distance to camera - bounding edge closest - Trig: Adjancent height when given a y
        let distanceToMoveX = scnView.cameraDistance - max1.z - max1.x/tan(xFOVWithMargins/2)
        let distanceToMoveY = scnView.cameraDistance - max1.z - max1.y/tan(yFOVWithMargins/2)
        
        // Minus the larger distance from Camera so that
        // either x or y margin is always greater than or equal to margin
        
        let cameraDistanceMove : Float
        
        if distanceToMoveY < distanceToMoveX {
            cameraDistanceMove = scnView.cameraDistance - distanceToMoveY
        }
        else
        {
            cameraDistanceMove = scnView.cameraDistance - distanceToMoveX
        }
        
        return cameraDistanceMove
    }
    
    
    // Zoom Extents
    
    lazy var zoomFrame : CGRect = // Set after init
        {
            return self.frame.insetBy(dx: 44, dy: 44)
    }()
    
    func zoomExtents () {
        scnView.cameraDistance = distanceToZoomExtents(withinFrame: zoomFrame)
    }
    
    // MARK: 2D Debuggin
    // Zoom Frame Debuging
    
    func viewThing(view: UIView)
    {
        view.backgroundColor = .clear
    }
    
    class ClearView : UIView {
        internal override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            return false
        }
    }
    
    fileprivate lazy var zoomFrameView : UIView =
        {
            let v = ClearView(frame: self.zoomFrame)
            v.layer.borderColor = UIColor.red.cgColor
            v.layer.borderWidth = 1.0
            return v
    }()
    
    var showsZoomFrame = false {
        didSet {
            switch showsZoomFrame
            {
            case true: self.addSubview(zoomFrameView)
            case false: zoomFrameView.removeFromSuperview()
            }
        }
    }
    
    fileprivate lazy var crossHairsView : UIView =
    {
        class CrossView : UIView {
            override func draw(_ rect: CGRect) {
                let path = UIBezierPath(ovalIn: rect)
                UIColor.red.setFill()
                path.fill()
            }
        }
        
        let v = ClearView(frame: self.frame)
        let size : CGFloat = 44.0
        let cross = CrossView(frame: self.frame.insetBy(dx: self.frame.width/2 - size/2, dy: self.frame.height/2 - size/2))
        v.addSubview (cross)
        
        return v
    }()
    
    var showCrossHairs = false {
        didSet {
            switch showCrossHairs
            {
            case true: self.addSubview(crossHairsView)
            case false: crossHairsView.removeFromSuperview()
            }
        }
    }
    
    // MARK: 3D Debuggin
    
    
   
   
    
    var currentView : CameraView = .top
        {
        didSet {
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 2.0
            
         scnView.cameraOrbit.eulerAngles = cameraViewToGeo(currentView)
            
            SCNTransaction.completionBlock = {
                SCNTransaction.animationDuration = 0.0
            }
            
            SCNTransaction.commit()
        }
    }

}

func cameraViewToGeo(_ view: CameraView) -> SCNVector3 {
   switch view {
   case .top:
      return SCNVector3(x:  -Float.pi/2, y:0.0, z: 0)
   case .bottom:
      return SCNVector3(x:  Float.pi/2, y:0.0, z: 0)
   case .front:
      return SCNVector3(x:  0, y:0.0, z: 0)
   case .back:
      return SCNVector3(x:  0.0 , y:-Float.pi, z: 0)
   case .leftSide:
      return SCNVector3(x:  0, y:Float.pi/2, z: 0.0 )
   case .rightSide:
      return SCNVector3(x:  0, y:-Float.pi/2, z: 0.0 )
   default:
      return SCNVector3(x: Float.zero, y: 0, z: 0)
   }
}

fileprivate class _CADView : SCNView, UIScrollViewDelegate, SCNBounder, SCNContentNodeProvider
{
  
  fileprivate var cameraOrbit : SCNNode { return forceReturnOrbitalCamera() }
  private var _cameraOrbit : SCNNode
  private var cameraNode : SCNNode
  public var contentNode : SCNNode
    
    
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

   init(frame: CGRect, cameraAngle: SCNVector3) {
        // Setup content node
        contentNode = SCNNode()
        
        // Set up camera
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.automaticallyAdjustsZRange = true
        cameraNode.camera?.orthographicScale = 12.0

      // Set up orbit
      _cameraOrbit = SCNNode()
      _cameraOrbit.addChildNode(cameraNode)
      _cameraOrbit.eulerAngles = cameraAngle

        super.init(frame: frame, options: [:])

        cameraDistance = 8.0 // Equivalent to cameraNode.position = SCNVector3(x: 0, y: 0, z: 8.0)

        scene = SCNScene()
        scene!.rootNode.addChildNode(contentNode)
        scene!.rootNode.addChildNode(_cameraOrbit)

        // configure the view
        backgroundColor = UIColor(white: 1, alpha: 1)
        
        // Do any additional setup after loading the view.
        setupLightStuff()
        allowsCameraControl = true
    }
  
  private func forceReturnOrbitalCamera() -> SCNNode {
    if pointOfView == cameraNode {
      return _cameraOrbit
    }
    
    // have CAD's camera match Apples Point Of View
    func matchCameraToPointOfView(){
      
      let p = pointOfView!.position
      let (x,y,z) = (p.x,p.y,p.z)
      let d = sqrt( pow(x,2) + pow(y,2) + pow(z,2) )

      cameraDistance = d
      _cameraOrbit.eulerAngles = pointOfView!.eulerAngles
      camera.orthographicScale = pointOfView!.camera!.orthographicScale
      camera.usesOrthographicProjection = pointOfView!.camera!.usesOrthographicProjection
      camera.fieldOfView = pointOfView!.camera!.fieldOfView
      
      
      pointOfView = cameraNode
    }
    
    matchCameraToPointOfView()
    return _cameraOrbit
  }
  
    
    // MARK: - Lighting
    private func setupLightStuff()
    {
        // Add 4 omni lights above the corners of the chess board
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        light.attenuationStartDistance = 5_000
        light.attenuationEndDistance = 250_000
        light.color = UIColor.white
        
        let lightNode = SCNNode()
        lightNode.light = light
        // The lights are positioned at a certain height and at
        // some offset from the center, along both X and Z.
        
        let distanceModifier :Float = 8000.0
        let height:Float = 3 * distanceModifier
        let offset:Float = 5 * distanceModifier
        
        lightNode.position = SCNVector3(x: -offset, y: height, z: -offset)
        scene!.rootNode.addChildNode(lightNode.copy() as! SCNNode)
        
        lightNode.position = SCNVector3(x: -offset, y: height, z: offset)
        scene!.rootNode.addChildNode(lightNode.copy() as! SCNNode)
        
        lightNode.position = SCNVector3(x: offset, y: height, z: -offset)
        scene!.rootNode.addChildNode(lightNode.copy() as! SCNNode)
        
        //lightNode.position = SCNVector3(x: offset, y: height, z: offset)
        //rootNode.addChildNode(lightNode.copy() as! SCNNode)
    }
    
    
    
    
    // From Vectorworks
    // var cameraHeight : CGFloat
    // var lookToHeight : CGFloat
    // var cameraMoveLeftMoveRight : CGFloat
    // var cameraDistance : CGFloat 
    // var focalLength : CGFloat
    // var fieldOfView : Radians
    
    fileprivate var cameraDistance : Float  {
        set (newValue) {
            cameraNode.position.z = newValue
        }
        get {
            return cameraNode.position.z
        }
    }
   
   fileprivate var fovDegrees : (x: Float, y: Float) {
       get {
           let xDegrees = GLKMathRadiansToDegrees(fovRadians.x)
           
           let yDegrees = GLKMathRadiansToDegrees(fovRadians.y)
           
           return (xDegrees, yDegrees)
       }
       set(new) {
         camera.fieldOfView = CGFloat(new.y)
       }
   }
   
   fileprivate func radiansOf(projectedPoint point: CGPoint) -> (x: Float, y: Float) {
       // convert point to SCNVectors at SCNKit's near:0 and far:1 clipping plane
       let nearPoint = SCNVector3(point.x, point.y, 0)
       let farPoint = SCNVector3(point.x, point.y, 1)
       
       // unproject a 2d point at the corner of the screen (0, 0) to z0w and z1w
       
       let z0w = unprojectPoint(nearPoint)
       let z1w = unprojectPoint(farPoint)
       
       // convert point to camera's world space
       
       let z0 = cameraNode.convertPosition(z0w, from: scene!.rootNode)
       let z1 = cameraNode.convertPosition(z1w, from: scene!.rootNode)
       
       // get back 2 points that show a change in y/z and a change in x/z
       
       let opAdY = abs(z1.y - z0.y) / abs(z1.z - z0.z)
       let opAdX = abs(z1.x - z0.x) / abs(z1.z - z0.z)
       
       // atan of opposite / adjacent should provide the half degree of the fov
       // double the halves to get the field of view
       
       let radianX = atan(opAdX) * 2
       let radianY = atan(opAdY) * 2
       
       return (radianX, radianY)
       
       // log the doulbed halves
   }
    
    private var cameraTransform : SCNMatrix4 {
        return self.cameraNode.convertTransform(self.camera.projectionTransform, to: self.scene!.rootNode)
    }
    
    private var camera : SCNCamera {
        get { return cameraNode.camera! }
    }
    
    private var cameraPosition : SCNVector3  {
        return cameraNode.convertPosition(cameraNode.position, to: self.scene!.rootNode)
    }
    
    // project point at the corner of the screen and get the angle 
    // of the projected line as they hypotenuse vs non projected 2d adjacent line
    private var fovRadians : (x: Float, y: Float) {
        return radiansOf(projectedPoint: CGPoint(x:0, y:0))
    }
    
    
    
}



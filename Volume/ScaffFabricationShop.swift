//
//  ScaffFabricationShop.swift
//  ScaffBuilder
//
//  Created by Justin Smith on 7/29/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import Foundation

typealias QMeasure = Measurement<UnitLength>
// if scale == 1/100 then meters are used
// if scale == 1 then centimeters are used
fileprivate let scale = 1/1000.0
fileprivate let scaleF : Float = 1/1000.0
fileprivate let milimetersToMeters = 1/1000.0

struct ScaffHeadFab : Loadable {
    var fileName = "Scaffolding Parts.scn"
    var itemName = "Scaff_Head"
}

struct DiagHeadFab : Loadable {
    var fileName = "Scaffolding Parts.scn"
    var itemName = "Scaff_Head_Diag"
}



class WoodPadMaker : Element3D {
  
  var node : Node
  var position: (x: QMeasure, y: QMeasure, z: QMeasure) = (x:0.0.cm,y:0.0.cm,z:0.0.cm)
  
  static var sharedInstance : Node =
  {
    let box = Box(width: 600.mm, height: 60.mm, length: 400.mm, chamferRadius: 0.0.mm)
    let padNode = MakeNode(withGeometry:box)
    
    var node = padNode
    node.location.y = (-93.5 + -60).mm
    node.location.x = 0.mm// Material comes in a position in the dae file. Must reset
    node.location.z = 0.mm
    return node
  }()
  
  init () // In mm
  {
    self.node = WoodPadMaker.sharedInstance.clone()
  }

  
}

class BCMaker : Element3D {
  struct StdFab : Loadable {
    var fileName : String = "Scaffolding Parts.scn"
    var itemName : String = "Std_bc"
  }
  
  var node : Node
  var position: (x: QMeasure, y: QMeasure, z: QMeasure) = (x:0.0.m,y:0.0.m,z:0.0.m)
  static var sharedInstance : Node =
  {
    var node = StdFab().load()
    node.location.y = (-10.4).cm
    node.location.x = 0.mm// Material comes in a position in the dae file. Must reset
    node.location.z = 0.mm
    
    node.scale = Vector3(x:scaleF, y: scaleF, z: scaleF)
    return node
  }()
  
  init () // In mm
  {
    self.node = BCMaker.sharedInstance.clone()
  }
}

class ScrewJackMaker : Element3D {
  struct JackBaseFab : Loadable {
    
    var fileName : String = "Scaff From Ed.dae"
    var itemName : String = "_3D_Screwjack_Tall"
  }
  
  struct JackNutFab : Loadable {
    
    var fileName : String = "Scaff From Ed.dae"
    var itemName : String = "_3D_Screwjack_Head_Staging-Scaff-x_3D_Blocks"
  }
  
  var node : Node
  var position: (x: QMeasure, y: QMeasure, z: QMeasure) = (x:0.0.m,y:0.0.m,z:0.0.m)
  
  static var sharedInstance : Node = {
    
    var node = JackBaseFab().load()
    node.location.y = (-10.4).cm - (19.44).mm
    node.location.x = 0.mm // Material comes in a position in the dae file. Must reset
    node.location.z = 0.mm
    
    var head = JackNutFab().load()
    node.addChildNode(head)
    head.location.x = 0.mm
    head.location.y = 83.36.m
    head.location.z = 0.mm
    
    
    node.scale = Vector3(x:scaleF, y: scaleF, z: scaleF)
    
    return node
  }()
  
  init () // In mm
  {
    self.node = ScrewJackMaker.sharedInstance.clone()
    
  }
}

class StdMaker  : Element3D {
  struct StdFab : Loadable {
    var fileName : String
    var itemName : String
  }
  
  var position: (x: Measurement<UnitLength>, y: Measurement<UnitLength>, z: Measurement<UnitLength>) = (x:0.0.m,y:0.0.m,z:0.0.m)
  var node : Node
  let size : QMeasure
  
  
  static var sharedInstances : [QMeasure : Node] = [:]
  
  init (size: QMeasure) // In mm
  {
    self.size = size
    
    if StdMaker.sharedInstances[size] == nil {
      let cm = Int(size.converted(to: .centimeters).value)
      node = StdFab(fileName: "Scaffolding Parts.scn", itemName: "Std_\(cm)cm").load()
      node.location.y = 9.5.cm
      node.location.x = 0.mm // Material comes in a position in the dae file. Must reset
      node.location.z = 0.mm
      
      node.scale = Vector3(x: milimetersToMeters, y: milimetersToMeters, z: milimetersToMeters)

      StdMaker.sharedInstances[size] = node
      
    }
    
    node = StdMaker.sharedInstances[size]!.clone()
    
    
  }
}


class DiagMaker : HorizontalElement3D {
    
    struct HeadWrapper {
        let attachmentPoint : (x: QMeasure, y: QMeasure, z: QMeasure) = (x: 35.3553.mm, y: (-5).mm, z: (-69.2965).mm)
        var headSize : QMeasure {
            return attachmentPoint.x
        }
        var node : Node
    
    }
    
    var rotation: Degree  = Degree(0)
    var position: (x: QMeasure, y: QMeasure, z: QMeasure) = (x:0.0.m,y:0.0.m,z:0.0.m)
    
    var run: QMeasure
    var rise: QMeasure
  
  struct RunRise : Hashable {
    var hashValue: Int { return run.hashValue + rise.hashValue}
    
    static func ==(lhs: DiagMaker.RunRise, rhs: DiagMaker.RunRise) -> Bool {
      if lhs.rise == rhs.rise && lhs.run == rhs.run {
        return true
      }
      return false
    }
    
    var run: QMeasure
    var rise: QMeasure
  }
    
  
  // Dictionary Pattern of Items
  static var sharedInstances : [RunRise : Node] = [:]

    
    init (run: QMeasure, rise: QMeasure)
    {
        self.run = run
        self.rise = rise
      
      // prelimnaryirly set until everything is initialized
      self.node = MakeNode()
      
      // Check if shared Instance already exists
      let runRise = RunRise(run: run, rise: rise)
      if DiagMaker.sharedInstances[runRise] == nil {
        
        var ledgerNode = MakeNode()
        
        // create the scaff heads
        var head1 = HeadWrapper(node:DiagHeadFab().load())
        head1.node.scale =  Vector3(x: scaleF, y: scaleF, z: scaleF)
        // create rotate and position the opposite head
        var head2 = HeadWrapper(node:DiagHeadFab().load())
        head2.node.scale =  Vector3(x: scaleF, y: scaleF, z: scaleF)
        head2.node.location.x = run
        head2.node.location.y = rise
        head2.node.flipAlong(.x)
        
        
        
        // create the tube
        func tube(nominalRun: QMeasure, nominalRise: QMeasure ) -> Node {
          let aP1wX = head1.node.location.x + head1.attachmentPoint.x
          let aP1wY = head1.node.location.y + head1.attachmentPoint.y
          let aP2wX = head2.node.location.x - head2.attachmentPoint.x // Head 2 is reversed along x direction
          let aP2wY = head2.node.location.y + head2.attachmentPoint.y
          let rise = aP2wY - aP1wY
          let run = aP2wX - aP1wX
          
          //          var boxNode = MakeNode()
          //          boxNode.addOrientationPoint()
          //          boxNode.location = VectorMeasurement3(x: aP2wX, y: aP2wY, z: 0.0.cm)
          //          self.node.addChildNode(boxNode)
          //
          //          var boxNode2 = MakeNode()
          //          boxNode2.addOrientationPoint()
          //          boxNode2.location = VectorMeasurement3(x: aP1wX, y: aP1wY, z: 0.0.cm)
          //          self.node.addChildNode(boxNode2)
          
          let riseValue = rise.converted(to: UnitLength.meters).value
          let runValue = run.converted(to: UnitLength.meters).value
          
          let hyp = (sqrt( (riseValue * riseValue) + (runValue * runValue))).m
          let geom = Tube(innerRadius: 0.mm, outerRadius: 48.3.mm/2, height: hyp)
          var tubeNode = MakeNode(withGeometry: geom)
          //tubeNode.eulerAngles.z = Degree(90).toRadians
          tubeNode.eulerAngles.z = Float(-atan( runValue/riseValue))
          tubeNode.location.x = run/2 + head1.attachmentPoint.x
          tubeNode.location.y = head1.attachmentPoint.y + rise / 2
          tubeNode.location.z = head1.attachmentPoint.z
          return tubeNode
        }
        let tubeNode = tube(nominalRun: run, nominalRise: rise)
        
        // Create the node to hold them
        
        ledgerNode.addChildNode(head1.node)
        ledgerNode.addChildNode(tubeNode)
        ledgerNode.addChildNode(head2.node)
        
        //ledgerNode.scale = Vector3(x: scaleF, y: scaleF, z: scaleF)
        var node = ledgerNode
        
        DiagMaker.sharedInstances[runRise] = node
        
      }
      
      self.node = DiagMaker.sharedInstances[runRise]!.clone()
      
      
      
      
      
    }
    
    var node : Node
}

class LedgerMaker : HorizontalElement3D {
  
  var size : Measurement<UnitLength>
  var rotation: Degree  = Degree(0)
  var position: (x: Measurement<UnitLength>, y: Measurement<UnitLength>, z: Measurement<UnitLength>) = (x:0.0.cm,y:0.0.cm,z:0.0.cm)
  
  struct HeadWrapper {
    let attachmentPoint : (x: Measurement<UnitLength>, y: Measurement<UnitLength>) = (x: 74.003.mm, y: (-06.51044).mm)
    var headSize : Measurement<UnitLength> {
      return attachmentPoint.x
    }
    var node : Node
  }
  
  static var sharedInstances : [QMeasure : Node] = [:]

  
  init (size: Measurement<UnitLength>) // In cm
  {
    self.size = size.converted(to: .meters)
    
    
    if LedgerMaker.sharedInstances[size] == nil {
      
      
    // create the scaff heads
    var headNode = ScaffHeadFab().load()
    // Scale down the sizes from the cad model
    headNode.scale = Vector3(x: scale, y: scale, z: scale)
    
    var head1 : HeadWrapper
    var head2 : HeadWrapper
    head1 = HeadWrapper(node:headNode.clone())
    // create rotate and position the opposite head
    head2 = HeadWrapper(node:headNode.clone())
    //head2.node.location.x = size
    head2.node.location = VectorMeasurement3(x: size, y: 0.m, z: 0.m)
    head2.node.eulerAngles.y = Degree(180).toRadians
    
    //Calculate the distance betweent the tubes
    let p1 = head1.node.location.x + head1.attachmentPoint.x
    let p2 = head2.node.location.x - head2.attachmentPoint.x
    
    let distance =  p2 - p1
    
    // Create the tube
    let tube = Tube(innerRadius: 0.mm, outerRadius: (48.3.mm/2.0), height: distance)
    var tubeNode = MakeNode(withGeometry:tube)
    tubeNode.eulerAngles.z = Degree(90).toRadians
    tubeNode.location.x += (size/2)
    tubeNode.location.y = head1.attachmentPoint.y
    
    // Create the node to hold them
    let ledgerNode = MakeNode()
    ledgerNode.addChildNode(head1.node)
    ledgerNode.addChildNode(tubeNode)
    ledgerNode.addChildNode(head2.node)
      
      LedgerMaker.sharedInstances[size]  = ledgerNode
    }
    
    self.node = LedgerMaker.sharedInstances[size]!.clone()
  }
  
  let node : Node
}


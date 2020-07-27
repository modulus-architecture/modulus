//
//  ARScnViewController.swift
//  Deploy
//
//  Created by Justin Smith on 7/2/17.
//  Copyright © 2017 Justin Smith. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import ComposableArchitecture

public struct ARProviderState : Equatable {
  public var scaff: [ScaffMember]
   public init(scaff: [ScaffMember] ){
      self.scaff = scaff
   }
}


public class ARScnViewController : UIViewController, Context, SCNContentContext, SCNBounder, ARSCNViewDelegate // add child node content
{
  let store : Store<ARProviderState, Never>
   let viewStore : ViewStore<ARProviderState, Never>


  var contentNode: SCNNode
  
  var sceneView : SCNView { return self.arView }
  
  fileprivate var arView: ARSCNView!
  private var productionShop : ProductionShop?
  
  // State representation
  private enum UpdatingStatus {
    case needsUpdate
    case updated
  }
  private var status : UpdatingStatus
  private lazy var activity : UIActivityIndicatorView = {
    var anAct = UIActivityIndicatorView(style: .gray)
    anAct.translatesAutoresizingMaskIntoConstraints = false
    anAct.startAnimating()
    return anAct
  }()
  
  
  public init(store: Store<ARProviderState, Never>)
  {
    self.store = store
   self.viewStore = ViewStore(self.store)
    self.status = .needsUpdate
    self.contentNode = SCNNode()
    super.init(nibName:nil, bundle:nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    
    arView = ARSCNView(frame: view.frame)
    arView.scene.rootNode.addChildNode(self.contentNode)
    
    arView.autoenablesDefaultLighting = true
    arView.automaticallyUpdatesLighting = true
    
    
    // Set the view's delegate
    arView.delegate = self
    
    // Show statistics such as fps and timing information
    arView.showsStatistics = true
    
    view.addSubview(arView)
    arView.translatesAutoresizingMaskIntoConstraints = false
    arView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    arView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    arView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    arView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    
    self.productionShop = ProductionShop(grid: self.viewStore.scaff, site: self) // Builds scene
    
    arView.pointOfView?.camera?.zFar = 2000
    
    let mat = SCNMaterial()
    mat.lightingModel = SCNMaterial.LightingModel.physicallyBased
    mat.diffuse.intensity = 0.1
    mat.roughness.intensity = 1.0
    mat.metalness.intensity = 0.66
    
//    mat.diffuse.contents = UIImage(named: "streakedmetal-albedo")
//    mat.roughness.contents = UIImage(named: "streakedmetal-roughness")
//    mat.metalness.contents = UIImage(named: "streakedmetal-metalness")
    
    let matDouble = mat.copy() as! SCNMaterial
    matDouble.isDoubleSided = true
    
    self.contentNode.enumerateChildNodes {
      (node, pointer) in
      let isDoubled = node.geometry?.firstMaterial?.isDoubleSided ?? false
      node.geometry?.firstMaterial = isDoubled ? matDouble : mat
    }
    
    let scale = 1.0
    self.contentNode.scale = SCNVector3(x: 1.0/scale, y: 1.0/scale, z: 1.0/scale)
    
    
  }
  
  
  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //  .needsUpdate  precusoor computationally expensive add activity view
    if status == .needsUpdate {
      
      view.addSubview(activity)
      activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      activity.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
      
    }
  }
  
  
  
  override public func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    //  .needsUpdate  computationally expensive add activity view
    
    //    computationally expensive
    if status == .needsUpdate {
      self.activity.removeFromSuperview()
      // Production Shop holds sets up scene (which it holds as a variable)
      productionShop?.grid = self.viewStore.scaff
      status = .updated
    }
    
    print("VIEW DID APPEAR")
    
    let config = ARWorldTrackingConfiguration()
    //config.environmentTexturing = .automatic

    arView.session.run(config )
  }
  
  override public func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    arView.session.pause()
  }
  
  
  
  
  
  func removeAll() {
    self.removeContent()
  }
  func remove(elements: [Element3D]) {
    for n in elements {
      n.node.removeFromParentNode()
    }
  }
  func add(node: Node) {
    self.addContent(node: node as! SCNNode)
  }
  
  func add(nodes: [Node]) {
    for n in nodes {
      self.addContent(node: n as! SCNNode)
    }
  }
  func add(elements: [Element3D]) {
    for n in elements {
      self.addContent(node: n.processedNode as! SCNNode)
    }
  }
  
  
  
  
  
  
  public func session(_ session: ARSession, didFailWithError error: Error) {
    // Present an error message to the user
    print("session(_ session: ARSession, didFailWithError error: \(error.localizedDescription)")
  }
  
  public func sessionWasInterrupted(_ session: ARSession) {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    print("sessionWasInterrupted(_ session: ARSession) ")
  }
  
  public func sessionInterruptionEnded(_ session: ARSession) {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    print("sessionInterruptionEnded(_ session: ARSession)")
    
  }
  
  
}



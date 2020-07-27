//
//  ScnController.swift
//  ScnTesting
//
//  Created by Justin Smith on 6/16/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//
//
//  SceneKitViewController.swift
//  Scaffolding
//
//  Created by Justin Smith on 3/1/15.
//  Copyright (c) 2015 Justin Smith. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ComposableArchitecture

private var myContext = 0

// MARK: Camera Views
public enum CameraView {
   case top
   case bottom
   case front
   case back
   case leftSide
   case rightSide
   case custom
}

public struct SCNProviderState : Equatable{
   var scaff: [ScaffMember]
  var view : CameraView
  public init(scaff: [ScaffMember], view:CameraView = .front) {
    self.scaff = scaff
    self.view = view
  }
}


// Three things this Controller Does
// UI, Views, Box

public class CADViewController : UIViewController, UIPopoverPresentationControllerDelegate {
  let store : Store<SCNProviderState, Never>
   let viewStore : ViewStore<SCNProviderState, Never>

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
  
  private var productionShop : ProductionShop?
  
  public init(store: Store<SCNProviderState, Never>)
  {
    self.store = store
   self.viewStore = ViewStore(self.store)
    self.status = .needsUpdate
    super.init(nibName:nil, bundle:nil)
  }
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  fileprivate var scnView: CADView!
  
  private var segmentedViewControl = UISegmentedControl(items: ["Top", "Bottom", "Front", "Right", "Back", "Left"])
  private var orthoControl = UISegmentedControl(items:["Perspective", "Ortho"])
    
    // MARK: - Navigation
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    //  .needsUpdate  precusoor computationally expensive add activity view
    if status == .needsUpdate {
      view.addSubview(activity)
      activity.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      activity.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    //  .needsUpdate  computationally expensive add activity view

//    computationally expensive
    if status == .needsUpdate {
      self.activity.removeFromSuperview()
      // Production Shop holds sets up scene (which it holds as a variable)
      productionShop?.grid = viewStore.scaff
      status = .updated
    }
    
  }
   public override func viewDidLoad() {
        super.viewDidLoad()
        
      scnView = CADView(frame: view.frame, view: viewStore.view)
        view.addSubview(scnView)
        scnView.translatesAutoresizingMaskIntoConstraints = false
        scnView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scnView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scnView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scnView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      
        self.productionShop = ProductionShop(grid: viewStore.scaff, site: self.scnView) // Builds scene
        
        segmentedViewControl.addTarget(self, action: #selector(CADViewController.segmentedControlChanged(_:)), for: UIControl.Event.valueChanged)
        segmentedViewControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedViewControl)
       
        let margins = view.layoutMarginsGuide
        segmentedViewControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        segmentedViewControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        segmentedViewControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
      orthoControl.addTarget(self, action: #selector(CADViewController.perspControlChanged(_:)), for: UIControl.Event.valueChanged)
        orthoControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(orthoControl)
      orthoControl.addTarget(self, action: #selector(CADViewController.perspControlChanged(_:)), for: UIControl.Event.valueChanged)
        
    
        
        //zoomExtents.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        orthoControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        orthoControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        orthoControl.bottomAnchor.constraint(equalTo: segmentedViewControl.topAnchor, constant: -8).isActive = true
    }
    
    
  
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    
    @IBAction func zoomExtents(_ sender: UIButton) {
        
        scnView.showsZoomFrame = true
        scnView.zoomExtents()
        
        updateObservers()
    }
    
    @objc func perspControlChanged(_ sender: UISegmentedControl) {
        
        let title = sender.titleForSegment( at: sender.selectedSegmentIndex)!
        
        switch title {
        case "Perspective" :
            scnView.orthographic = false
            break
        default:
            scnView.orthographic = true
        }
    }

    // MARK: - Camera Stuff
    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        let text = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        
        switch text
        {
        case "Top":
            scnView.currentView = .top
        
        case "Bottom":
            scnView.currentView = .bottom
            break
        case "Front":
            scnView.currentView = .front
            break
        case "Back":
            scnView.currentView = .back
            break
        case "Left":
            scnView.currentView = .leftSide
            break
        case "Right":
            scnView.currentView = .rightSide
            break
        default:
            scnView.currentView = .custom
            break;
        }
        
        updateObservers()
    }
    
    var cameraObservers : [CameraObserver] = []
  
  
}


// Could be a camera struct that is updated

extension CADViewController : CameraOwner
{
    var camera: Camera {
      
        set (newCamera) {
            scnView.camera = newCamera
            
            updateObservers()
        }
        get {
            return scnView.camera
        }
    }
    
    fileprivate func updateObservers()
    {
        for obs in cameraObservers {
            obs.owner(self, didChange: self.camera)
        }
    }
    
    func addObserver (observer: CameraObserver) {
        cameraObservers.append(observer)
    }
    
    
}

protocol CameraDelegate {
    func didChange ()
}

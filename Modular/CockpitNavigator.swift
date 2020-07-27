//
//  GraphNavigator.swift
//  Modular
//
//  Created by Justin Smith on 8/22/18.
//  Copyright © 2018 Justin Smith. All rights reserved.
//

import Foundation
import GrapheNaked
import Singalong
import Volume
@testable import FormsCopy
import Interface
import ComposableArchitecture


/// Cockpit is view and heads up display. Like a cockpit in a plane
/// Cockpit reducer stack. Cockpit is  the state and view that holds menu and tool bars above the level of individual 2D screen view of the graph, and is responsible for bringing the 2D graph and presenting the 3D and AR views
public struct CockpitState : Equatable {
  var quad : QuadState<ScaffGraph>
  var item : Item<ScaffGraph>
}

extension CockpitState {
   var arProvider : ARProviderState { ARProviderState(scaff: self.item.content |> members )}
   var scnProvider : SCNProviderState { SCNProviderState(scaff: self.item.content |> members,
                                                         view: quad.pageState.currentQuadrant |> cameraView)
   }
}

private func cameraView(from quadrant:PageState.Quadrant) -> CameraView {
   switch quadrant {
   case .topLeft: return .top
   case .topRight: return .top
   case .bottomLeft: return .front
   case .bottomRight: return .leftSide
   }
}

public enum CockpitAction {
  case quad(QuadAction<ScaffGraph>)
}

public struct CockpitEnvironment {
   
}

public let cockpitReducer = Reducer<CockpitState, CockpitAction, CockpitEnvironment>.combine(
   quadReducer().pullback(state: \CockpitState.quad, action: /CockpitAction.quad, environment: { appEnv in QuadEnvironment() }),
   Reducer{
      (state, action, env) in
    
    switch action {
    case .quad(.front),
         .quad(.side),
         .quad(.plan),
         .quad(.rotated):
        state.item.content = state.quad.planState.spriteState.graph
        return .none
    case .quad(.page): return .none
    }
      return .none
})

public class CockpitNavigator {
  public init(store: Store<CockpitState, CockpitAction> ) {
    self.store = store
   self.quadStore = store.scope(state: {$0.quad}, action: { .quad($0) })
    let storeOne = quadStore.scope(state: {$0.planState}, action: { .plan($0) })
    let one = tentVC(store: storeOne, title: "Top")
    let store2 = quadStore.scope(state: {$0.rotatedPlanState}, action: { .rotated($0) })
    let two = tentVC(store: store2, title: "Rotated Plan")
    let store3 = quadStore.scope(state: {$0.frontState}, action: { .front($0) })
    let three = tentVC( store: store3, title: "Front")
    let store4 = quadStore.scope(state: {$0.sideState}, action: { .side($0) })
    let four =  tentVC(store: store4, title: "Side")
    driver = QuadDriverCA(store: quadStore.scope(state: {$0.pageState}, action: { .page($0) }), upper: [one, two], lower: [three, four])
    driver.group  |> self.addNavBarItem
  }
  private var driver : QuadDriverCA
  public let store : Store<CockpitState, CockpitAction>
  public let quadStore :  Store<QuadState<ScaffGraph>, QuadAction<ScaffGraph>>
  
  lazy var vc: UIViewController = driver.group
  
  func addNavBarItem(vc :UIViewController ) {
    vc.navigationItem.rightBarButtonItems = [
      UIBarButtonItem(title: "AR", style: UIBarButtonItem.Style.plain , target: self, action: #selector(CockpitNavigator.presentAR)),
      UIBarButtonItem(title: "3D", style: UIBarButtonItem.Style.plain , target: self, action: #selector(CockpitNavigator.present3D)),
      UIBarButtonItem(title: "Info", style: UIBarButtonItem.Style.plain , target: self, action: #selector(CockpitNavigator.presentInfo)),
    ]
  }
  
//  @objc func save() {
//    store.send(.interfaceAction(.saveData))
//  }
  
  @objc func presentInfo() {
   let viewStore = ViewStore(self.store)
   let cell = viewStore.item
    let driver = FormDriver(initial: cell, build: colorsForm)
    driver.formViewController.navigationItem.largeTitleDisplayMode = .never
    driver.didUpdate = { _ in
      //self.store.send(.addOrReplace($0))
      //self.store.send(.interfaceAction(.saveData))
    }
    let nav = embedInNav(driver.formViewController)
    nav.navigationBar.prefersLargeTitles = false
    driver.formViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Dismiss",
      style: UIBarButtonItem.Style.plain ,
      target: self,
      action: #selector(CockpitNavigator.dismiss3D)
    )
    self.vc.present(nav, animated: true, completion: nil)
  }
  
  @objc func present3D() {
//    if let item = self.store.value.items.getItem(id: id) {
//      self.store.send(.addOrReplace(item))
//    }
   let newVC = CADViewController(store: self.store.scope(state: { $0.scnProvider }, action: { _ in fatalError()}))
    
    let ulN = UINavigationController(rootViewController: newVC)
    ulN.navigationBar.prefersLargeTitles = false
    newVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Dismiss",
      style: UIBarButtonItem.Style.plain ,
      target: self,
      action: #selector(CockpitNavigator.dismiss3D)
    )
    
    self.vc.present(ulN, animated: true, completion: nil)
  }
  
  @objc func presentAR() {
//    if let item = self.store.value.items.getItem(id: id) {
//      self.store.send(.addOrReplace(item))
//    }
   let cadController = ARScnViewController(store: self.store.scope(state: { $0.arProvider }, action: { _ in fatalError() }))
    
    let ulN = UINavigationController(rootViewController: cadController)
    ulN.navigationBar.prefersLargeTitles = false
    cadController.navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Dismiss",
      style: UIBarButtonItem.Style.plain ,
      target: self,
      action: #selector(CockpitNavigator.dismiss3D)
    )
    
    
    self.vc.present(ulN, animated: true, completion: nil)
  }
  
  
  
  @objc func dismiss3D() {
    self.vc.dismiss(animated: true, completion: nil)
  }
  
   // *** TODO Doesn't work yet with composable ****
   func saveSnapshot(view: UIView) {
     // Save Image to Cache...

     let img = image(with:view)!
     //let img = image(with:self.view)!
     let newSize = CGSize(width: view.bounds.width,  height: view.bounds.height)
     
     DispatchQueue.global(qos: .background).async {
       let cropped = cropToBounds(image: img, width: newSize.width, height:newSize
         .height)
       
       //self.store.send(.thumbnailsAddToCache(cropped, id: self.store.value.spriteState.graph.id))
       
       }
     // ...End Save Image
   }
  
  
}


//
//  GraphNavigator.swift
//  Modular
//
//  Created by Justin Smith on 8/22/18.
//  Copyright © 2018 Justin Smith. All rights reserved.
//

import Foundation
import Graphe
import Singalong
import Volume
@testable import FormsCopy



public class GraphNavigator {
  init(id: String) {
    self.id = id
  }
  
  var graph : ScaffGraph {
    get {
      let simple = Current.model.getItem(id: id)!.content
      return ScaffGraph(grid: simple.positions , edges: simple.edges)
    }
  }
  
  
  var scale : CGFloat = 1.0 {
    didSet {
      postNotification(note: scaleChangeNotification, value: scale)
    }
  }
  
  lazy var vc: UIViewController = quadVC
  typealias ViewMap = EditingViews.ViewMap
  
  lazy var mock : UIViewController =
    Current.viewMaps.front
      |>  curry(mockControllerFromMap)(self)
      >>> addNavBarItem
  lazy var mockInternalNav : UIViewController =
    Current.viewMaps.front
      |> curry(mockControllerFromMap)(self)
      >>> embedInNav
      >>> inToOut(styleNav)
      >>> addNavBarItem
  lazy var quadDriver : QuadDriver =
    { ($0, self.graph) }
      >>> curry(controllerFromMap)(self)
      >>> inToOut(addBarSafely)
      |> createPageController
  lazy var quadVC : UIViewController = quadDriver.group |> addNavBarItem
  lazy var quadNavs : QuadDriver  =
    { ($0, self.graph) }
      >>> curry(controllerFromMap)(self)
      >>> inToOut(addBarSafely)
      >>> embedInNav
      >>> inToOut(styleNav)
      |> createPageController
  
  func addNavBarItem<ReturnVC:UIViewController>(vc :ReturnVC ) -> ReturnVC {
    vc.navigationItem.rightBarButtonItems = [
      UIBarButtonItem(title: "3D", style: UIBarButtonItem.Style.plain , target: self, action: #selector(GraphNavigator.present3D)),
      UIBarButtonItem(title: "Info", style: UIBarButtonItem.Style.plain , target: self, action: #selector(GraphNavigator.presentInfo)),
    ]
    
    return vc
  }
  
  @objc func save() {
    Current.file.save(Current.model)
  }
  
  @objc func presentInfo() {
    let cell = Current.model.getItem(id: self.id)!
    //let simpleItem = SimpleGraphItem(name: cell.name, graph: cell.content)
    var simple = cell
    let driver = FormDriver(initial: simple, build: colorsForm)
    driver.formViewController.navigationItem.largeTitleDisplayMode = .never
    let nav = embedInNav(driver.formViewController)
    nav.navigationBar.prefersLargeTitles = false
    driver.formViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Dismiss",
      style: UIBarButtonItem.Style.plain ,
      target: self,
      action: #selector(GraphNavigator.dismiss3D)
    )
    self.vc.present(nav, animated: true, completion: nil)
  }
  
  let id : String
  @objc func present3D() {
    
    if let item = Current.model.getItem(id: id) {
      Current.model.addOrReplace(item: item )
    }
    
    let scaffProvider = Current.model.getItem(id: id)!.content |> ScaffGraph.init |> provider
    let newVC = CADViewController(grid: scaffProvider)
    
    let ulN = UINavigationController(rootViewController: newVC)
    ulN.navigationBar.prefersLargeTitles = false
    newVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Dismiss",
      style: UIBarButtonItem.Style.plain ,
      target: self,
      action: #selector(GraphNavigator.dismiss3D)
    )
    
    
    self.vc.present(ulN, animated: true, completion: nil)
  }
  
  
  
  @objc func dismiss3D() {
    self.vc.dismiss(animated: true, completion: nil)
  }
  
  
  
}


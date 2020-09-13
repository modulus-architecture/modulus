//
//  App.swift
//  HandlesRound1
//
//  Created by Justin Smith on 3/27/18.
//  Copyright © 2018 Justin Smith. All rights reserved.
//

import UIKit
import Singalong
import GrapheNaked
@testable import FormsCopy




extension ScaffGraph {
  var width : Measurement<UnitLength> {
    return (grid.pX.max()! |> Double.init, .centimeters) |> Measurement<UnitLength>.init(value:unit:)
  }
  var depth : Measurement<UnitLength> {
    return (grid.pY.max()! |> Double.init, .centimeters) |> Measurement<UnitLength>.init(value:unit:)
  }
  var height : Measurement<UnitLength> {
    return (grid.pZ.max()! |> Double.init, .centimeters) |> Measurement<UnitLength>.init(value:unit:)
  }
  var ledgers : Int {
    return edges.filtered(by: isLedger).count
  }
  var diags : Int {
    return edges.filtered(by: isDiag).count
  }
  var collars : Int {
    return edges.filtered(by: isPoint).count
  }
  var standards : Int {
    return edges.filtered(by: isVertical).count
  }
}




final class Cell : UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

func createCell(anItem:Item<ScaffGraph> , cell: Cell) -> Cell {
    if let fileName = anItem.thumbnailFileName {
      switch Current.thumbnails.imageFromCacheName(fileName) {
      case let .success(img):
        cell.imageView?.image = img
        cell.imageView?.frame = CGRect(x: -30, y: 0, width: 106, height: 106)
      default:
        break
      }
    }
  
  cell.textLabel?.text = anItem.name
  //let formatter = anItem.sizePreferences.mostlyMetric ? metricFormatter : imperialFormatter
  let formatter =  imperialFormatter
  cell.detailTextLabel?.text = "\(anItem.content.width |> formatter) x \(anItem.content.depth |> formatter) x \(anItem.content.height |> formatter)"
  cell.accessoryType = .detailDisclosureButton
  return cell
  }

import ComposableArchitecture
import Interface



struct AppState: Equatable {
 // var items : ItemList<ScaffGraph>
  var todos: IdentifiedArrayOf<Item<ScaffGraph>>
}


enum AppAction {
  // case itemSelected(Item<ScaffGraph>)
  
  case addOrReplace(Item<ScaffGraph>)
  
  case setItems(IdentifiedArrayOf<Item<ScaffGraph>>)
    
  case todo(id: UUID, action: StructureListAction)

}

struct AppEnvironment {
   
}


let appReducer =  Reducer<AppState, AppAction, AppEnvironment>
   .combine(
      Reducer{ (state: inout AppState, action: AppAction, env: AppEnvironment) -> Effect<AppAction, Never> in
    switch action {
//      case let .itemSelected(item):
//
//        let sizePref = item.baySet.map{ item.baySizes[$0] }.map{ $0.centimeters }
//
//        state.quadState = CockpitState(quad:QuadScaffState(graph: item.content,
//                                                          size: Current.screen.size,
//                                                          sizePreferences: sizePref),
//                                       item: item.content)
//        return .none
      case let .addOrReplace(item):
        state.todos.addOrReplace(item: item)
        return .none
        
      case let .setItems(itemList):
        state.todos = itemList
        return .none
              
    case .todo(id: let id, action: let action):
      return .none
        }
    },
      structureListReducer.forEach(
      state: \AppState.todos,
      action: /AppAction.todo(id:action:),
      environment: { _ in StructureListEnvironment() }
    )
)


import SwiftUI

public struct AppView : View {
  
  var store: Store<AppState,AppAction>
      
  public var body: some View {
    WithViewStore (self.store) { viewStore in
            ZStack{
              NavigationView{
                List{
                  ForEachStore( self.store.scope(state: { $0.todos }, action: AppAction.todo(id:action:)), content: StructureListView.init(store:))
                      
                  //.onDelete { viewStore.send(.delete($0)) }
                  //.onMove { viewStore.send(.move($0, $1)) }

                  
                  
                }
                .navigationBarItems(
                  trailing: HStack(spacing: 20) {
                    EditButton()
                  }
                )
                  .navigationBarTitle("Modulus")
                  .navigationViewStyle(StackNavigationViewStyle())
              }
                
              VStack{
                Spacer()
                HStack {
                  Spacer()
                Button(action:{}) {
                    ZStack{
                      Circle()
                        .fill(Color.blue)
                        .frame(width: 44, height: 44.0)
                      Image(systemName: "plus")
                        .frame(width: 44, height: 44.0)
                        .colorInvert()
                        .accentColor(.black)
                    }
                  .frame(width: 44, height: 44.0)
                  
                }
                }
              }
              .padding([.bottom, .trailing])
              
              
            
            }
        }

    }
  }

 struct ContentView_Previews: PreviewProvider {
      static var previews: some View {
        AppView(store: Store(initialState: AppState(todos: IdentifiedArrayOf([])),
                             reducer: appReducer.debug(), environment: AppEnvironment())
        )
      }
  }


public class App {
  var store: Store<AppState,AppAction> = Store(initialState: AppState(todos: IdentifiedArrayOf([])),
                                               reducer: appReducer.debug(), environment: AppEnvironment())
  lazy var viewStore: ViewStore<AppState,AppAction> = {
     ViewStore(store)
  }()
  
  public init() {
  }
  
  public lazy var rootController: UIViewController = loadEntryTable
  
  
  var editViewController : EditViewController<Item<ScaffGraph>, Cell>?
  var inputTextField : UITextField?
  
  lazy var loadEntryTable : UIViewController  = {
    let load = Current.file.load()
    
    switch load {
    case let .success(value):
      self.viewStore.send(.setItems( IdentifiedArrayOf(value) ))
    case let .error(error):
       self.viewStore.send(.setItems( IdentifiedArrayOf(ScaffGraph.mockList) ))
    }
            
    /*
    
    
    let edit = EditViewController(
      config: EditViewContConfiguration( initialValue: viewStore.items.contents, configure: createCell)
    )
    edit.willAppear = {
      let a = self.viewStore.items.contents
      edit.undoHistory.currentValue = self.viewStore.items.contents
    }
    edit.tableView.rowHeight = 88
    edit.didSelect = { (item, cell) in
      self.viewStore.send(.itemSelected(cell))
      self.currentNavigator = CockpitNavigator(store: self.store.scope(state: {$0.quadState!}, action: { .interfaceAction($0) }))
      self.loadEntryTable.pushViewController(self.currentNavigator.vc, animated: true)
    }
    edit.didSelectAccessory = { (_, item) in
      

      let view = ScaffInfoForm(store: self.store.scope(state: { $0.todos }, action: AppAction.scaffInfo(id:action:))),
          
//          Store(
//            initialState: ScaffInfoState(name: item.name,
//                                          ledgers: item.content.ledgers,
//                                          diags: item.content.diags,
//                                          base: item.content.collars,
//                                          stds: item.content.standards,
//                                          length: item.content.width,
//                                          depth: item.content.depth,
//                                          height: item.content.height,
//                                          baySizes: [25.0, 50, 100, 150, 175, 200, 250, 300],
//                                          baySet: [3,5]),
//            reducer: scaffInfoReducer,
//            environment: ScaffInfoEnvironment())
        )
      
      
        
        let vc = UIHostingController(rootView: view)

      
      self.loadEntryTable.pushViewController(vc, animated: true)

      /*
      let driver = FormDriver(initial: cell, build: colorsForm)
      driver.formViewController.navigationItem.largeTitleDisplayMode = .never
        driver.didUpdate = {
          self.viewStore.send(.addOrReplace($0))
          //Current.model.addOrReplace(item: $0)
        }
        self.loadEntryTable.pushViewController(driver.formViewController, animated: true)
        */
      }
    edit.topRightBarButton = BarButtonConfiguration(type: .system(.add)) {
      func addTextField(_ textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Definition"
        self.inputTextField = textField
      }
      
      let listNamePrompt = UIAlertController(title: "Name This Structure", message: nil, preferredStyle: UIAlertController.Style.alert)
      listNamePrompt.addTextField(configurationHandler: addTextField)
      listNamePrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: ({ (ui:UIAlertAction) -> Void in
        
      })))
      listNamePrompt.addAction(UIAlertAction(title: "Create", style: UIAlertAction.Style.default, handler: ({ (ui:UIAlertAction) -> Void in
        let text = self.inputTextField?.text ?? "Default"
        var new : Item<ScaffGraph> = Item(
          content: (Item.template.map{ s in CGFloat( s.length.converted(to:.centimeters).value) }, (200,200,200) |> CGSize3.init) |> createScaffoldingFrom,
          name: text)
        new.content.id = text
        self.viewStore.send(.addOrReplace(new))
        // self.store.send(.interfaceAction(.saveData))
         edit.undoHistory.currentValue = self.viewStore.items.contents
      })))
 
    
      
      self.rootController.present(listNamePrompt, animated: true, completion: nil)
    }
    edit.title = "Morpho"
    // Moditive
    // Formosis // Formicate, Formite, Formate, Form Morph, UnitForm, Formunit
    // Morpho, massing, Meccano, mechanized, modulus, Moduform, Modju, Mojuform, Majuform
    // Modulo
    self.editViewController = edit
    let nav = UINavigationController(rootViewController: edit)
    styleNav(nav)
    return nav
  */
    
    
    let view = AppView(store: self.store)
    
    let vc = UIHostingController(rootView: view)
    
    return vc
    
  }()
  
  var currentNavigator : CockpitNavigator!
}







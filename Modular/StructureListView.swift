//
//  SwiftUIView.swift
//  Modular
//
//  Created by Justin Smith on 9/5/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct Item<Content:Equatable> : Equatable, Identifiable {
  var content: Content
  let id: UUID = UUID()
  var name: String
  var baySizes : [ScaffoldingGridSizes]
  var baySet : Set<Int>
  var isEnabled: Bool = true
  var thumbnailFileName : String?
  var quadState : CockpitState?
  var presenting = false
}

extension Set where Element == ScaffoldingGridSizes {
  var mostlyMetric : Bool {
    let metricItems = self.filter({ (size) -> Bool in
      return ScaffoldingGridSizes.eventMetric.contains(size)
    })
    let impItems = self.filter({ (size) -> Bool in
      return ScaffoldingGridSizes.us.contains(size)
    })
    return metricItems.count >= impItems.count
  }
  var toCentimeterFloats : [CGFloat] {
    self.map{CGFloat($0.length.converted(to: .centimeters).value)}
  }
}

extension Item where Content == ScaffGraph {
  static var template : [ScaffoldingGridSizes] {  get { return [ScaffoldingGridSizes._50, ScaffoldingGridSizes._150] } }
}

/// Seemingly Default initializer
/// Unfortnately hardcoded to Scaffold
extension Item {
  init(content: Content, name: String) {
    self.init(content: content, name: name, baySizes: ScaffoldingGridSizes.eventMetric, baySet: [0,1,2,3,4], isEnabled: true, thumbnailFileName: nil)
  }
}

extension Set where Element == ScaffoldingGridSizes {
  var text : String {
    let values = self.map{$0.length.value}.sorted().map{String($0)}
    return values.dropFirst().reduce(values.first ?? "None") {
      return $0 + ", " + $1
    }
  }
}

extension Item : Codable where Content : Codable  {
    enum CodingKeys: CodingKey {
      case content
      case name
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(content, forKey: .content)
      try container.encode(content, forKey: .name)
    }
  
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let content = try container.decode(Content.self, forKey: .content)
      let name = try container.decode(String.self, forKey: .name)

      self.init(content: content, name: name)
  }
}

extension Item where Content == ScaffGraph {
  var scaffInfo : ScaffInfoState {
    get {
      ScaffInfoState(name: self.name,
                     ledgers: self.content.ledgers,
                     diags: self.content.diags,
                     base: self.content.collars,
                     stds: self.content.standards,
                     length: self.content.width,
                     depth: self.content.depth,
                     height: self.content.height,
                     baySizes: self.baySizes,
                     baySet: self.baySet)
  }
  set {
    self.name = newValue.name
    self.baySizes = newValue.baySizes
    self.baySet = newValue.baySet
  }
}
}




typealias ScaffItem = Item<ScaffGraph>



enum StructureListAction {
  case info(ScaffInfoAction)
  case interfaceAction(CockpitAction)
  case cellTapped
  case setSheet(isPresented: Bool)
}

struct StructureListEnvironment {
}

let structureListReducer = Reducer <Item<ScaffGraph>, StructureListAction, StructureListEnvironment>.combine(
  cockpitReducer.pullback(state: \.quadState!, action: /StructureListAction.interfaceAction, environment: { appEnv in CockpitEnvironment() }),
  Reducer{ state, action, env in
    switch action {
    case .setSheet(isPresented: true):
      let sizePref = state.baySet.map{ state.baySizes[$0] }.map{ $0.centimeters }
      state.quadState = CockpitState(quad:
        QuadScaffState(graph: state.content,
                       size: Current.screen.size,
                       sizePreferences: sizePref),
                                     item: state.content)
      state.presenting = true
      return .none

    case .setSheet(isPresented: false):
      state.presenting = false
        return .none
      

    case .cellTapped:
      let sizePref = state.baySet.map{ state.baySizes[$0] }.map{ $0.centimeters }
      state.quadState = CockpitState(quad:
        QuadScaffState(graph: state.content,
                       size: Current.screen.size,
                       sizePreferences: sizePref),
                                     item: state.content)
      state.presenting = true
      return .none
    case .info(_):
      return .none
    case .interfaceAction(_):
      return .none
    }
}, scaffInfoReducer.pullback(
  state: \Item.scaffInfo,
  action: /StructureListAction.info,
  environment: { _ in ScaffInfoEnvironment() }
  )
)




struct StructureListView: View {
  var store: Store<Item<ScaffGraph>, StructureListAction>
  
  var body: some View {
//    WithViewStore(self.store) { viewStore in
//      Button(action: { viewStore.send(.cellTapped) }){
//        HStack{
//          HStack(alignment: .center) {
//            Rectangle()
//              .frame(width: 100.0, height: 100)
//              .cornerRadius(/*@START_MENU_TOKEN@*/9.0/*@END_MENU_TOKEN@*/)
//            VStack(alignment: .leading) {
//              Text("Four By Eight")
//              Text("10m x 10m") // anItem.sizePreferences.mostlyMetric
//                .font(.footnote) // Spacer()
//              Text("Scaffolding Structure")
//                .font(.footnote)
//                .foregroundColor(Color.gray)
//            }
//          }
//        }
//        Spacer()
//        Button(action: {}) {
//          ZStack{
//            Circle()
//              .stroke(lineWidth: 1.5)
//              .padding(.top, 2.0)
//              .frame(width: 24.0)
//            Image(systemName: "info")
//          }
//        }
//        .foregroundColor(Color.gray)
//
//
//    }
//      .sheet(isPresented: viewStore.binding(
//        get: { $0.presenting },
//        send: StructureListAction.setSheet(isPresented:)
//       ))
//      {
//        CockpitUIView(store: self.store)
//      }
//    }
    WithViewStore(self.store) { viewStore in
      NavigationLink(destination:
        CockpitUIView(store: self.store)
      , isActive: viewStore.binding(
          get: { $0.presenting },
          send: StructureListAction.setSheet(isPresented:)
          )
        )
      {
        HStack{
          HStack(alignment: .center) {
            Rectangle()
              .frame(width: 100.0, height: 100)
              .cornerRadius(/*@START_MENU_TOKEN@*/9.0/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading) {
              Text("Four By Eight")
              Text("10m x 10m") // anItem.sizePreferences.mostlyMetric
                .font(.footnote) // Spacer()
              Text("Scaffolding Structure")
                .font(.footnote)
                .foregroundColor(Color.gray)
            }
          }
        }
        Spacer()
        Button(action: {}) {
          ZStack{
            Circle()
              .stroke(lineWidth: 1.5)
              .padding(.top, 2.0)
              .frame(width: 24.0)
            Image(systemName: "info")
          }
        }
        .foregroundColor(Color.gray)


    }
      
      
    }

  }
}


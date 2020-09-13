//
//  ScaffInfoForm.swift
//  Modular
//
//  Created by Justin Smith Nussli on 8/4/20.
//  Copyright © 2020 Justin Smith. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Singalong


struct ScaffInfoState : Equatable {
   var name : String
   var ledgers : Int
   var diags : Int
   var base : Int
   var stds : Int
   var length : Measurement<UnitLength>
   var depth : Measurement<UnitLength>
   var height : Measurement<UnitLength>
   var baySizes : [ScaffoldingGridSizes]
   var baySet : Set<Int>

}


enum ScaffInfoAction {
   case updateName(String)
  case selectBay(Int)
}

struct ScaffInfoEnvironment {
}

let scaffInfoReducer = Reducer<ScaffInfoState, ScaffInfoAction, ScaffInfoEnvironment> { (state,action,env) in
   switch action {
   case .updateName(let str):
      state.name = str
   case .selectBay(let index):
    if state.baySet.contains(index) {
      state.baySet.remove(index)
    } else {
      state.baySet.insert(index)
    }
   }
   return .none
}


struct ScaffInfoForm: View {
   let store : Store<ScaffInfoState, ScaffInfoAction>

   
   var body: some View {
          WithViewStore(store){ viewStore in
             
             NavigationView {
                VStack {
                   Form{
                      Section {
                        TextField("Name",
                                  text:  viewStore
                                     .binding(
                                        get: { $0.name},
                                        send: { .updateName($0) })
                         )
                      }
                    Section {
                       HStack{
                          Text("Ledgers")
                          Spacer()
                          Text("\(viewStore.ledgers)")
                       }
                       HStack{
                          Text("Diags")
                          Spacer()
                          Text("\(viewStore.diags)")
                       }
                       HStack{
                          Text("Base Collars")
                          Spacer()
                          Text("\(viewStore.base)")
                       }
                       HStack{
                          Text("Standards")
                          Spacer()
                          Text("\(viewStore.stds)")
                       }
                    }
                    Section {
                       HStack{
                          Text("Length")
                          Spacer()
                        Text("\(viewStore.length |> metricFormatter)")
                       }
                       HStack{
                          Text("Depth")
                          Spacer()
                          Text("\(viewStore.depth |> metricFormatter)")
                       }
                       HStack{
                              Text("Height")
                              Spacer()
                              Text("\(viewStore.height |> metricFormatter)")
                           }
                        }
                    Section {
                      HStack{
                        Text("Length")
                        Spacer()
                        Text("\(viewStore.length |> imperialFormatter)")
                      }
                      HStack{
                        Text("Depth")
                        Spacer()
                        Text("\(viewStore.depth |> imperialFormatter)")
                      }
                      HStack{
                        Text("Height")
                        Spacer()
                        Text("\(viewStore.height |> imperialFormatter)")
                      }
                    }
                    Section {
                      Text("Length")
                    }
                    Section {
                      ForEach(viewStore.baySizes.indices){ index in
                        MultipleSelctionRow(
                          title: "\(viewStore.baySizes[index])",
                        isSelectected: viewStore.baySet.contains(index)) {
                          viewStore.send(.selectBay(index))
                        }
                      }
                    }
                    Section {
                      Text("Length")
                    }
                  }
                
                  
              }
            }.navigationBarTitle(viewStore.name)
      }
   }
}



struct MultipleSelctionRow : View {
  var title: String
  var isSelectected: Bool
  var action : ()->Void
  
  var body: some View {
    Button(action: self.action) {
      HStack {
        Text(self.title)
        if self.isSelectected {
          Spacer()
          Image(systemName: "checkmark")
        }
      }
    }
  }
}


//struct ScaffInfoForm_Previews: PreviewProvider {
//    static var previews: some View {
//      ScaffInfoForm(store:
//         Store(
//            initialState: ScaffInfoState(name: "Test", ledgers: 24, diags: 24, base: 24, stds: 24, length: Measurement<UnitLength>(value: 2, unit: .meters), depth: Measurement<UnitLength>(value: 2, unit: .meters), height: Measurement<UnitLength>(value: 2, unit: .meters), baySizes: [25.0, 50, 100, 150, 175, 200, 250, 300], baySet: [3,5]),
//            reducer: scaffInfoReducer,
//            environment: ScaffInfoEnvironment()))
//    }
//}

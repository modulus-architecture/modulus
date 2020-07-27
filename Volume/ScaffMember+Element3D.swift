//
//  ScaffMember+Element3D.swift
//  Deploy
//
//  Created by Justin Smith on 7/3/17.
//  Copyright © 2017 Justin Smith. All rights reserved.
//

import Foundation

extension ScaffMember {
  var element3D : Element3D
  {
    get {
      let s = self
      switch s.type
      {
      case let .ledger (size, axis) :
        let ledger = LedgerMaker(size:size)
        ledger.position = s.position
        if axis == .y {
          ledger.rotation = Degree(90)
        }
        return ledger
        
      case let .standard ( size, _) :
        let std = StdMaker(size: size)
        std.position = s.position
        return std
        
        
      case .bc:
        let bc = BCMaker()
        bc.position = s.position
        return bc
        
      case let .diag (run, rise, axis) :
        let diag = DiagMaker(run: run, rise: rise)
        
        if axis == .y {
          diag.rotation = Degree(90)
        }
        diag.position = s.position
        
        
        return diag
        
      case .woodPad :
        let pad  = WoodPadMaker()
        pad.position = s.position
        return pad
        
        
      case .screwJack :
        
        
        let pad  =  ScrewJackMaker()
        pad.position = s.position
        return pad
        
        
      }
      
    }
  }
}

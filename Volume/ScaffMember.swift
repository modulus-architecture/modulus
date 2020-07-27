//
//  ScaffMember.swift
//  ScaffBuilder
//
//  Created by Justin Smith on 8/3/16.
//  Copyright © 2016 Justin Smith. All rights reserved.
//

import Foundation



public enum ScaffType3D {
   public enum Axis { case x; case y }
   case ledger (size: Measurement<UnitLength>, axis: ScaffType3D.Axis)
    case standard (size: Measurement<UnitLength>, with: Bool)
   case diag (run: Measurement<UnitLength>, rise: Measurement<UnitLength>, axis: ScaffType3D.Axis)
    case bc
    case woodPad
    case screwJack
}
extension ScaffType3D : CustomStringConvertible {
    public var description: String {
        switch self {
        case .ledger : return "Ledger"
        case .standard : return "Standard"
        case .diag : return "Diag"
        case .bc : return "Base Collar"
        case .woodPad : return "Wood Pad"
        case .screwJack : return "Screw Jack"
        }
    }
}
extension ScaffType3D
{
   func ledgerLegacy ( size: Double, axis: ScaffType3D.Axis) -> ScaffType3D
  {
    return ScaffType3D.ledger(size: size.cm, axis: axis)
  }
}



public func ==(lhs: ScaffType3D.Axis, rhs: ScaffType3D.Axis) -> Bool
{
    switch (lhs, rhs)
    {
    case (.x, .x), (.y, .y) : return true
    default: return false
    }
}

extension ScaffType3D : Equatable {
    
}
public func ==(lhs: ScaffType3D, rhs: ScaffType3D) -> Bool
{
    switch (lhs, rhs)
    {
    case let ( .ledger(ls, la), .ledger (rs, ra) ):
        if ls == rs && la == ra { return true }
    case let ( .standard(ls, la), .standard (rs, ra) ):
        if ls == rs && la == ra { return true }
    case let ( .diag(l1, l2, l3), .diag (r1, r2, r3) ):
        if l1 == r1 && (l2 == r2) && (l3 == r3) { return true }
    case  (.bc, .bc):
        return true;
    default:
        return false
    }
    return false
}



public struct ScaffMember {
    public var type : ScaffType3D
    public var position : (x: Measurement<UnitLength>, y: Measurement<UnitLength>, z: Measurement<UnitLength>)
}

extension ScaffMember {
  public init(type: ScaffType3D, position: (x: Double, y: Double, z: Double))
  {
    self.type = type
    self.position = (x: position.x.cm , y: position.y.cm, z: position.z.cm)
  }
}


extension ScaffMember : CustomStringConvertible {
    public var description: String {
        return "\(self.type) x: \(position.x), y: \(position.y), z: \(position.z)"
    }
}

extension ScaffMember : Equatable {
    
}
public func ==(lhs: ScaffMember, rhs: ScaffMember) -> Bool
{
    return lhs.position == rhs.position && lhs.type == rhs.type
}


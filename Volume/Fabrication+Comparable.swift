//
//  Fabrication+Comparable.swift
//  Deploy
//
//  Created by Justin Smith on 7/3/17.
//  Copyright © 2017 Justin Smith. All rights reserved.
//

import Foundation
//func == (lhs: Diagram, rhs: Diagram) -> Bool {
//      return lhs.elements.count == rhs.elements.count
//            && !zip(lhs.elements, rhs.elements).contains { !$0.isEqualTo($1) }
//}
//protocol Drawable {
//      func isEqualTo(other: Drawable) -> Bool
//      func draw()
//}
//extension Drawable where Self : Equatable {
//      func isEqualTo(other: Drawable) -> Bool {
//            if let o = other as? Self { return self == o }
//            return false
//    } }



extension LedgerMaker : Equatable { }
func == (lhs: LedgerMaker, rhs: LedgerMaker) -> Bool
{
  return lhs.position == rhs.position
    && lhs.size == rhs.size
    && lhs.rotation == rhs.rotation
}
extension BCMaker : Equatable { }
func == (lhs: BCMaker, rhs: BCMaker) -> Bool
{
  return lhs.position == rhs.position
}
extension StdMaker : Equatable { }
func == (lhs: StdMaker, rhs: StdMaker) -> Bool
{
  return lhs.position == rhs.position
    && lhs.size == rhs.size
}

extension DiagMaker : Equatable { }
func == (lhs: DiagMaker, rhs: DiagMaker) -> Bool
{
  return lhs.run == rhs.run && lhs.rise == rhs.rise && lhs.rotation == rhs.rotation
}

extension Element3D where Self : Equatable {
  func isEqualTo(other: Element3D) -> Bool {
    guard let o = other as? Self else { return false }
    
    return self == o
  }
}



// Real function
func == (lhs: Element3D, rhs: Element3D) -> Bool
{
  guard lhs.position == rhs.position else { return false }
  
  if let lhs = lhs as? LedgerMaker  {
    
    guard let rhs = rhs as? LedgerMaker else {  return false }
    
    return lhs.size == rhs.size && lhs.rotation == rhs.rotation
  }
    
  else if lhs is BCMaker  {
    
    guard rhs is BCMaker else {  return false }
    
    return true
  }
    
  else if let lhs = lhs as? StdMaker  {
    
    guard let rhs = rhs as? StdMaker else {  return false }
    
    return lhs.size == rhs.size
  }
    
  else if let lhs = lhs as? DiagMaker  {
    
    guard let rhs = rhs as? DiagMaker else {  return false }
    
    return lhs.run == rhs.run && lhs.rise == rhs.rise && lhs.rotation == rhs.rotation
  }
  
  return true
}

extension Element3D {
  func isDerivedFrom(_ member: ScaffMember) -> Bool
  {
    guard self.position == member.position else { return false }
    
    return self.isRelatedTo(member)
  }
  func isRelatedTo(_ member: ScaffMember) -> Bool
  {
    switch member.type
    {
    case let .ledger (size, axis) :
      guard let element = self as? LedgerMaker else {  return false }
      let sEqual = element.size == size
      let rEqual = axis == .y ? element.rotation == Degree(90) : element.rotation == Degree(0)
      return sEqual && rEqual
      
    case let .standard ( size, _) :
      guard let element = self as? StdMaker else {  return false }
      
      let sEqual = element.size == size
      
      return sEqual
      
    case .bc:
      guard self is BCMaker else {  return false }
      return true
      
    case let .diag (run, rise, axis) :
      guard let element = self as? DiagMaker else {  return false }
      let sEqual = element.run == run &&  element.rise == rise
      let rEqual = axis == .y ? element.rotation == Degree(90) : element.rotation == Degree(0)
      return sEqual && rEqual
    case .woodPad:
      guard self is WoodPadMaker else {  return false }
      return true
    case .screwJack:
      guard self is ScrewJackMaker else {  return false }
      return true
      
    }
  }
}

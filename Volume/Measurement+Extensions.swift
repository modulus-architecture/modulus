//
//  Measurement+Extensions.swift
//  Deploy
//
//  Created by Justin Smith on 7/4/17.
//  Copyright © 2017 Justin Smith. All rights reserved.
//

import Foundation

extension Double {
  var m : Measurement<UnitLength> { get { return Measurement<UnitLength>(value: self, unit: UnitLength.meters) } }
  var cm : Measurement<UnitLength> { get { return Measurement<UnitLength>(value: self, unit: UnitLength.centimeters) } }
  var mm : Measurement<UnitLength> { get { return Measurement<UnitLength>(value: self, unit: UnitLength.millimeters) } }
}

extension Float {
  var m : Measurement<UnitLength> { get { return Measurement<UnitLength>(value: Double(self), unit: UnitLength.meters) } }
  var cm : Measurement<UnitLength> { get { return Measurement<UnitLength>(value: Double(self), unit: UnitLength.centimeters) } }
  var mm : Measurement<UnitLength> { get { return Measurement<UnitLength>(value: Double(self), unit: UnitLength.millimeters) } }
}

extension Int {
  var m : Measurement<UnitLength> { get { return Measurement<UnitLength>(value: Double(self), unit: UnitLength.meters) } }
  var cm : Measurement<UnitLength> { get { return Measurement<UnitLength>(value: Double(self), unit: UnitLength.centimeters) } }
  var mm : Measurement<UnitLength> { get { return Measurement<UnitLength>(value: Double(self), unit: UnitLength.millimeters) } }
}

extension Double {
  var float : Float { return Float(self) }
  //var cgFloat : CGFloat { return CGFloat(self) }
}

func +=( lhs: inout Measurement<UnitLength>,  rhs: Measurement<UnitLength>)
{
  lhs = lhs + rhs
}

prefix func -(rhs: inout Measurement<UnitLength>)
{
   rhs.value = -rhs.value
}

func -=(lhs: inout Measurement<UnitLength>,  rhs: Measurement<UnitLength>)
{
  lhs = lhs - rhs
}

func * ( lhs: Measurement<UnitLength>, rhs: Double) -> Measurement<UnitLength>
{
  var lhsV = lhs
  lhsV.value = lhsV.value * rhs
  return lhsV
}

func * ( lhs: Measurement<UnitLength>, rhs: Float) -> Measurement<UnitLength>
{
  var lhsV = lhs
  lhsV.value = lhsV.value * Double(rhs)
  return lhsV
}

func * ( lhs: Measurement<UnitLength>, rhs: Measurement<UnitLength>) -> Measurement<UnitLength>
{
  var lhsV = lhs
  lhsV.value = lhsV.value * rhs.converted(to: lhs.unit).value
  return lhsV
}



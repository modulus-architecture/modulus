//
//  _Abstraction+ScalingGrouping.swift
//  OffsetableCore
//
//  Created by Justin Smith on 5/26/18.
//  Copyright © 2018 Justin Smith. All rights reserved.
//

#if os(iOS)
import Geo
import Singalong
#else
import MacGeo
import SingalongMac
#endif


func *(lhs: ViewportAbstration, rhs: CGFloat) -> ViewportAbstration
{
  return ViewportAbstration(bounds: lhs.bounds * rhs,
                            offset: lhs.offset * rhs,
                            size: lhs.size * rhs,
                            scale: lhs.scale,
                            padding: lhs.padding * rhs)
}

func *(lhs: ScrollViewAbstraction, rhs: CGFloat) -> ScrollViewAbstraction
{
  return ScrollViewAbstraction(bounds: lhs.bounds * rhs,
                            exterior: lhs.exterior * rhs,
                            interior: lhs.interior * rhs)
}

func *(lhs: ARect, rhs: CGFloat) -> ARect
{
  return ARect(origin: lhs.origin * rhs, size: lhs.size * rhs)
}




let scale : CGFloat = 20
let curriedMultiplierVP :  (ViewportAbstration) -> (CGFloat) -> ViewportAbstration = curry(*)
let scaleVPA = flip(curriedMultiplierVP)(scale)

let defaultXUnitViewport = ViewportAbstration(bounds: 10,
                                              offset: 0,
                                              size: 8,
                                              scale: 1,
                                              padding: 1)


// Scale yViewport and then combine with scaled xViewport
let xSideScaledVPA = (defaultXUnitViewport |> scaleVPA)
let xSideThenYSideVP = curry(ViewportModel.init)
let halfVPScaled = xSideScaledVPA |> xSideThenYSideVP
public let testScaledScrollViewFromVPA = scaleVPA >>> halfVPScaled



let curriedMultiplierSV :  (ScrollViewAbstraction) -> (CGFloat) -> ScrollViewAbstraction = curry(*)
let scaleSVA = flip(curriedMultiplierSV)(scale)
let defaultXUintScrollview = defaultXUnitViewport |> O1.init |> ScrollViewAbstraction.init
// Scale yViewport and then combine with scaled xViewport
let xSideScaledSVA = (defaultXUintScrollview |> scaleSVA)
let xSideThenYSideSV : (ScrollViewAbstraction) -> (ScrollViewAbstraction) -> ScrollViewModel = curry(ScrollViewModel.init)
let halfSVScaled = xSideScaledSVA |> xSideThenYSideSV
public let testScaledScrollViewFromSVA = scaleSVA >>> halfSVScaled

let myTestVPModel = (defaultXUnitViewport * 10, defaultXUnitViewport * 10) |> ViewportModel.init

let myTestModel = (defaultXUintScrollview * 10, defaultXUintScrollview * 10) |> ScrollViewModel.init


let fixedPaddingClip : (CGFloat) -> (O1) -> (O1)
  = flip(curry(clip))

let posPaddedClip : (ViewportAbstration) -> (O1) -> (O1)
  = get(\ViewportAbstration.padding.magnitude)
    >>> fixedPaddingClip









let posClipToO1 : (ViewportAbstration) -> O1
  = { $0 |> O1.init |> posPaddedClip( $0 ) }

let toPosSize : (O1) -> (PosSize)
  = PosSize1D.init
    >>> PosSize.init

var f =
  fixedPaddingClip(2)
    >>> PosSize1D.init
    >>> PosSize.init





/// SImple clip


// Isomporphic with VPA . breaks out padding and O1
public let brokenOutViewport : (ViewportAbstration) -> ( O1, padding: Extent) = {
  return ($0 |> O1.init, $0.padding )
}

let simpleClip2Helper : (O1, Extent) -> (O1, CGFloat) = { return ($0,$1.rawValue)}
public let simpleClip2 = simpleClip2Helper >>> pad |> detuple




#if os(iOS)
import Geo
import Singalong
#else
import MacGeo
import SingalongMac
#endif




public struct O1 : Equatable {
  var bounds: Height
  var outerOrigin : Point
  var outerSize : Height
  var origin : Point
  var size: Height
  
  public init(
    bounds: Height,
    outerOrigin : Point,
    outerSize : Height,
    origin : Point,
    size: Height
    )
  {
    (
      self.bounds,
      self.outerOrigin,
      self.outerSize,
      self.origin,
      self.size
    )  = (bounds, outerOrigin, outerSize, origin, size)
  }
}

extension O1
{
  public init (p: PosSize1D)
  {
    self.init(bounds: p.boundary, outerOrigin: p.contentOrigin, outerSize: p.contentSize, origin: p.padding, size: p.size)
  }
}


public func belowBottomBounds(_ s: O1) -> Height
{
  return s.outerOrigin + s.outerSize - s.bounds
}

public func boundsAsMin(_ s: O1) -> Height
{
  let topHeight = max(0, -s.outerOrigin)
  let middleHeight = s.bounds
  let bottomHeightT = max(0, s |> belowBottomBounds)
  return
    topHeight
      + middleHeight
      + bottomHeightT
}

func center(_ s: O1) -> Point
{
  return s.origin + s.size/2
}

func baseLevelCenter(_ s: O1) -> Point
{
  return s.outerOrigin + s|>center
}

func topHalf(_ s: O1) -> Height
{
  return s|>center
}

func bottomHalf(_ s: O1) -> Height
{
  return s.outerSize - s |> topHalf
}





func topHalfAdjustment( _ s: O1, newTop: Height) -> O1
{
  return O1(bounds: s.bounds,
            outerOrigin: s|>baseLevelCenter - newTop,
            outerSize: newTop + s|>bottomHalf,
            origin: newTop - s.size/2,
            size: s.size)
}

func bottomHalfAdjustment( _ s: O1, newBottom: Height) -> O1
{
  return O1(bounds: s.bounds,
            outerOrigin: s.outerOrigin,
            outerSize: s|>topHalf + newBottom,
            origin: s.origin,
            size: s.size)
}

func offsetForBottomHalfContentSizeAdjustment( _ s: O1, newBottomBuffer: Height) -> Offset
{
  return s.outerOrigin // size
}


func sizeForTopHalfContentSizeAdjustment( _ s: O1, newTopBuffer: Height) -> Point
{
  return s |> bottomHalf + s |> topHalf // offset is based on opposite cordinate direction
}




func add( _ s: O1, padding: CGFloat) -> O1
{
  return s
    |> prop(\O1.origin)({ $0 - padding})
    <> prop(\O1.size)({ $0 + padding})
}

func remove( _ s: O1, padding: CGFloat) -> O1
{
  return s
    |> prop(\O1.origin)({ $0 + padding})
    <> prop(\O1.size)({ $0 - padding})
}

/// newWhole adjusts the content origin to make it is before or starting at the origin
/// newWhole uses the bounds as as minumum size for the new contentSize
/// newWhole adjusts the origin relative to the new outerOrigin
// bounds:    |------|
// outer:       |-----|
//               12345
// master:       |---|
// INTO ->
// bounds:    |-----|
// outer:     |-------|
//             1234567
// master:       |---|
public let newWhole : (O1) -> O1 =
{
  return O1(bounds: $0.bounds,
            outerOrigin: min(0, $0.outerOrigin),
            outerSize: boundsAsMin($0),
            origin: $0.outerOrigin < 0 ? $0.origin : $0.outerOrigin + $0.origin,
            size: $0.size)
}


/// Perform adjustments adds spacing in order to scroll to center of bounds
// maks sure the contentSize reaches the end of bounds
// doesn't change the other
// bounds:      |------|
// outer:     |------|
// master:    |

// // outer:  |------|>|

// INTO ->
// bounds:      |------|
// outer:  |-----------|
// master:    |
public func performAdjustments( _ s:O1) -> O1 {
  
  let centerOfBounds = s.bounds/2
  
  if s|>baseLevelCenter < centerOfBounds {
    if centerOfBounds > s|>topHalf {
      return (s, centerOfBounds) |> topHalfAdjustment
    }
  }
  else {
    if centerOfBounds > s|>bottomHalf {
      return (s, centerOfBounds) |> bottomHalfAdjustment
    }
  }
  return s
}

public func pad( _ s: O1, padding: CGFloat ) -> O1
{
  return padSeperate(s, topPadding: padding, bottomPadding: padding)
}

public func padSeperate( _ s: O1, topPadding: CGFloat, bottomPadding: CGFloat) -> O1
{
  let changeTop = flip(curry(topHalfAdjustment))
  let changeBottom = flip(curry(bottomHalfAdjustment))
  
  let addHalfSizePlusTopPadding =  (s.size/2 + topPadding) |> changeTop
  let addHalfSizePlusBottomPadding = (s.size/2 + bottomPadding) |> changeBottom
  
  return s |> addHalfSizePlusTopPadding <> addHalfSizePlusBottomPadding
}


public let clip = detuple(pad >>> newWhole >>> performAdjustments)
public let clipSeperate = detuple(padSeperate >>> newWhole >>> performAdjustments)




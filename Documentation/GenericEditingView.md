# GenericEditingView

``` swift
public struct GenericEditingView<Holder:​ GraphHolder>
```

## Initializers

### `init(build:​origin:​size:​size3:​composite:​grid2D:​selectedCell:​)`

``` swift
public init(build:​ @escaping ([CGFloat], CGSize3, [Edge<Holder.Content>]) -> (GraphPositions, [Edge<Holder.Content>]), origin:​ @escaping (Holder) -> CGPoint, size:​ @escaping (Holder) -> CGSize, size3:​ @escaping (Holder) -> (CGSize) -> CGSize3, composite:​ @escaping (Holder) -> Composite, grid2D:​ @escaping (Holder) -> GraphPositions2DSorted, selectedCell:​ @escaping (PointIndex2D, GraphPositions, [Edge<Holder.Content>]) -> ([Edge<Holder.Content>]))
```

## Properties

### `build`

takes a bounding box size, and any existing structure (\[Edge\]) to interprit a new ScaffGraph,a fully 3D structure

``` swift
let build:​ ([CGFloat], CGSize3, [Edge<Holder.Content>]) -> (GraphPositions, [Edge<Holder.Content>])
```

### `origin`

origin:​ in this editing view slice, the offset from the 0,0 corner of the bounding box

``` swift
let origin:​ (Holder) -> CGPoint
```

### `size`

Related to the size of the bounding box

``` swift
let size:​ (Holder) -> CGSize
```

### `size3`

Translates this view's 2D rep to 3D boounding box based on the graph and view semantics

``` swift
let size3:​ (Holder) -> (CGSize) -> CGSize3
```

### `composite`

From Graph to Geometry at (0,0)
Geometry bounds is not necisarily the same as the size, which is a bounding box

``` swift
let composite:​ (Holder) -> Composite
```

### `grid2D`

related to the entire composite

``` swift
let grid2D:​ (Holder) -> GraphPositions2DSorted
```

### `selectedCell`

if point index in 2D give new 3D edges

``` swift
let selectedCell:​ (PointIndex2D, GraphPositions, [Edge<Holder.Content>]) -> ([Edge<Holder.Content>])
```

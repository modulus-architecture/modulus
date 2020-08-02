# Line

``` swift
public struct Line:​ Geometry
```

## Inheritance

`Drawable`, [`Geometry`](/Geometry), [`SKRepresentable`](/SKRepresentable)

## Initializers

### `init(start:​end:​)`

``` swift
public init(start:​ Geometry, end:​ Geometry)
```

## Properties

### `position`

``` swift
var position:​ CGPoint
```

### `asNode`

``` swift
var asNode:​ SKNode
```

### `frame`

``` swift
var frame:​ CGRect
```

## Methods

### `draw(in:​)`

``` swift
public func draw(in renderer:​ Renderer)
```

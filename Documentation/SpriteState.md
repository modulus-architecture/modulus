# SpriteState

``` swift
public struct SpriteState<Holder:​ GraphHolder>:​ Equatable
```

## Inheritance

`Equatable`

## Properties

### `frame`

``` swift
var frame:​ Changed<CGRect>
```

### `spriteFrame`

``` swift
var spriteFrame:​ CGRect
```

### `scale`

``` swift
var scale:​ CGFloat
```

### `graph`

``` swift
var graph:​ Holder
```

### `modelSpaceSize`

``` swift
var modelSpaceSize:​ CGSize
```

### `viewSpaceSize`

``` swift
var viewSpaceSize:​ CGSize
```

### `nodeOrigin`

``` swift
var nodeOrigin:​ CGPoint
```

### `aligned`

``` swift
var aligned:​ (HorizontalPosition, VerticalPosition)
```

## Methods

### `==(lhs:​rhs:​)`

``` swift
public static func ==(lhs:​ SpriteState<Holder>, rhs:​ SpriteState<Holder>) -> Bool
```

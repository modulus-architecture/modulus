# InterfaceState

``` swift
public struct InterfaceState<Holder:​ GraphHolder>:​ Equatable
```

## Inheritance

`Equatable`

## Initializers

### `init(graph:​mapping:​sizePreferences:​scale:​windowBounds:​offset:​)`

``` swift
public init(graph:​ Holder, mapping:​ [GenericEditingView<Holder>], sizePreferences:​ [CGFloat], scale:​ CGFloat, windowBounds:​ CGRect, offset:​ CGPoint)
```

## Properties

### `windowBounds`

``` swift
let windowBounds:​ CGRect
```

### `spriteState`

``` swift
var spriteState:​ SpriteState<Holder>
```

### `canvasState`

``` swift
var canvasState:​ CanvasSelectionState
```

### `canvasFrame`

``` swift
var canvasFrame:​ CGRect
```

### `canvasSize`

``` swift
var canvasSize:​ CGSize
```

### `canvasOffset`

``` swift
var canvasOffset:​ CGPoint
```

### `scale`

``` swift
var scale:​ CGFloat
```

### `selection`

``` swift
var selection:​ CGRect
```

### `selectionView`

``` swift
var selectionView:​ CGRect
```

### `sizePreferences`

``` swift
var sizePreferences:​ [CGFloat]
```

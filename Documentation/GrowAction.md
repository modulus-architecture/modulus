# GrowAction

``` swift
public enum GrowAction
```

## Inheritance

`CustomStringConvertible`

## Enumeration Cases

### `onZoomBegin`

``` swift
case onZoomBegin(scrollState:​ ReadScrollState, pinchLocations:​ (CGPoint,CGPoint))
```

### `onZoom`

``` swift
case onZoom(scrollState:​ ReadScrollState, pinchLocations:​ (CGPoint,CGPoint))
```

### `onZoomEnd`

``` swift
case onZoomEnd(scrollState:​ ReadScrollState)
```

### `onDragBegin`

``` swift
case onDragBegin(scrollState:​ ReadScrollState)
```

### `onDrag`

``` swift
case onDrag(scrollState:​ ReadScrollState)
```

### `onDragEnd`

``` swift
case onDragEnd(scrollState:​ ReadScrollState, willDecelerate:​ Bool)
```

### `onDecelerate`

``` swift
case onDecelerate(scrollState:​ ReadScrollState)
```

### `onDecelerateEnd`

``` swift
case onDecelerateEnd(scrollState:​ ReadScrollState)
```

## Properties

### `description`

``` swift
var description:​ String
```

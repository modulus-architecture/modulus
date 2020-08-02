# ScallopGraph

``` swift
public class ScallopGraph:​ GraphHolder, Equatable
```

## Inheritance

`Equatable`, [`GraphHolder`](/GraphHolder)

## Nested Type Aliases

### `Content`

``` swift
public typealias Content = ScallopParts
```

## Initializers

### `init()`

``` swift
public convenience init()
```

### `init(positions:​edges:​id:​)`

``` swift
public init(positions:​ GraphPositions, edges:​ [Edge<Content>], id:​ String = "MODEMOCK")
```

## Properties

### `id`

``` swift
var id:​ String
```

### `edges`

``` swift
var edges:​ [Edge<Content>]
```

### `grid`

``` swift
var grid:​ GraphPositions
```

## Methods

### `==(lhs:​rhs:​)`

``` swift
public static func ==(lhs:​ ScallopGraph, rhs:​ ScallopGraph) -> Bool
```

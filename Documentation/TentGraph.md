# TentGraph

``` swift
public class TentGraph:​ GraphHolder, Equatable
```

## Inheritance

`Equatable`, [`GraphHolder`](/GraphHolder)

## Nested Type Aliases

### `Content`

``` swift
public typealias Content = TentParts
```

## Initializers

### `init(width:​depth:​elev:​id:​)`

``` swift
public convenience init(width:​ CGFloat = 500, depth:​ CGFloat = 1000, elev:​ CGFloat = 450, id:​ String = "MODEMOCK")
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
public static func ==(lhs:​ TentGraph, rhs:​ TentGraph) -> Bool
```

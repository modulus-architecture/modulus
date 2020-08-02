# ScaffGraph

``` swift
public struct ScaffGraph:​ Equatable, GraphHolder
```

## Inheritance

`Equatable`, [`GraphHolder`](/GraphHolder)

## Initializers

### `init(id:​grid:​edges:​)`

``` swift
public init(id:​ String, grid:​ GraphPositions, edges:​ [ScaffEdge])
```

## Properties

### `id`

``` swift
var id:​ String
```

### `grid`

``` swift
var grid:​ GraphPositions
```

### `edges`

``` swift
var edges:​ [ScaffEdge]
```

### `planEdgesNoZeros`

``` swift
var planEdgesNoZeros:​ [C2Edge<ScaffType>]
```

### `frontEdgesNoZeros`

``` swift
var frontEdgesNoZeros:​ [C2Edge<ScaffType>]
```

### `sideEdgesNoZeros`

``` swift
var sideEdgesNoZeros:​ [C2Edge<ScaffType>]
```

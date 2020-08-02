# Composite

``` swift
public struct Composite
```

## Inheritance

`Semigroup`

## Initializers

### `init(geometry:​labels:​)`

``` swift
public init(geometry:​ [Geometry], labels:​ [Label])
```

### `init(geometry:​)`

``` swift
init(geometry:​ [Geometry])
```

### `init(labels:​)`

``` swift
init(labels:​ [Label])
```

## Properties

### `geometry`

``` swift
var geometry:​ [Geometry]
```

### `labels`

``` swift
var labels:​ [Label]
```

## Methods

### `<>(lhs:​rhs:​)`

``` swift
public static func <>(lhs:​ Composite, rhs:​ Composite) -> Composite
```

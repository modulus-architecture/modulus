# Edit

Defines an atomic edit.

``` swift
public struct Edit<T:​ Equatable>
```

> 

## Initializers

### `init(_:​value:​destination:​)`

``` swift
public init(_ operation:​ EditOperation, value:​ T, destination:​ Int)
```

## Properties

### `operation`

``` swift
let operation:​ EditOperation
```

### `value`

``` swift
let value:​ T
```

### `destination`

``` swift
let destination:​ Int
```

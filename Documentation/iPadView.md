# iPadView

``` swift
public struct iPadView<Holder:​ GraphHolder>:​ View
```

## Inheritance

`View`

## Initializers

### `init(store:​)`

``` swift
public init(store:​ Store<QuadState<Holder>, QuadAction<Holder>>)
```

## Properties

### `store`

``` swift
var store:​ Store<QuadState<Holder>, QuadAction<Holder>>
```

### `viewStore`

``` swift
var viewStore:​ ViewStore<QuadState<Holder>, QuadAction<Holder>>
```

### `body`

``` swift
var body:​ some View
```

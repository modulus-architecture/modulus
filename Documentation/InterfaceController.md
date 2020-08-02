# InterfaceController

``` swift
public class InterfaceController<Holder:​ GraphHolder>:​ UIViewController
```

## Inheritance

`UIViewController`

## Initializers

### `init(store:​)`

``` swift
public init(store:​ Store<InterfaceState<Holder>, InterfaceAction<Holder>>)
```

## Properties

### `store`

``` swift
let store:​ Store<InterfaceState<Holder>, InterfaceAction<Holder>>
```

### `viewStore`

``` swift
let viewStore:​ ViewStore<InterfaceState<Holder>, InterfaceAction<Holder>>
```

## Methods

### `viewWillAppear(_:​)`

``` swift
override public func viewWillAppear(_ animated:​ Bool)
```

### `loadView()`

``` swift
override public func loadView()
```

# QuadView

``` swift
public struct QuadView<Holder:​ GraphHolder>:​ UIViewControllerRepresentable
```

## Inheritance

`UIViewControllerRepresentable`

## Nested Type Aliases

### `UIViewControllerType`

``` swift
public typealias UIViewControllerType = UINavigationController
```

## Initializers

### `init(store:​)`

``` swift
public init(store:​ Store<QuadState<Holder>, QuadAction<Holder>>)
```

## Properties

### `store`

``` swift
let store:​ Store<QuadState<Holder>, QuadAction<Holder>>
```

### `storeView`

``` swift
let storeView:​ ViewStore<QuadState<Holder>, QuadAction<Holder>>
```

## Methods

### `makeUIViewController(context:​)`

``` swift
public func makeUIViewController(context:​ UIViewControllerRepresentableContext<QuadView<Holder>>) -> UINavigationController
```

### `updateUIViewController(_:​context:​)`

``` swift
public func updateUIViewController(_ uiViewController:​ UINavigationController, context:​ UIViewControllerRepresentableContext<QuadView<Holder>>)
```

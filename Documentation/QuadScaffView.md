# QuadScaffView

``` swift
public struct QuadScaffView:​ UIViewControllerRepresentable
```

## Inheritance

`UIViewControllerRepresentable`

## Nested Type Aliases

### `UIViewControllerType`

``` swift
public typealias UIViewControllerType = UINavigationController
```

## Initializers

### `init()`

``` swift
public init()
```

### `init(store:​)`

``` swift
public init(store:​ Store<QuadScaffState, QuadAction<ScaffGraph>>)
```

## Properties

### `store`

``` swift
let store:​ Store<QuadScaffState, QuadAction<ScaffGraph>>
```

## Methods

### `makeUIViewController(context:​)`

``` swift
public func makeUIViewController(context:​ UIViewControllerRepresentableContext<QuadScaffView>) -> UINavigationController
```

### `updateUIViewController(_:​context:​)`

``` swift
public func updateUIViewController(_ uiViewController:​ UINavigationController, context:​ UIViewControllerRepresentableContext<QuadScaffView>)
```

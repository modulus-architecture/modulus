# SingleScaffView

``` swift
public struct SingleScaffView:​ UIViewControllerRepresentable
```

## Inheritance

`UIViewControllerRepresentable`

## Nested Type Aliases

### `UIViewControllerType`

``` swift
public typealias UIViewControllerType = InterfaceController<ScaffGraph>
```

## Initializers

### `init(store:​)`

``` swift
public init(store:​ Store<InterfaceState<ScaffGraph>, InterfaceAction<ScaffGraph>>)
```

## Properties

### `store`

``` swift
let store:​ Store<InterfaceState<ScaffGraph>, InterfaceAction<ScaffGraph>>
```

## Methods

### `makeUIViewController(context:​)`

``` swift
public func makeUIViewController(context:​ UIViewControllerRepresentableContext<SingleScaffView>) -> InterfaceController<ScaffGraph>
```

### `updateUIViewController(_:​context:​)`

``` swift
public func updateUIViewController(_ uiViewController:​ InterfaceController<ScaffGraph>, context:​ UIViewControllerRepresentableContext<SingleScaffView>)
```

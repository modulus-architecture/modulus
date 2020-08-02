# SingleHolderView

``` swift
public struct SingleHolderView<Holder:​ GraphHolder>:​ UIViewControllerRepresentable
```

## Inheritance

`UIViewControllerRepresentable`

## Nested Type Aliases

### `UIViewControllerType`

``` swift
public typealias UIViewControllerType = InterfaceController<Holder>
```

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

## Methods

### `makeUIViewController(context:​)`

``` swift
public func makeUIViewController(context:​ UIViewControllerRepresentableContext<SingleHolderView<Holder>>) -> InterfaceController<Holder>
```

### `updateUIViewController(_:​context:​)`

``` swift
public func updateUIViewController(_ uiViewController:​ InterfaceController<Holder>, context:​ UIViewControllerRepresentableContext<SingleHolderView<Holder>>)
```

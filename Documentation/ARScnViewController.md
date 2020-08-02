# ARScnViewController

``` swift
public class ARScnViewController:​ UIViewController, Context, SCNContentContext, SCNBounder, ARSCNViewDelegate
```

## Inheritance

`ARSCNViewDelegate`, `Context`, `SCNBounder`, `SCNContentContext`, `UIViewController`

## Initializers

### `init(store:​)`

``` swift
public init(store:​ Store<ARProviderState, Never>)
```

## Methods

### `viewDidLoad()`

``` swift
override public func viewDidLoad()
```

### `viewWillAppear(_:​)`

``` swift
override public func viewWillAppear(_ animated:​ Bool)
```

### `viewDidAppear(_:​)`

``` swift
override public func viewDidAppear(_ animated:​ Bool)
```

### `viewWillDisappear(_:​)`

``` swift
override public func viewWillDisappear(_ animated:​ Bool)
```

### `session(_:​didFailWithError:​)`

``` swift
public func session(_ session:​ ARSession, didFailWithError error:​ Error)
```

### `sessionWasInterrupted(_:​)`

``` swift
public func sessionWasInterrupted(_ session:​ ARSession)
```

### `sessionInterruptionEnded(_:​)`

``` swift
public func sessionInterruptionEnded(_ session:​ ARSession)
```

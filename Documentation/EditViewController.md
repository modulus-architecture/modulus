# EditViewController

``` swift
public class EditViewController<A:​ Equatable, Cell:​ UITableViewCell>:​ SimpleBarButtonViewController
```

## Inheritance

[`SimpleBarButtonViewController`](/SimpleBarButtonViewController)

## Initializers

### `init(config:​)`

``` swift
public init(config:​ EditViewContConfiguration<A, Cell>)
```

### `init?(coder:​)`

``` swift
required public init?(coder aDecoder:​ NSCoder)
```

## Properties

### `canBecomeFirstResponder`

``` swift
var canBecomeFirstResponder:​ Bool
```

### `isEditing`

``` swift
var isEditing:​ Bool
```

## Methods

### `viewDidAppear(_:​)`

``` swift
override public func viewDidAppear(_ animated:​ Bool)
```

### `viewWillAppear(_:​)`

``` swift
override public func viewWillAppear(_ animated:​ Bool)
```

### `viewWillDisappear(_:​)`

``` swift
override public func viewWillDisappear(_ animated:​ Bool)
```

### `motionEnded(_:​with:​)`

``` swift
override public func motionEnded(_ motion:​ UIEvent.EventSubtype, with event:​ UIEvent?)
```

### `tableView(_:​numberOfRowsInSection:​)`

``` swift
override public func tableView(_ tableView:​ UITableView, numberOfRowsInSection section:​ Int) -> Int
```

### `tableView(_:​cellForRowAt:​)`

``` swift
override public func tableView(_ tableView:​ UITableView, cellForRowAt indexPath:​ IndexPath) -> UITableViewCell
```

### `tableView(_:​didSelectRowAt:​)`

``` swift
override public func tableView(_ tableView:​ UITableView, didSelectRowAt indexPath:​ IndexPath)
```

### `tableView(_:​accessoryButtonTappedForRowWith:​)`

``` swift
public override func tableView(_ tableView:​ UITableView, accessoryButtonTappedForRowWith indexPath:​ IndexPath)
```

### `tableView(_:​editActionsForRowAt:​)`

``` swift
override public func tableView(_ tableView:​ UITableView, editActionsForRowAt indexPath:​ IndexPath) -> [UITableViewRowAction]?
```

### `tableView(_:​canMoveRowAt:​)`

``` swift
override public func tableView(_ tableView:​ UITableView, canMoveRowAt indexPath:​ IndexPath) -> Bool
```

### `tableView(_:​moveRowAt:​to:​)`

``` swift
override public func tableView(_ tableView:​ UITableView, moveRowAt sourceIndexPath:​ IndexPath, to destinationIndexPath:​ IndexPath)
```

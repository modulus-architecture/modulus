# InteractionState

``` swift
public enum InteractionState
```

## Enumeration Cases

### `open`

``` swift
case open
```

### `frozen`

``` swift
case frozen(incrementAmount:​ CGVector, edge:​ SelectionEdge)
```

### `dragging`

``` swift
case dragging(incrementAmount:​ CGVector, edge:​ SelectionEdge)
```

### `zooming`

``` swift
case zooming(previousScale:​ CGFloat, interimScale:​ CGFloat)
```

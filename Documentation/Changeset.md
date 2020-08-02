# Changeset

A `Changeset` is a way to describe the edits required to go from one set of data to another.

``` swift
public struct Changeset<T:​ Collection> where T.Iterator.Element:​ Equatable
```

It detects additions, deletions, substitutions, and moves. Data is a `CollectionType` of `Equatable` elements.

> 

> 

## Initializers

### `init(source:​target:​)`

``` swift
public init(source origin:​ T, target destination:​ T)
```

## Properties

### `origin`

The starting-point collection.

``` swift
let origin:​ T
```

### `destination`

The ending-point collection.

``` swift
let destination:​ T
```

### `edits`

The edit steps required to go from `self.origin` to `self.destination`.

``` swift
let edits:​ [Edit<T.Iterator.Element>]
```

> 

> 

## Methods

### `editDistance(source:​target:​)`

Returns the edit steps required to go from `source` to `target`.

``` swift
public static func editDistance(source s:​ T, target t:​ T) -> [Edit<T.Iterator.Element>]
```

> 

> 

#### Parameters

  - source:​ - source:​ The starting-point collection.
  - target:​ - target:​ The ending-point collection.

#### Returns

An array of `Edit` elements. The number of steps is then the `count` of elements.

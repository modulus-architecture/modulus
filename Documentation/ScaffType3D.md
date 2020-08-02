# ScaffType3D

``` swift
public enum ScaffType3D
```

## Inheritance

`CustomStringConvertible`

## Enumeration Cases

### `ledger`

``` swift
case ledger(size:​ Measurement<UnitLength>, axis:​ ScaffType3D.Axis)
```

### `standard`

``` swift
case standard(size:​ Measurement<UnitLength>, with:​ Bool)
```

### `diag`

``` swift
case diag(run:​ Measurement<UnitLength>, rise:​ Measurement<UnitLength>, axis:​ ScaffType3D.Axis)
```

### `bc`

``` swift
case bc
```

### `woodPad`

``` swift
case woodPad
```

### `screwJack`

``` swift
case screwJack
```

## Properties

### `description`

``` swift
var description:​ String
```

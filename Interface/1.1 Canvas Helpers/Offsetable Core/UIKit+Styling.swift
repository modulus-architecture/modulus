
#if os(iOS)
import UIKit


public func border(_ view: UIView)
{
  view.layer.borderColor = UIColor.white.cgColor
  view.layer.borderWidth = 1.0
}

public func borderColor(_ color:UIColor, _ view: UIView)
{
  view.layer.borderColor = color.cgColor
}


import Singalong
public let contentSizeBorder = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) |> curry(borderColor)
public let borderColoredWith = curry(borderColor)
#endif


#if os(iOS)
import UIKit


import UIKit
import Singalong

public let worldFrame = CGRect(0,0,600,800)
public let world = UIView( frame: worldFrame )


let addToView = uncurry(UIView.addSubview)

func centerView( root: UIView, child: UIView )
{
  child.center = root.center
}

public let addToWorld =
  curry(addToView)(world)
  <> curry(centerView)(world)
#endif

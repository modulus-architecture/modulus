//
//  UIKit+Grasshopper.swift
//  HandlesRound1
//
//  Created by Justin Smith on 4/21/18.
//  Copyright © 2018 Justin Smith. All rights reserved.
//

import UIKit
import Singalong




protocol UIRepresentable
{
  var asView : UIView { get }
}


func replaceInPlace(in view: UIView, views: [UIView])
{
  // create tags
  let tags = views
    .enumerated()
    .map{ return 10 + $0.offset }
  
  // Remove anything with my Tag if this is the second time running
  tags.forEach { tag in view.subviews.first(where:{ $0.tag == tag })?.removeFromSuperview() }
  
  // Create label and put in view
  zip(views,tags).forEach {
    $0.tag = $1
    view.addSubview($0)
  }
}

let basicGrid = (0..<10)
  .map{CGFloat($0) * 50.0}
  .map{CGPoint(50, $0) }


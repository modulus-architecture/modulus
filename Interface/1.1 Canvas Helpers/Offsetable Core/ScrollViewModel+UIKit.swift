import Foundation
#if os(iOS)
import Geo
import Singalong

public func viewModel2View( vm: ScrollViewModel) -> (UIView, UIView, UIView)
{
  let interiorView = UIView()
  interiorView.frame = vm.interior
  
  let exteriorView = UIView()
  exteriorView.frame = vm.exterior
  exteriorView.addSubview(interiorView)
  
  let portFrame = CGRect(origin: CGPoint.zero, size: vm.bounds)
  let port = UIView( frame: portFrame)
  port.addSubview(exteriorView)
  
  return (port, exteriorView, interiorView)
}


public func createScrollviewHeirarchyWithModel( vm: ScrollViewModel) -> (UIScrollView, UIView, UIView)
{
  let interiorView = UIView()
  interiorView.frame = vm.interior
  
  let exteriorView = UIView()
  exteriorView.frame = vm.exterior
  exteriorView.addSubview(interiorView)
  
  let portFrame = CGRect(origin: CGPoint.zero, size: vm.bounds)
  let port = UIScrollView( frame: portFrame)
  port.contentSize = vm.exterior.size
  port.contentOffset = vm.exterior.origin * -1.0
  port.addSubview(exteriorView)
  
  return (port, exteriorView, interiorView)
}

public func adjustViewsWithModel(
  assembly: (port: UIView, exteriorView:UIView, interiorView:UIView),
  setup: ScrollViewModel)
{
  assembly.interiorView.frame = setup.interior
  assembly.exteriorView.frame =  setup.exterior
  assembly.port.frame = CGRect(origin: assembly.port.frame.origin, size: setup.bounds)
  
  assembly.exteriorView.addSubview(assembly.interiorView)
  assembly.port.addSubview(assembly.exteriorView)
}

public func adjustScrollviewsWithModel(
  assembly: (port: UIScrollView, exteriorView:UIView, interiorView:UIView),
  setup: ScrollViewModel)
{
  assembly.interiorView.frame = setup.interior
  assembly.exteriorView.frame =  setup.exterior
  assembly.port.frame = CGRect(origin: assembly.port.frame.origin, size: setup.bounds)
  
  assembly.port.contentSize = setup.exterior.size
  assembly.port.contentOffset = setup.exterior.origin * -1.0
  
  
  assembly.exteriorView.addSubview(assembly.interiorView)
  assembly.port.addSubview(assembly.exteriorView)
}

#else
import MacGeo
import SingalongMac
#endif




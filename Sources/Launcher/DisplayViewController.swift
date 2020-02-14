//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/11/20.
//

import Foundation

#if canImport(UIKit) && canImport(Stevia) && canImport(SnapKit)

import SnapKit
import Stevia
import UIKit

/// This controller is responsible for being the container that allows views to present themselves
public class DisplayViewController: UIViewController {
  
  // MARK: - Views -
  
  var presentable: Any
  
  var transition: StandardModalTransitionDelegate
  
  init(view: UIView, grid: Grid, title: String? = nil) {
    presentable = view
    transition = StandardModalTransitionDelegate.init(grid: grid, title: title)
    
    super.init(nibName: nil, bundle: nil)
    
    self.transitioningDelegate = transition
    self.modalPresentationStyle = .custom
  }
  
  init(controller: UIViewController, grid: Grid, title: String? = nil) {
    presentable = controller
    transition = StandardModalTransitionDelegate.init(grid: grid, title: title)
    
    super.init(nibName: nil, bundle: nil)
    
    self.transitioningDelegate = transition
    self.modalPresentationStyle = .custom
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle -
  
  override public func loadView() {
    
    switch presentable {
    case let controller as UIViewController:
      super.loadView()
      addChild(controller)
      controller.view.frame = view.frame
      view.addSubview(controller.view)
      controller.didMove(toParent: self)
      return
    case let view as UIView:
      let containerView = UIView()

      containerView.sv([
           view
         ])
         
         view.snp.makeConstraints { make in
           make.leading.equalTo(containerView.layoutMarginsGuide.snp.leading)
           make.trailing.equalTo(containerView.layoutMarginsGuide.snp.trailing)
           make.bottom.equalTo(containerView.layoutMarginsGuide.snp.bottom)
           make.top.equalTo(containerView.layoutMarginsGuide.snp.top)
         }
         
         
      self.view = view
    default:
      super.loadView()
    }
    
   
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
  }
  
  deinit {
    if let controller = presentable as? UIViewController {
      controller.willMove(toParent: nil)
      controller.view.removeFromSuperview()
      controller.removeFromParent()
    }
  }
  
  
  public static func display(view: UIView, grid: Grid = .point8, title: String? = nil) -> DisplayViewController {
    return DisplayViewController(view: view, grid: grid, title: title)
  }
  
  public static func display(controller: UIViewController, grid: Grid = .point8, title: String? = nil) -> DisplayViewController {
    return DisplayViewController(controller: controller, grid: grid, title: title)
    
  }
  
  
}

//extension UIViewController: Displayable {
//  
//  public static func display(view: UIView, grid: Grid, title: String? = nil) -> UIViewController {
//    
//    return DisplayViewController(view: view, grid: grid, title: title)
//  }
//  
//  public static func display(controller: UIViewController, grid: Grid, title: String? = nil) -> UIViewController {
//    return DisplayViewController(controller: controller, grid: grid, title: title)
//
//  }
//}


#endif

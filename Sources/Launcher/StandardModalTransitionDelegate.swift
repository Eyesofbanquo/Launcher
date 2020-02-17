//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/11/20.
//

#if canImport(UIKit)

import UIKit

/// The standard transition delegate. All this does is present the view modally as intended without _any_ sort of transition animations
class StandardModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
  var grid: Grid?
  var title: String = ""
  
  convenience init(grid: Grid, title: String? = nil) {
    self.init()
    self.title = title ?? "Default Title"
    self.grid = grid
  }
  
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let presentationController = StandardModalPresentationController(presentedViewController: presented, presenting: presenting, grid: self.grid!, title: title)
    return presentationController
  }
}

#endif

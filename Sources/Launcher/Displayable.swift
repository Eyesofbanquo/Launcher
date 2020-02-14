//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/14/20.
//

import Foundation

#if canImport(UIKit)
import UIKit

public protocol Displayable {
  static func display(view: UIView, grid: Grid, title: String?) -> UIViewController
  static func display(controller: UIViewController, grid: Grid, title: String?) -> UIViewController
}

#endif

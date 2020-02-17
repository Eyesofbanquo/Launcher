//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/7/20.
//

import Foundation

#if os(iOS)
import UIKit
#endif

#if canImport(UIKit)
public protocol Suite {
  var rowTitle: String { get }
  var presentationMethod: PresentationMethod { get }

  func controller() -> DisplayViewController
  
  static var enabled: [Suite] { get }
  
  static var suiteName: String { get }
  
}
#endif

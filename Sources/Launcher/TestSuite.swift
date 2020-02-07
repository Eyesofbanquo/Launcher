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
public protocol TestSuite {
  var rawValue: String { get }
  var presentationMethod: PresentationMethod { get }
  var name: String { get }
  func controller() -> UIViewController
}
#endif

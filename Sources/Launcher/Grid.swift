//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/11/20.
//
#if canImport(UIKit)

import UIKit

enum Grid {
  case point8
  case point16
  case point64
  case custom
  
  var positiveOffset: CGFloat {
    switch self {
    case .point8: return 8.0
    case .point16: return 16.0
    case .point64: return 64.0
    default: return 0.0
    }
  }
  
  var negativeOffset: CGFloat {
    return positiveOffset * -1.0
  }

}

#endif

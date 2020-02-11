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
class DisplayViewController: UIViewController {
  
  // MARK: - Views -
  
  var presentableView: UIView
  
  var transition: StandardModalTransitionDelegate
  
  init(viewToPresent: UIView, grid: Grid, title: String? = nil) {
    presentableView = viewToPresent
    transition = StandardModalTransitionDelegate.init(grid: grid, title: title)
    super.init(nibName: nil, bundle: nil)
    
    self.transitioningDelegate = transition
    self.modalPresentationStyle = .custom
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle -
  
  override func loadView() {
    let containerView = UIView()
    
    containerView.sv([
      presentableView
    ])
    
    presentableView.snp.makeConstraints { make in
      make.leading.equalTo(containerView.snp.leading)
      make.trailing.equalTo(containerView.snp.trailing)
      make.bottom.equalTo(containerView.snp.bottom)
      make.top.equalTo(containerView.snp.top)
    }
    
    view = containerView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
  }
}


#endif

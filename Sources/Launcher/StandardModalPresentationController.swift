//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/11/20.
//

import Foundation

#if canImport(UIKit)

import UIKit

/// A generic modal presentation controller. Presents all views the same way iPadOS presents modal views by default
class StandardModalPresentationController: UIPresentationController {
  
  var titleLabel: UILabel?
  lazy var blurView: UIVisualEffectView = {
    let blur = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let blurView = UIVisualEffectView(effect: blur)
    return blurView
  }()
  lazy var layoutGuide: UILayoutGuide = UILayoutGuide()
  lazy var grid: Grid = .point8
  
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    
    blurView.alpha = 0.0
    let blurViewTapped = UITapGestureRecognizer(target: self, action: #selector(self.blurViewTapped(_:)))
    blurView.addGestureRecognizer(blurViewTapped)
  }
  
  init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, grid: Grid, title: String? = nil) {
    
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    
    self.titleLabel = title != nil ? UILabel() : nil
    self.titleLabel?.style { label in
      label.alpha = 0.0
      label.text = title
      label.textColor = .white
      label.numberOfLines = 1
      label.font = UIFont.preferredFont(forTextStyle: .headline)
      label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    self.grid = grid
    
    blurView.alpha = 0.0
    let blurViewTapped = UITapGestureRecognizer(target: self, action: #selector(self.blurViewTapped(_:)))
    blurView.addGestureRecognizer(blurViewTapped)
  }
  
  private func setupBlurView(inContainer containerView: UIView) {
    containerView.insertSubview(blurView, at: 0)
    
//    blurView.alpha = 0.33
    blurView.snp.makeConstraints { make in
      make.leading.equalTo(containerView)
      make.trailing.equalTo(containerView)
      make.bottom.equalTo(containerView)
      make.top.equalTo(containerView)
    }
  }
  
  private func setupTitleLabel(inContainer conatiner: UIView) {
    guard let label = titleLabel else { return }
//    label.alpha = 1.0
    containerView?.insertSubview(label, at: 1)
  }
  
  @objc func blurViewTapped(_ gesture: UITapGestureRecognizer) {
    if gesture.state == .ended {
      presentingViewController.dismiss(animated: true, completion: nil)
    }
  }
  
  override func presentationTransitionWillBegin() {
    guard let containerView = containerView else { return }
    
    setupTitleLabel(inContainer: containerView)
    setupBlurView(inContainer: containerView)

    guard let coordinator = presentedViewController.transitionCoordinator else {
      self.titleLabel?.alpha = 1.0
      blurView.alpha = 0.33
      return
    }
    
    coordinator.animate(alongsideTransition: { context in
      self.titleLabel?.alpha = 1.0
      self.blurView.alpha = 1.0
    }, completion: nil)
  }
  
  override func dismissalTransitionWillBegin() {
    guard let coordinator = presentedViewController.transitionCoordinator else {
      self.titleLabel?.alpha = 0.0
      blurView.alpha = 0.0
      return
    }
    
    self.titleLabel?.alpha = 0.0

    coordinator.animate(alongsideTransition: { context in
      self.blurView.alpha = 0.0
    }, completion: nil)
  }
  
  override func containerViewWillLayoutSubviews() {
    super.containerViewWillLayoutSubviews()
    
    guard let presentedView = presentedView, let containerView = containerView else { return }
    
    containerView.addLayoutGuide(layoutGuide)
      
    layoutGuide.snp.makeConstraints { make in
      make.leading.equalTo(containerView.directionalLayoutMargins.leading).offset(grid.positiveOffset)
      make.trailing.equalTo(containerView.directionalLayoutMargins.trailing).offset(grid.negativeOffset)
      make.top.equalTo(containerView.directionalLayoutMargins.top).offset(grid.positiveOffset)
      make.bottom.equalTo(containerView.directionalLayoutMargins.bottom).offset(grid.negativeOffset)
    }
    
    self.titleLabel?.snp.makeConstraints { make in
      make.leading.equalTo(layoutGuide.snp.leading)
      make.top.greaterThanOrEqualTo(layoutGuide.snp.top)
    }
    
    presentedView.snp.makeConstraints { make in
      make.centerX.equalTo(containerView)
      make.centerY.equalTo(containerView)
      
      if let titleLabel = titleLabel {
        make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
      } else {
        make.top.greaterThanOrEqualTo(layoutGuide.snp.top)
      }
      make.bottom.lessThanOrEqualTo(layoutGuide.snp.bottom)
      make.leading.greaterThanOrEqualTo(layoutGuide.snp.leading)
      make.trailing.lessThanOrEqualTo(layoutGuide.snp.trailing)
    }
    
  }
}



#endif

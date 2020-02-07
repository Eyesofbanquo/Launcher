//
//  File.swift
//  
//
//  Created by Markim Shaw on 2/7/20.
//

import Foundation

#if canImport(UIKit) && canImport(Stevia) && canImport(SnapKit)

import UIKit
import Stevia
import SnapKit

/// The cell used to display a card view on the `TestingViewController`
class TestCell: UITableViewCell {
  
  // MARK: - Properties -
  
  static internal var reuseIdentifier: String = "TestCell"
  
  // MARK: - Views -
  
  var titleLabel: UILabel
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    titleLabel = UILabel()
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    sv([titleLabel])
    
    titleLabel.snp.makeConstraints { label in
      label.leading.equalTo(directionalLayoutMargins.leading)
      label.centerY.equalTo(self)
    }
    
    titleLabel.style { label in
      label.textColor = .black
      label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(withTitle title: String) {
    titleLabel.text = title
  }
}


#endif

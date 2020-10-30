//
//  ProfileOptionTableViewCell.swift
//  SimplED
//
//  Created by Iryna Horbachova on 22.10.2020.
//

import UIKit

class ProfileOptionTableViewCell: UITableViewCell {

  let id = 1
  let titleLabel = UILabel.makeSecondaryLabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .systemBackground
    selectionStyle = .none
    
    addSubview(titleLabel)

    NSLayoutConstraint.activate(
      [
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: PADDING),
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: PADDING),
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -PADDING),
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -PADDING),
      ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

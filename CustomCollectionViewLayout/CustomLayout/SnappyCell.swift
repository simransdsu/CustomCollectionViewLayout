  //
  //  SnappyCell.swift
  //  CustomCollectionViewLayout
  //
  //  Created by Simran Preet Narang on 2022-06-19.
  //

import UIKit

class SnappyCell: UICollectionViewCell {
  
  lazy var superImageView: UIImageView = makeImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    contentView.addSubview(superImageView)
    contentView.clipsToBounds = true
    superImageView.layer.cornerRadius = 20
    
    NSLayoutConstraint.activate([
      superImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      superImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      superImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      superImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }
  
  private func makeImageView() -> UIImageView {
    let v = UIImageView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.contentMode = .scaleAspectFit
    return v
  }
}

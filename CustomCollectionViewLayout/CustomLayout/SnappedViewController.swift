  //
  //  SnappedViewController.swift
  //  CustomCollectionViewLayout
  //
  //  Created by Simran Preet Narang on 2022-06-19.
  //

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {

  private lazy var collectionView = makeCollectionView()
  private var dataSource: [Int] = [0,1,2,3,4,0,1,2,3,4,0,1,2,3,4]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.decelerationRate = .fast
    collectionView.register(SnappyCell.self, forCellWithReuseIdentifier: "\(SnappyCell.self)")
    view.addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.heightAnchor.constraint(equalTo: view.widthAnchor),
    ])
  }
  
  private func makeCollectionView() -> UICollectionView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: SnappyFlowLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SnappyCell.self)", for: indexPath) as! SnappyCell
    cell.superImageView.image = UIImage(named: "\(dataSource[indexPath.row])")
    cell.backgroundColor = [UIColor.red, UIColor.blue, UIColor.green, UIColor.purple, UIColor.yellow].randomElement()?.withAlphaComponent(0.5)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.count
  }
}

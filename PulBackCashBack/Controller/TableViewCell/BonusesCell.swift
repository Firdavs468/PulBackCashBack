//
//  BonusesCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 03/11/21.
//

import UIKit

class BonusesCell: UITableViewCell {
    
    @IBOutlet weak var purchasesButton: UIButton!
    @IBOutlet weak var bonusesButton: UIButton!
    @IBOutlet weak var bonusesView: UIView!
    @IBOutlet weak var collection_view: UICollectionView!
    
    static func nib() -> UINib {
        return UINib(nibName: "BonusesCell", bundle: nil)
    }
    
    static let identifier = "BonusesCell"
    var transformWidth = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isSmalScreen568 {
            transformWidth = 140
        }else if isSmalScreen736 {
            transformWidth = 170
        }else {
            transformWidth = 195
        }
        setupCollectionView()
    }
    
    //  Бонусы  button pressed
    @IBAction func bonusesButtonPressed(_ sender: Any) {
        let nextItem: IndexPath = IndexPath(item: 0, section: 0)
        self.collection_view.scrollToItem(at: nextItem, at: .right, animated: true)
    }
    
    //Покупки button pressed
    @IBAction func purchasesButtonPressed(_ sender: Any) {
        //        let visibleItems: NSArray = self.collection_view.indexPathsForVisibleItems as NSArray
        //        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        //        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        let nextItem : IndexPath = IndexPath(item: 1, section: 0)
        //               if nextItem.row < imgArr.count {
        self.collection_view.scrollToItem(at: nextItem, at: .left, animated: true)
        //        }
        
    }
    
}

//MARK: - CollectionView delegate methods
extension BonusesCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        self.collection_view.delegate = self
        self.collection_view.dataSource = self
        self.collection_view.register(PurchasesCell.nib(), forCellWithReuseIdentifier: PurchasesCell.identifier)
        self.collection_view.register(HomeCell.nib(), forCellWithReuseIdentifier: HomeCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = self.collection_view.dequeueReusableCell(withReuseIdentifier: HomeCell.identifier, for: indexPath) as! HomeCell
            cell.selectedBackgroundView = UIView()
            return cell
        }else  {
            let cell = self.collection_view.dequeueReusableCell(withReuseIdentifier: PurchasesCell.identifier, for: indexPath) as! PurchasesCell
            cell.selectedBackgroundView = UIView()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collection_view.frame.width-20, height: self.collection_view.frame.height-20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("row = ",indexPath.row)
        if indexPath.row == 0 {
            UIView.transition(with: bonusesView, duration: 0.3, options: .curveEaseIn) { [self] in
                self.bonusesView.transform = .identity
            }completion: { [self] _ in
                bonusesButton.setTitleColor(.black, for: .normal)
                purchasesButton.setTitleColor(.systemGray, for: .normal)
            }
        }else {
            UIView.transition(with: bonusesView, duration: 0.3, options: .curveEaseIn) { [self] in
                self.bonusesView.transform = CGAffineTransform(translationX: CGFloat(transformWidth), y: 0)
            }completion: { [self] _ in
                bonusesButton.setTitleColor(.systemGray, for: .normal)
                purchasesButton.setTitleColor(.black, for: .normal)
            }
        }
    }
}


//MARK: - Collection View scroll to item
extension BonusesCell {
    func scrollToItem() {
        //        let visibleItems: NSArray = self.collection_view.indexPathsForVisibleItems as NSArray
        //        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        //        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        let nextItem : IndexPath = IndexPath(item: 1, section: 0)
        //               if nextItem.row < imgArr.count {
        self.collection_view.scrollToItem(at: nextItem, at: .left, animated: true)
        //        }
    }
}

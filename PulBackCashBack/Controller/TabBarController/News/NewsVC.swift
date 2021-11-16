//
//  NewsVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 04/11/21.
//

import UIKit
import  Alamofire
import SwiftyJSON
class NewsVC: UIViewController {
    
    @IBOutlet weak var collection_view: UICollectionView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    @IBOutlet weak var collectionTop: NSLayoutConstraint! {
        didSet {
            if isSmalScreen568 {
                collectionTop.constant = 30
            }else if isSmalScreen736 {
                collectionTop.constant = 50
            }else {
                collectionTop.constant = 70
            }
        }
    }
    @IBOutlet weak var collectionBottom: NSLayoutConstraint! {
        didSet {
            if isSmalScreen568 {
                collectionBottom.constant = 30
            }else if isSmalScreen736 {
                collectionBottom.constant = 50
            }else {
                collectionBottom.constant = 70
            }
        }
    }
    
    // MARK: - Properties
    var carouselData = [CarouselData]()
    private var currentPage = 0
    var imgArr = [1,2,3,4,4]
    var bannerArr : [GetBannerNews] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBanner()
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        
    }
}

//MARK: - CollectionView delegate methods
extension NewsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        self.collection_view.delegate = self
        self.collection_view.dataSource = self
        self.collection_view.register(NewsCell.nib(), forCellWithReuseIdentifier: NewsCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !bannerArr.isEmpty {
            return bannerArr.count
        }else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collection_view.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as! NewsCell
        if !bannerArr.isEmpty {
            self.collection_view.isHidden = false
            Loader.stop()
            cell.updateCell(img: bannerArr[indexPath.row].image, date: bannerArr[indexPath.row].created_at, content: bannerArr[indexPath.row].content, title: bannerArr[indexPath.row].title)
        }else {
            self.collection_view.isHidden = true
            Loader.start()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collection_view.frame.width-10 , height:self.collection_view.frame.height-20 )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = NewsTappedVC(nibName: "NewsTappedVC", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //scroll
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
    
}

//CarouselView
/// Osha indexpath ga keganda collectionni cell i kattalashib asosiy cellga aylanishi kerak
extension NewsVC {
    public func configureView(with data: [CarouselData]) {
        let cellPadding = (self.collection_view.frame.width - 300) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: 300, height: 400)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = self.collection_view.frame.width - 300
        
        collection_view.collectionViewLayout = carouselLayout
        carouselData = data
        collection_view.reloadData()
    }
}

//MARK: - Helpers
private extension NewsVC {
    func getCurrentPage() -> Int {
        
        let visibleRect = CGRect(origin: collection_view.contentOffset, size: collection_view.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = collection_view.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        
        return currentPage
    }
}

//MARK: -
extension NewsVC {
    func scrollToItem() {
        let visibleItems: NSArray = self.collection_view.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        //            let nextItem : IndexPath = IndexPath(item: 1, section: 0)
        if nextItem.row < imgArr.count {
            let cellPadding = (self.collection_view.frame.width - 300) / 2
            let carouselLayout = UICollectionViewFlowLayout()
            carouselLayout.itemSize = CGSize(width: 600, height: 400)
            carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
            carouselLayout.minimumLineSpacing = self.collection_view.frame.width - 300
            
            collection_view.collectionViewLayout = carouselLayout
            collection_view.reloadData()
            
            //        self.collection_view.scrollToItem(at: nextItem, at: .left, animated: true)
        }
    }
}


//MARK: - GetBanner
extension NewsVC {
    func getBanner() {
        if let token = Cache.getUserToken() {
            print(token)
            let headers : HTTPHeaders = [
                "Authorization": "\(token)"
            ]
            Networking.fetchRequest(urlAPI: API.getBannerUrl, method: .get, params: nil, encoding: JSONEncoding.default, headers: headers) { [self] data in
                if let data = data {
                    Loader.start()
                    print(data)
                    if data["code"].intValue == 0 {
                        Loader.start()
                        let responseData = data["data"]
                        for dat in 0..<responseData.count {
                            let banner = GetBannerNews(_id: responseData[dat]["_id"].stringValue, created_at:  responseData[dat]["created_at"].stringValue, title: responseData[dat]["title"].stringValue, content: responseData[dat]["content"].stringValue, image: responseData[dat]["image"].stringValue)
                            self.bannerArr.append(banner)
                            print("bannerArr= ", bannerArr)
                            self.collection_view.reloadData()
                        }}else if data["code"].intValue == 50012 {
                            Loader.stop()
                            Alert.showAlert(forState: .error, message: "Banner bo'sh")
                        }else {
                            Loader.stop()
                            Alert.showAlert(forState: .error, message: "Nomalum xato")
                        }
                }
            }
        }
    }
}


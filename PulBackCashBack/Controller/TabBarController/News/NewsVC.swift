//
//  NewsVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 04/11/21.
//

import UIKit
import  Alamofire
import SwiftyJSON
import ScalingCarousel
import SnapKit

class NewsVC: UIViewController {
    
    @IBOutlet weak var collection_view: UICollectionView!
    
    @IBOutlet weak var collectionTop: NSLayoutConstraint!
    @IBOutlet weak var collectionBottom: NSLayoutConstraint!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    // MARK: - Properties
    var bannerArr : [GetBannerNews] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBanner()
        setupCollectionView()
        setupConstraint()
    }
    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
    func setupConstraint() {
        if isSmalScreen568 {
            collectionTop.constant = 30
            collectionBottom.constant = 30
        }else if isSmalScreen736 {
            collectionTop.constant = 50
            collectionBottom.constant = 50
        }else {
            collectionTop.constant = 70
            collectionBottom.constant = 70
        }
    }
}

//MARK: - CollectionView delegate methods
extension NewsVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setupCollectionView() {
        self.collection_view.delegate = self
        self.collection_view.dataSource = self
        self.collection_view.register(NewsCell.nib(), forCellWithReuseIdentifier: NewsCell.identifier)
        collection_view.contentInsetAdjustmentBehavior = .always
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
            cell.containerView.backgroundColor = UIColor.systemGray6
            cell.updateCell(img: bannerArr[indexPath.row].image, created_at: bannerArr[indexPath.row].created_at, content: bannerArr[indexPath.row].title)
            
        }else {
            self.collection_view.isHidden = true
            Loader.start()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = NewsTappedVC(nibName: "NewsTappedVC", bundle: nil)
        vc.getBanner = bannerArr[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
//CollectionView flowLayout
extension NewsVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collection_view.frame.width-50, height: self.collection_view.frame.height-50)
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
                            
                            //date Formatter
                            let formatter = DateFormatter()
                            let input = responseData[dat]["created_at"].stringValue
                            formatter.locale = Locale(identifier: "en_US")
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            if let date = formatter.date(from: input) {
                                let banner = GetBannerNews(_id: responseData[dat]["_id"].stringValue, created_at:  "\(date)", title: responseData[dat]["title"].stringValue, content: responseData[dat]["content"].stringValue, image: responseData[dat]["image"].stringValue)
                                self.bannerArr.append(banner)
                                print("bannerArr= ", bannerArr)
                                self.collection_view.reloadData()
                            }
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


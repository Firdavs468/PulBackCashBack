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
class CodeCell: ScalingCarouselCell {
    
    var image : UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleToFill
        i.image = UIImage(named: "news")
        return i
    }()
    
    var dateLabel : UILabel = {
        let l = UILabel()
        l.text = "21.06.2021"
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    var titleLabel : UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        //        l.text = "21.06.2021"
        l.textAlignment = .center
        return l
    }()
    
    var contentLabel : UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.text = "KOLBERG GROUP – многопрофильная группа компаний, ориентированных на дистрибьюцию товаров"
        l.textAlignment = .center
        return l
    }()
    
    var labelsStackView : UIStackView = {
        let s = UIStackView()
        s.spacing = 0
        s.alignment = .fill
        s.distribution = .fill
        s.axis = .vertical
        return s
    }()
    
    var scrollView : UIScrollView = {
        let s = UIScrollView()
        return s
    }()
    
    
    var titleLabelText : String? {
        get {
            return titleLabel.text
        }set(newValue) {
            if let titleText = newValue {
                titleLabel.text = titleText
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        mainView = UIView(frame: contentView.bounds)
        contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        mainView.addSubview(image)
        image.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.8)
            make.left.right.top.equalToSuperview().offset(0)
        }
        
        mainView.addSubview(labelsStackView)
        labelsStackView.addArrangedSubview(dateLabel)
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(contentLabel)
        labelsStackView.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview().offset(0)
        }
    }
    func updateCell(image:UIImage) {
        self.image.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class NewsVC: UIViewController {
    
    @IBOutlet weak var collection_view: ScalingCarouselView!
    
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
        if collection_view != nil {
            collection_view.deviceRotated()
        }
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
        self.collection_view.register(CodeCell.self, forCellWithReuseIdentifier: "cell")
        collection_view.contentInsetAdjustmentBehavior = .always
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if !bannerArr.isEmpty {
        //            return bannerArr.count
        //        }else {
        //            return 0
        //        }
        //
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        let cell = self.collection_view.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as! NewsCell
        //        if !bannerArr.isEmpty {
        //            self.collection_view.isHidden = false
        //            Loader.stop()
        //            cell.updateCell(img: bannerArr[indexPath.row].image, date: bannerArr[indexPath.row].created_at, content: bannerArr[indexPath.row].content, title: bannerArr[indexPath.row].title)
        //
        //        }else {
        //            self.collection_view.isHidden = true
        //            Loader.start()
        //        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let scalingCell = cell as? ScalingCarouselCell {
            //            scalingCell.mainView.layer.cornerRadius = scalingCell.mainView.frame.height/20
            //            scalingCell.mainView.layer.shadowColor = UIColor.gray.cgColor
            //            scalingCell.mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
            //            scalingCell.mainView.layer.shadowOpacity = 0.4
            //            scalingCell.mainView.layer.shadowRadius = 3
            scalingCell.mainView.backgroundColor = .systemGray6
        }
        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = NewsTappedVC(nibName: "NewsTappedVC", bundle: nil)
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


//
//  ProductsVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 06/11/21.
//

import UIKit
import BarcodeScanner
import Alamofire
import SwiftyJSON
import SDWebImage

class ProductsVC: UIViewController {
    
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet weak var scanerButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var qrCodeLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var goToBeeto: UIButton!
    
    var getPrices : [Prices] = []
    var itemGetByBarCode : ItemGetByBarCode!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        getBarCodeAPI()
    }
    
    @IBAction func goToBeetoButtonPressed(_ sender: Any) {
        openApp()
    }
    
    @IBAction func scanerButtonPressed(_ sender: Any) {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        present(viewController, animated: true, completion: nil)
    }
    
    func setupUI() {
        scanerButton.layer.cornerRadius = scanerButton.frame.height/6
        scanerButton.backgroundColor = AppColor.appColor
        goToBeeto.setTitleColor(AppColor.appColor, for: .normal)
        goToBeeto.layer.cornerRadius = goToBeeto.frame.height/6
        goToBeeto.layer.borderWidth = 2
        goToBeeto.layer.borderColor = AppColor.appColor.cgColor
        qrCodeLabel.textColor = AppColor.appColor
        numberLabel.textColor = AppColor.appColor
    }
}

//MARK: - CollectionView delegate methods
extension ProductsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        self.collection_view.delegate = self
        self.collection_view.dataSource = self
        self.collection_view.register(ProductsCell.nib(), forCellWithReuseIdentifier: ProductsCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !getPrices.isEmpty {
            return getPrices.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collection_view.dequeueReusableCell(withReuseIdentifier: ProductsCell.identifier, for: indexPath) as! ProductsCell
        if !getPrices.isEmpty {
            self.collection_view.isHidden = false
            Loader.stop()
            cell.updateCell(summa: "\(getPrices[indexPath.row].price)", count: "\(getPrices[indexPath.row].from)")
        }else {
            Loader.start()
            self.collection_view.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.collection_view.frame.width+30)/3 , height:self.collection_view.frame.height-10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

//MARK: - Bar Code API
extension ProductsVC {
    func getBarCodeAPI() {
        let headers : HTTPHeaders = [
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZV9udW1iZXIiOiIrOTk4OTcxNTYwOTQ5Iiwicm9sZSI6ImNsaWVudCIsImlhdCI6MTYzMzUzODU2MCwiZXhwIjoxNjY1MDk2MTYwfQ.SzihTanBR0eugeEcRnsxiLf7h1CMD8CFJ_dKiQb0aeM",
            "Content-Type": "application/json"
        ]
        let param : [String:Any] = [
            "barcode" : Cache.getUserDefaultsString(forKey: Keys.bar_code) //"8714599107492" 
        ]
        Networking.fetchRequest(urlAPI: API.barCodUrl, method: .post, params: param, encoding: JSONEncoding.default, headers: headers) { [self] data in
            if let data = data {
                
                print(data)
                let itemData = data["data"]
                let dataPrices = data["data"]["prices"]
                
                if data["code"].intValue == 0 {
                    for i in 0..<dataPrices.count {
                        let prices = Prices(from: dataPrices[i]["from"].intValue, price: dataPrices[i]["price"].intValue)
                        getPrices.append(prices)
                        self.collection_view.reloadData()
                    }
                    
                    //item data
                    numberLabel.text = "#\(itemData["sku"].intValue)"
                    qrCodeLabel.text = Cache.getUserDefaultsString(forKey: Keys.bar_code)
                    
                    itemImage.sd_setImage(with: URL(string: itemData["representation"].stringValue), placeholderImage: UIImage(named: "noitem"))
                    
                    let img = itemData["representation"].stringValue
                    let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? img
                    self.itemImage.sd_setImage(with: URL(string:urlString))
                    
                    itemNameLabel.text = itemData["name"].stringValue
                   
                    
                }else if data["code"].intValue == 12000 {
                    dismiss(animated: true, completion: nil)
                    Alert.showAlert(forState: .error, message: "Товар не найден")
                }
            }
        }
    }
}

//MARK: - BarCode delegate
extension ProductsVC: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code)
        //        controller.reset()
        Cache.saveUserDefaults(code, forKey: Keys.bar_code)
        let vc = ProductsVC(nibName: "ProductsVC", bundle: nil)
        present(vc, animated: true, completion: nil)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error){
        print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

//curl --location --request POST 'http://pos.inone.uz/client-api/item/get-by-barcode' \
//--header 'Authorization:   Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZV9udW1iZXIiOiIrOTk4OTcxNTYwOTQ5Iiwicm9sZSI6ImNsaWVudCIsImlhdCI6MTYzMzUzODU2MCwiZXhwIjoxNjY1MDk2MTYwfQ.SzihTanBR0eugeEcRnsxiLf7h1CMD8CFJ_dKiQb0aeM' \
//--header 'Content-Type: application/json' \
//--data-raw '{
//    "barcode":"4780058880507"
//}'
//{
//    "code": 0,
//    "message": "Success",
//    "data": {
//        "_id": "5f5643cedce4e706c0629d67",
//        "name": "Влажные салфетки освежающие Elma 100шт ",
//        "sold_by": "each",
//        "sku": 3070,
//        "barcode": [
//            "4780058880507"
//        ],
//        "representation": "http://pos.inone.uz/api/static/db752873d29c5d3180ce0f77f0e1249dtttttttt.png",
//        "representation_type": "image",
//        "price": 0,
//        "prices": [
//            {
//                "from": 1,
//                "price": 10350
//            },
//            {
//                "from": 2,
//                "price": 9950
//            },
//            {
//                "from": 12,
//                "price": 9450
//            }
//        ],
//        "in_stock": 125
//    }
//}


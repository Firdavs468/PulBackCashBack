//
//  QRCodeVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit
import BarcodeScanner

class QRCodeVC: UIViewController {
    
    @IBOutlet weak var svgImage: UIImageView!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var qrCodeContainerView: UIView!
    @IBOutlet weak var scannerContainerView: UIView!
    @IBOutlet weak var barCodeLabel: UILabel!
    @IBOutlet weak var scanerButton: UIButton!
    @IBOutlet weak var containerImage: UIImageView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerView()
//        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        barCodeLabel.text = Cache.getUserDefaultsString(forKey: Keys.bar_code)
    }
    
    @IBAction func scanerButtonPressed(_ sender: Any) {
        //        let viewController = BarcodeScannerViewController()
        //        viewController.codeDelegate = self
        //        viewController.errorDelegate = self
        //        viewController.dismissalDelegate = self
        //        present(viewController, animated: true, completion: nil)
        let vc = ProductsVC(nibName: "ProductsVC", bundle: nil)
        self.present(vc, animated: true)
        
    }
        
    //setup view
    func cornerView() {
        containerImage.layer.cornerRadius = containerImage.frame.height/22
        qrCodeContainerView.layer.shadowColor = UIColor.systemGray.cgColor
        qrCodeContainerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        qrCodeContainerView.layer.shadowRadius = 2
        qrCodeContainerView.layer.shadowOpacity = 0.5
        scannerContainerView.layer.cornerRadius = scannerContainerView.frame.height/25
        qrCodeImage.layer.cornerRadius = qrCodeImage.frame.height/20
        qrCodeContainerView.layer.cornerRadius = qrCodeContainerView.frame.height/10
        scanerButton.layer.cornerRadius = scanerButton.frame.height/2.25
        
        //setup constraint
        if isSmalScreen568 {
            containerHeight.constant = 0.5
        }else {
            containerHeight.constant = 0.4
        }
    }
}

//MARK: - Barcode Scanner
extension QRCodeVC: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code)
        Cache.saveUserDefaults(code, forKey: Keys.bar_code)
        controller.reset()
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error){
        print(error)
        
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}


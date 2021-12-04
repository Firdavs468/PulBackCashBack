//
//  ReviewsVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 04/11/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Photos
import AVFoundation

//https://youtu.be/1-xGerv5FOk
class ReviewsVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var requiredFieldLbl: UILabel!
    
    var cellLabelArrayRus = [
        "Выберите тип обращения*",
        "Выберите филиал",
        "Прикрепить файл"
    ]
    
    var cellLabelArrayUzb = [
        "So'rov turini tanlang *",
        "Filialni tanlang",
        "Faylni biriktirish"
    ]
    
    var feedBackTypeUzb = [
        "Savol",
        "Shikoyat",
        "Takliflar",
        "Ish qidirish"
    ]
    
    var feedBackTypeRus = [
        "Вопрос",
        "Жалоба",
        "Предложения",
        "ишу работу"
    ]
    
    var reviewsCellButtonImage = [
        UIImage(systemName: "chevron.right"),
        UIImage(systemName: "chevron.right"),
        UIImage(named: "upload")
    ]
    
    var selectedImage : UIImage? = nil
    var getAddress = [String]()
    
    let feedBackType = Int(Cache.getUserDefaultsString(forKey: Keys.feedbackType))
    let branch = Int(Cache.getUserDefaultsString(forKey: "selectbranch"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = AppLanguage.getTitle(type: .reviewsNav)
        cornerView()
        setupTableView()
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        //        view.addGestureRecognizer(tapGesture)
        getBranch()
        appLanguage()
        textView.insertTextPlaceholder(with: CGSize(width: 10, height: 10))
        textView.delegate = self
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if textView.text.isEmpty {
            Alert.showAlert(forState: .error, message: "Text yozing")
        };if branch == nil {
            Alert.showAlert(forState: .error, message: AppLanguage.getTitle(type: .choosePlaceAlertTitle))
        };if feedBackType == nil {
            Alert.showAlert(forState: .error, message: AppLanguage.getTitle(type: .feedBackTypeAlertTitle))
        }else {
            createFeedback()
        }
        
    }
    
    //    @objc func hideKeyboard() {
    //        self.view.endEditing(true)
    //    }
    
    func cornerView() {
        sendButton.layer.borderWidth = 2
        sendButton.layer.cornerRadius = sendButton.frame.height/6
        sendButton.layer.borderColor = AppColor.appColor.cgColor
        
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = textView.frame.height/7
    }
    
    //change app language
    func appLanguage() {
        
        requiredFieldLbl.text = AppLanguage.getTitle(type: .feedBackFieldLbl)
        textView.text = AppLanguage.getTitle(type: .messagePlc)
        sendButton.setTitle(AppLanguage.getTitle(type: .sendBtn), for: .normal)
    }
}

//MARK: - TableView delegate methods
extension ReviewsVC : UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        self.table_view.delegate = self
        self.table_view.dataSource = self
        self.table_view.tableFooterView = UIView()
        self.table_view.separatorStyle = .none
        self.table_view.register(ReviewsCell.nib(), forCellReuseIdentifier: ReviewsCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellLabelArrayRus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table_view.dequeueReusableCell(withIdentifier: ReviewsCell.identifier, for: indexPath) as! ReviewsCell
        
        cell.selectionStyle = .none
        let language = Cache.getUserDefaultsString(forKey: Keys.language)
        
        if language == "uz" {
            cell.updateCell(lbl: cellLabelArrayUzb[indexPath.row], buttonImage: reviewsCellButtonImage[indexPath.row]!)
        }else {
            cell.updateCell(lbl: cellLabelArrayRus[indexPath.row], buttonImage: reviewsCellButtonImage[indexPath.row]!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            feedbackTypeAlert()
        }else if indexPath.row == 1 {
            selectBranchesAlert()
        }else {
            photoLibraryAlert()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSmalScreen568 {
            return 60
        }else if isSmalScreen736 {
            return 60
        }else {
            return 70
        }
    }
    
}


//MARK: - Create feedback API
extension ReviewsVC {
    func createFeedback() {
        if let token = Cache.getUserToken() {
            
            let headers : HTTPHeaders = [
                "Authorization": "\(token)",
                "Content-Type": "application/json"
            ]
            
            let param : [String:Any] = [
                "message": textView.text as Any,
                "feedback_type": feedBackType!,
                "branch": branch!,
                "image": "http://89.223.71.112:9494/image?path=temp-images/upload-3367296366.png"
            ]
            
            //            AF.upload(multipartFormData: { [self] multipartFormData in
            //                multipartFormData.append("homeId".data(using: String.Encoding.utf8)!, withName: "userHomeId")
            //                if let imageData = selectedImage?.jpegData(compressionQuality: CGFloat(1.0)) {
            //                    multipartFormData.append(imageData, withName: "logo", fileName: "file.jpg", mimeType: "image/jpg")
            //                }
            //            }, with: API.EndPoints.getImage as! URLRequestConvertible).responseJSON { response in
            //                print(response.data)
            //            }
            Networking.fetchRequest(urlAPI: API.feedbackUrl, method: .post, params: param, encoding: JSONEncoding.default, headers: headers) { [self] data in
                if let data = data {
                    Loader.start()
                    print(data)
                    if data["code"].intValue == 0 {
                        
                        Loader.stop()
                        textView.text = ""
                        DoneAlert.showAlert(title: AppLanguage.getTitle(type: .feedBackSuccess))
                    }else if data["code"].intValue == 50003 {
                        
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Неизвестная структура")
                    }else if data["code"].intValue == 50019 {
                        
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Филиал не найден")
                    }else if data["code"].intValue == 50020 {
                        
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Не удалось отправить отзыв в Telegram")
                    }else {
                        
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "неизвестная ошибка")
                    }
                }
            }
        }
    }
}


//create alerts
extension ReviewsVC {
    //feedback type alert
    func feedbackTypeAlert() {
        let typeAlert = UIAlertController(title: AppLanguage.getTitle(type: .feedBackTypeAlertTitle), message: nil, preferredStyle: .actionSheet)
        for i in 0..<feedBackTypeUzb.count {
            
            let language = Cache.getUserDefaultsString(forKey: Keys.language)
            
            if language == "uz" {
                typeAlert.addAction(UIAlertAction(title: feedBackTypeUzb[i], style: .default, handler: { _ in
                    Cache.saveUserDefaults("\(i)", forKey: Keys.feedbackType)
                }))
            }else {
                typeAlert.addAction(UIAlertAction(title: feedBackTypeRus[i], style: .default, handler: { _ in
                    Cache.saveUserDefaults("\(i)", forKey: Keys.feedbackType)
                }))
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let tapped = Int(Cache.getUserDefaultsString(forKey: Keys.feedbackType))
        
        typeAlert.addAction(cancel)
        
        guard let tapped = tapped else {
            return present(typeAlert, animated: true, completion: nil)
        }
        
        cellLabelArrayRus[0] = typeAlert.actions[tapped].title!
        cellLabelArrayUzb[0] = typeAlert.actions[tapped].title!
        
        self.table_view.reloadData()
        
        typeAlert.actions[tapped].setValue(UIColor.systemGray, forKey: "titleTextColor")
        present(typeAlert, animated: true, completion: nil)
    }
    
    
    //    select branches alert
    func selectBranchesAlert() {
        let branchAlert = UIAlertController(title: AppLanguage.getTitle(type: .choosePlaceAlertTitle), message: nil, preferredStyle: .actionSheet)
        
        if !getAddress.isEmpty {
            Loader.stop()
            for i in 0..<getAddress.count {
                branchAlert.addAction(UIAlertAction(title: "\(getAddress[i])", style: .default, handler: { _ in
                    Cache.saveUserDefaults("\(i)", forKey: "selectbranch")
                }))
            }
        }else {
            Loader.start()
        }
        
        branchAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let branch = Int(Cache.getUserDefaultsString(forKey: "selectbranch"))
        guard let branch = branch else {
            return present(branchAlert, animated: true, completion: nil)
        }
        cellLabelArrayUzb[1] = branchAlert.actions[branch].title!
        cellLabelArrayRus[1] = branchAlert.actions[branch].title!
        self.table_view.reloadData()
        branchAlert.actions[branch].setValue(UIColor.systemGray, forKey: "titleTextColor")
        present(branchAlert, animated: true, completion: nil)
    }
}


//open imagePicker controller
extension ReviewsVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func photoLibraryAlert() {
        
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamer()
        }
        let photolibrary = UIAlertAction(title: "PhotoLibrary", style: .default) { _ in
            self.openGallery()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(camera)
        alert.addAction(photolibrary)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openGallery() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary //.photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func openCamer() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .camera //.photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        selectedImage = tempImage
        reviewsCellButtonImage.removeLast()
        reviewsCellButtonImage.append(tempImage)
        self.table_view.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


//get branch
extension ReviewsVC {
    func getBranch() {
        
        guard let token = Cache.getUserToken() else {return}
        let headers : HTTPHeaders = [
            "Authorization": "\(token)"
        ]
        Networking.fetchRequest(urlAPI: API.branchesUrl, method: .get, params: nil, encoding: JSONEncoding.default, headers: headers) { [self] data in
            if let data = data {
                print(data)
                if data["code"].intValue == 0 {
                    let jsonData = JSON(data["data"])
                    for i in 0..<jsonData.count {
                        let branches = Branches(_id: jsonData[i]["_id"].intValue,
                                                name: jsonData[i]["name"].stringValue,
                                                logo: jsonData[i]["logo"].stringValue,
                                                address: jsonData[i]["address"].stringValue,
                                                open_at: jsonData[i]["open_at"].stringValue,
                                                close_at: jsonData[i]["close_at"].stringValue,
                                                contact: jsonData[i]["contact"].stringValue,
                                                lat: jsonData[i]["lat"].doubleValue,
                                                long: jsonData[i]["long"].doubleValue)
                        getAddress.append(branches.address)
                    }
                }
            }
        }
    }
}


//textView delegate
extension ReviewsVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.systemGray3.cgColor
    }
}

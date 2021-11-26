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
class ReviewsVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var table_view: UITableView!
    
    let cellLabelArray = [
        "Выберите тип обращения*",
        "Выберите филиал",
        "Прикрепить файл"
    ]
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Отзывы"
        cornerView()
        setupTableView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        textView.insertTextPlaceholder(with: CGSize(width: 10, height: 10))
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        createFeedback()
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func cornerView() {
        sendButton.layer.borderWidth = 2
        sendButton.layer.cornerRadius = sendButton.frame.height/6
        sendButton.layer.borderColor = AppColor.appColor.cgColor
        
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = textView.frame.height/7
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
        cellLabelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table_view.dequeueReusableCell(withIdentifier: ReviewsCell.identifier, for: indexPath) as! ReviewsCell
        cell.selectionStyle = .none
        cell.updateCell(lbl: cellLabelArray[indexPath.row], buttonImage: AppIcon.reviewsCellButtonImage[indexPath.row]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table_view.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSmalScreen568 {
            return 50
        }else if isSmalScreen736 {
            return 60
        }else {
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
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
                "feedback_type": 1,
                "branch": 1,
                "image": "http://89.223.71.112:9494/image?path=temp-images/upload-3367296366.png"
            ]
            Networking.fetchRequest(urlAPI: API.feedbackUrl, method: .post, params: param, encoding: JSONEncoding.default, headers: headers) { [self] data in
                if let data = data {
                    Loader.start()
                    print(data)
                    if data["code"].intValue == 0 {
                        Loader.stop()
                        textView.text = ""
                        Alert.showAlert(forState: .success, message: "Идея была успешно отправлена")
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

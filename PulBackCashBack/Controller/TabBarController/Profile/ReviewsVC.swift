//
//  ReviewsVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 04/11/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReviewsVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var table_view: UITableView!
    
    let cellLabelArray = [
        "Выберите тип обращения*",
        "Выберите филиал",
        "Прикрепить файл"
    ]
    let cellButtonImage = [
        UIImage(systemName: "chevron.right"),
        UIImage(systemName: "chevron.right"),
        UIImage(named: "upload")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Отзывы"
        cornerView()
        setupTableView()
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        createFeedback()
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
        cell.updateCell(lbl: cellLabelArray[indexPath.row], buttonImage: cellButtonImage[indexPath.row]!)
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
            Networking.fetchRequest(urlAPI: API.feedbackUrl, method: .post, params: param, encoding: JSONEncoding.default, headers: headers) { data in
                if let data = data {
                    print(data)
                }
            }
        }
    }
}

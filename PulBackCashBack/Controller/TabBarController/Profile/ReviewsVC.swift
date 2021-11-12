//
//  ReviewsVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 04/11/21.
//

import UIKit

class ReviewsVC: UIViewController {
    
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
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func cornerView() {
        sendButton.layer.borderWidth = 2
        sendButton.layer.cornerRadius = sendButton.frame.height/6
        sendButton.layer.borderColor = UIColor(red: 0.278, green: 0.749, blue: 0.639, alpha: 1).cgColor
        
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellLabelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = cellLabelArray[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
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

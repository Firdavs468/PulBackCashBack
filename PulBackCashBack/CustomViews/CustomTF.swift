//
//  CustomTF.swift
//  Bananjon
//
//  Created by Firdavs Zokirov  on 11/09/21.
//

import Foundation
import  UIKit
import  SnapKit

class CustomTF:UIView {
    private var rightButton = UIButton()
    private let  titleIconIV = UIImageView()
    private let  leftIconIV = UIImageView()
    //    private let  rightIconIV = UIImageView()
    private let textField = UITextField()
    private let titleLbl = UILabel()
    private let containerView = UIView()
    private let verticalStackView = UIStackView(views: [], axis: .vertical, spacing: 7, alignment: .fill, distribution: .fill)
    private let horizontalStackView = UIStackView(views: [], axis: .horizontal, spacing: 7, alignment: .center, distribution: .fill)
    private let topHorizontalStackView = UIStackView(views: [], axis: .horizontal, spacing: 7, alignment: .fill, distribution: .fill)
    
    
    var placeholder : String?{
        get {
            return textField.placeholder
        }
        set(newValue){
            if let plc = newValue{
                textField.placeholder = plc
            }
        }
    }
    
    var text : String?{
        get {
            return textField.text
        }
        set(newValue){
            if let txt = newValue{
                textField.text = txt
            }
        }
    }
    
    var isEnabled : Bool? {
        get {
            return textField.isEnabled
        }
        set(newValue) {
            if let enabled = newValue {
                textField.isEnabled = enabled
            }
        }
    }
    
    var title : String?{
        get {
            return titleLbl.text
        }
        set(newValue){
            if let text = newValue{
                titleLbl.text = text
                topHorizontalStackView.addArrangedSubview(titleLbl)
                verticalStackView.insertArrangedSubview(topHorizontalStackView, at:0)
            }
        }
    }
    
    
    var title_icon : UIImage?{
        get {
            return self.titleIconIV.image
        }set(newValue){
            if let img = newValue{
                titleIconIV.image = img
                topHorizontalStackView.insertArrangedSubview(titleIconIV, at: 0)
            }
        }
    }
    
    //    var right_icon : UIImage?{
    //        get {
    //            return self.rightIconIV.image
    //        }set(newValue){
    //            if let img = newValue{
    //                rightIconIV.image = img
    //                horizontalStackView.addArrangedSubview(rightIconIV)
    //            }
    //        }
    //    }
    
    var rightButtonIcon : UIImage? {
        get {
            return self.rightButton.imageView?.image
        }set(newValue){
            if let img = newValue{
                //                rightButton.tintColor = .systemGray
                rightButton.setImage(img, for: .normal)
                horizontalStackView.addArrangedSubview(rightButton)
            }
        }
    }
    
    var rightButtonTintColor : UIColor? {
        get {
            return self.rightButton.tintColor
        }set(newValue) {
            if let color = newValue {
                rightButton.tintColor = color
            }
        }
    }
    
    var left_icon : UIImage?{
        get {
            return self.leftIconIV.image
        }set(newValue){
            if let img = newValue{
                leftIconIV.image = img
                horizontalStackView.insertArrangedSubview(leftIconIV, at: 0)
            }
        }
    }
    
    var delegate : UITextFieldDelegate? {
        get {
            return self.textField.delegate
        }set(newValue) {
            if let del = newValue {
                textField.delegate = del
            }
        }
    }
    
    var keyboardType : UIKeyboardType? {
        get {
            return self.textField.keyboardType
        }set(newValue) {
            if let keyboard = newValue {
                textField.keyboardType = keyboard
            }
        }
    }
    
    var textContentType : UITextContentType? {
        get {
            return self.textField.textContentType
        }set(newValue) {
            if let type = newValue {
                textField.textContentType = type
            }
        }
    }
    
    var textInputView : UIView? {
        get {
            return self.textField.inputView
        }set(newValue) {
            if let input = newValue {
                textField.inputView = input
            }
        }
    }
    
    var accessoryView : UIView? {
        get {
            return self.textField.inputAccessoryView
        }set(newValue) {
            if let accesory = newValue {
                textField.inputAccessoryView = accesory
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    
    func isEmpty() ->Bool{
        if textField.text!.isEmpty{
            containerView.layer.borderColor = UIColor.red.cgColor
        }else{
            containerView.layer.borderColor = UIColor.lightGray.cgColor
        }
        return textField.text!.isEmpty
    }
    
    
    func setupUI(){
        
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        containerView.layer.borderWidth = 0
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 7
        containerView.backgroundColor = .systemGray6
        
        self.backgroundColor = .clear
        
        titleIconIV.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
        }
        
        leftIconIV.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
        }
        
        //        rightIconIV.snp.makeConstraints { (make) in
        //            make.width.height.equalTo(24)
        //        }
        
        rightButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
        }
        
        verticalStackView.addArrangedSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            if isSmalScreen568 {
                make.height.equalTo(35)
            }else if isSmalScreen736 {
                make.height.equalTo(40)
            }else {
                make.height.equalTo(46)
            }
        }
        addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        horizontalStackView.addArrangedSubview(textField)
        containerView.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView).inset(UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 5))
        }
    }
    
    @objc func rightButtonTapped() {
        textField.text = ""
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

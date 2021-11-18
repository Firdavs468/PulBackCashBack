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



class ZoomAndSnapFlowLayout: UICollectionViewFlowLayout {

    let activeDistance: CGFloat = 200
    let zoomFactor: CGFloat = 0.3

    override init() {
        super.init()

        scrollDirection = .horizontal
        minimumLineSpacing = 20
        itemSize = CGSize(width: 150, height: 150)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        guard let collectionView = collectionView else { fatalError() }
        let verticalInsets = (collectionView.frame.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - itemSize.height) / 2
        let horizontalInsets = (collectionView.frame.width - collectionView.adjustedContentInset.right - collectionView.adjustedContentInset.left - itemSize.width) / 2
        sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)

        super.prepare()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)

        // Make the cells be zoomed when they reach the center of the screen
        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = distance / activeDistance

            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                attributes.zIndex = Int(zoom.rounded())
            }
        }

        return rectAttributes
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }

        // Add some snapping behaviour so that the zoomed cell is always centered
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

}

class Course {
    
    var title = ""
    var imageCourse : UIImage
    var details = ""
    
    
    init(title:String , imageCourse :UIImage , details : String  ) {
        self.title = title
        self.imageCourse = imageCourse
        self.details = details
        
    }
    
    static func FetchCourse () -> [Course]{
        
        return [ Course(title: "The Art of Sketching ", imageCourse: UIImage(named: "1" )!, details: "Use your sketchbook to find your own drawing style and share it with others ") ,
                 Course(title: " Watercolor Techniques", imageCourse: UIImage(named: "2" )!, details: "Paint with watercolors in a technical and creative way") ,
                 Course(title: "llustration Techniques ", imageCourse: UIImage(named: "3" )!, details: "Create an artist’s portfolio and develop your own universe of pictorial resources ") ,
                 Course(title: " Digital Illustration ", imageCourse: UIImage(named: "4" )!, details: " Learn to portray spaces in a semi-realistic way and create a bridge ")
        
 
        ]
        
    }
}





//@POST("http://pos.inone.uz/client-api/item/get-by-barcode")
//suspend fun retrieveItem(
//    @Body request: ItemRequest,
//    @Header("Authorization") token: String = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZV9udW1iZXIiOiIrOTk4OTcxNTYwOTQ5Iiwicm9sZSI6ImNsaWVudCIsImlhdCI6MTYzMzUzODU2MCwiZXhwIjoxNjY1MDk2MTYwfQ.SzihTanBR0eugeEcRnsxiLf7h1CMD8CFJ_dKiQb0aeM"
//): ItemResponse
//
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

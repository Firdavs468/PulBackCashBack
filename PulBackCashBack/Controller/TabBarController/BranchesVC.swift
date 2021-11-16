//
//  BranchesVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit
import GoogleMaps

let primaryColor = UIColor(red:0.00, green:0.19, blue:0.56, alpha:1.0)

let secondaryColor = UIColor(red:0.89, green:0.15, blue:0.21, alpha:1.0)

struct SSPlace {
    var name: String?
    var address: String?
    var coordinates: (lat: Double, lng: Double)?
}

let customMarkerWidth: Int = 50
let customMarkerHeight: Int = 55

class BranchesVC: UIViewController {
    
    var places = [SSPlace]()
    
    var markers = [GMSMarker]()
    
    var mapView: GMSMapView = {
        let v = GMSMapView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapView)
        setupMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.focusMapToShowAllMarkers()
    }
    
    //setup MapView()
    func setupMapView() {
        mapView.padding = UIEdgeInsets(top: 72, left: 25, bottom: 0, right: 25)
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.delegate = self
        places.append(SSPlace(name:  "Tiin Market Sayram", address: "Sayram St, 5/92, M.Ulugbek province", coordinates: (lat: 41.31130, lng: 69.280136)))
        self.addMarkers()
    }
    
    func addMarkers() {
        markers.removeAll()
        for (index, place) in places.enumerated() {
            let marker = GMSMarker()
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), imageName: place.name, borderColor: primaryColor, tag: index)
            //            marker.iconView=customMarker
            marker.iconView = customMarker
            marker.position = CLLocationCoordinate2D(latitude: place.coordinates!.lat, longitude: place.coordinates!.lng)
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0)
            marker.map = self.mapView
            marker.zIndex = Int32(index)
            marker.userData = place
            markers.append(marker)
        }
    }
    
    func focusMapToShowAllMarkers() {
        if let firstLocation = markers.first?.position {
            var bounds =  GMSCoordinateBounds(coordinate: firstLocation, coordinate: firstLocation)
            
            for marker in markers {
                bounds = bounds.includingCoordinate(marker.position)
            }
            let update = GMSCameraUpdate.fit(bounds, withPadding: 10)
            self.mapView.animate(with: update)
        }
    }
}

extension BranchesVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let imgName = customMarkerView.imageName
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), imageName: imgName, borderColor: secondaryColor, tag: customMarkerView.tag)
        marker.iconView = customMarker
        print("didTap marker")
        return false
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let place = marker.userData as? SSPlace {
            marker.tracksInfoWindowChanges = true
            let infoWindow = CustomMarkerInfoWindow()
            infoWindow.tag = 5555
            let height: CGFloat = 200
            let paddingWith = self.view.frame.width - 40
            infoWindow.frame = CGRect(x: self.view.frame.width-100, y: self.view.frame.height-20, width: getEstimatedWidthForMarker(place, padding: paddingWith) + paddingWith, height: height)
            infoWindow.imgView.image = UIImage(named: place.name!)
            infoWindow.txtLabel.text = place.name
            infoWindow.subtitleLabel.text = place.address
            return infoWindow
        }
        return nil
    }
    
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let imgName = customMarkerView.imageName
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), imageName: imgName, borderColor: primaryColor, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
    func getEstimatedWidthForMarker(_ place: SSPlace, padding: CGFloat) -> CGFloat {
        var estimatedWidth: CGFloat = 0
        let infoWindow = CustomMarkerInfoWindow()
        let maxWidth = (UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width * 0.7 : UIScreen.main.bounds.width * 0.8) - padding
        let titleWidth = (place.name ?? "").width(withConstrainedHeight: infoWindow.txtLabel.frame.height, font: infoWindow.txtLabel.font)
        let subtitleWidth = (place.address ?? "").width(withConstrainedHeight: infoWindow.subtitleLabel.frame.height, font: infoWindow.subtitleLabel.font)
        estimatedWidth = min(maxWidth, max(titleWidth, subtitleWidth))
        return estimatedWidth
    }
    
}

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}


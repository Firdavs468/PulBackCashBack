//
//  BranchesVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

let primaryColor = UIColor(red:0.00, green:0.19, blue:0.56, alpha:1.0)

let secondaryColor = UIColor(red:0.89, green:0.15, blue:0.21, alpha:1.0)

struct SSPlace {
    var name: String?
    var address: String?
    var coordinates: (lat: Double, lng: Double)?
}

let customMarkerWidth: Int = 50
let customMarkerHeight: Int = 56

class BranchesVC: UIViewController, CLLocationManagerDelegate {
    
    var places = [SSPlace]()
    
    var markers = [GMSMarker]()
    var getBranches = [Branches]()
    
    var mapView: GMSMapView = {
        let v = GMSMapView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBranchesAPI()
        
        let camera = GMSCameraPosition.camera(withLatitude: 69,
                                              longitude: 41,
                                              zoom: 15.0)
        self.mapView.animate(to: camera)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
            setupMapView()
            self.focusMapToShowAllMarkers()
    }
    
    //mapView create, setup mapView
    func setupMapView() {
        self.view.addSubview(mapView)
        mapView.setMinZoom(1, maxZoom: 15)
        
        mapView.padding = UIEdgeInsets(top: 72, left: 25, bottom: 0, right: 25)
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        mapView.delegate = self
        
        if !getBranches.isEmpty {
            Loader.stop()
            for i in 0..<getBranches.count {
                places.append(SSPlace(name: getBranches[i].logo, address: getBranches[i].address, coordinates: (lat: getBranches[i].lat, lng: getBranches[i].long)))
                print("places",places)
            }
            
        }else {
            Loader.start()
            print("no item places")
            mapView.camera = GMSCameraPosition(latitude: 69,
                                               longitude: 41,
                                               zoom: 14)
            places.removeAll()
        }
        
        self.addMarkers()
    }
    
    //marker add
    func addMarkers() {
        markers.removeAll()
        for (index, place) in places.enumerated() {
            
            let marker = GMSMarker()
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), imageName: place.name, borderColor: primaryColor, tag: index)
            
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
            let update = GMSCameraUpdate.fit(bounds, withPadding: 20)
            self.mapView.animate(with: update)
        }
    }
    
}

//Map View delegate methods
extension BranchesVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let imgName = customMarkerView.imageName
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), imageName: imgName, borderColor: secondaryColor, tag: customMarkerView.tag)
        marker.iconView = customMarker
        return false
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let place = marker.userData as? SSPlace {
            marker.tracksInfoWindowChanges = true
            let infoWindow = CustomMarkerInfoWindow()
            infoWindow.tag = 5555
            let height: CGFloat = 170
            let paddingWith = self.view.frame.width-20
            infoWindow.frame = CGRect(x: 0, y: 0, width: getEstimatedWidthForMarker(place, padding: paddingWith) + paddingWith, height: height)
            for i in 0..<getBranches.count {
                infoWindow.updateMarkerInfo(name: getBranches[i].name, address: getBranches[i].address, open_at: getBranches[i].open_at, close_at: getBranches[i].close_at, contact: getBranches[i].contact, logo: getBranches[i].logo)
            }
            return infoWindow
        }
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let place = marker.userData as? SSPlace {
            print("Info window tapped", place)
            openGoogleMap()
        }
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        //        self.fetchSpots()
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let imgName = getBranches[0].logo
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), imageName: imgName, borderColor: primaryColor, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
    func getEstimatedWidthForMarker(_ place: SSPlace, padding: CGFloat) -> CGFloat {
        var estimatedWidth: CGFloat = 0
        let infoWindow = CustomMarkerInfoWindow()
        let maxWidth = (UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width * 0.7 : UIScreen.main.bounds.width * 0.8) - padding
        let titleWidth = (place.name ?? "").width(withConstrainedHeight: infoWindow.addressLabel.frame.height, font: infoWindow.addressLabel.font)
        let subtitleWidth = (place.address ?? "").width(withConstrainedHeight: infoWindow.nameLabel.frame.height, font: infoWindow.nameLabel.font)
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

//MARK: - Get Branches
extension BranchesVC {
    func getBranchesAPI() {
        if let token = Cache.getUserToken() {
            
            let headers : HTTPHeaders = [
                "Authorization": "\(token)"
            ]
            
            Networking.fetchRequest(urlAPI: API.branchesUrl, method: .get, params: nil, encoding: JSONEncoding.default, headers: headers) { [self] data in
                if let data = data {
                    
                    Loader.start()
                    if data["code"].intValue == 0 {
                        
                        let jsonData = JSON(data["data"])
                        
                        for i in 0..<jsonData.count {
                            Loader.stop()
                            
                            let branches = Branches(_id: jsonData[i]["_id"].intValue,
                                                    name: jsonData[i]["name"].stringValue,
                                                    logo: jsonData[i]["logo"].stringValue,
                                                    address: jsonData[i]["address"].stringValue,
                                                    open_at: jsonData[i]["open_at"].stringValue,
                                                    close_at: jsonData[i]["close_at"].stringValue,
                                                    contact: jsonData[i]["contact"].stringValue,
                                                    lat: jsonData[i]["lat"].doubleValue,
                                                    long: jsonData[i]["long"].doubleValue)
                            
                            getBranches.append(branches)
                        }
                    }else if data["code"].intValue == 50019 {
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Филиал не найден")
                    }
                }
            }
        }
    }
}

//Go To Beeto
extension BranchesVC {
    func openGoogleMap() {
        if let UrlNavigation = URL.init(string: "comgooglemaps://") {
            if UIApplication.shared.canOpenURL(UrlNavigation){
                let lat = 69.3209524
                let longi = 41.3281887
                if let urlDestination = URL.init(string: "comgooglemaps://?saddr=&daddr=\(lat),\(longi)&directionsmode=driving") {
                    UIApplication.shared.openURL(urlDestination)
                }
            }else {
                NSLog("Can't use comgooglemaps://");
                self.openTrackerInBrowser()
            }
        }else {
            NSLog("Can't use comgooglemaps://");
            self.openTrackerInBrowser()
        }
    }
    
    func openTrackerInBrowser(){
        let lat = 69.3209524
        let longi = 41.3281887
        if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(longi)&directionsmode=driving") {
            UIApplication.shared.openURL(urlDestination)
        }
    }
    
    func openGoogleDriveMap() {
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(41.3281887),\(69.3209524)&zoom=14&views=traffic&q=\(41.3281887),\(69.3209524)")!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(41.3281887),\(69.3209524)&zoom=14&views=traffic&q=\(41.3281887),\(69.3209524)")!, options: [:], completionHandler: nil)
        }
    }
}


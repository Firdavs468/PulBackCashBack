//
//  API.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 11/11/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class API {
    static  let base_url = "http://89.223.71.112:9494"
    
    //End Points.
    struct EndPoints {
        static let signIn = "/signIn"
        static let verify = "/verify"
        static let continueSignUp = "/confirm"
        static let signUp = "/signUp"
        static let getBanner = "/banner"
    }
    
    static  var signInUrl: URL = URL(string: base_url + EndPoints.signIn)!
    static  var verifyUrl: URL = URL(string: base_url + EndPoints.verify)!
    static  var continueSignUpUrl: URL = URL(string: base_url + EndPoints.continueSignUp)!
    static  var signUpUrl: URL = URL(string: base_url + EndPoints.signUp)!
    static var getBannerUrl : URL = URL(string: base_url + EndPoints.getBanner)!
    
    
    //MARK: - Get API
    //user signIn
    class func signIn(phoneNumber: String, completion: @escaping (_ data: JSON?) -> Void ) {
        
        let params = [
            "phone": phoneNumber
        ]
        
        Net.simpleRequest(from: API.continueSignUpUrl, method: .post, params: params) { data in
            guard let data = data else {completion(nil); return}
            print("signIn = ", data)
            completion(data)
        }
    }
}


// Networking
class Networking {
    class func fetchRequest(urlAPI: URL, method: HTTPMethod, params: [String : Any]?, encoding: ParameterEncoding,  headers:HTTPHeaders, complition: @escaping (_ data: JSON?) -> () ) {
        if Reachability.isConnectedToNetwork() {
            Loader.start()
            AF.request(urlAPI, method: method, parameters: params, encoding: encoding, headers: headers).responseJSON { (response) in
                if let data = response.data {
                    complition(JSON(data))
                } else {
                    complition(nil)
                    Alert.showAlert(forState: .error, message: "Error server")
                }
                Loader.stop()
            }
        } else {
            Alert.showAlert(forState: .error, message: "Your device is not connected to the Internet")
        }
    }
}


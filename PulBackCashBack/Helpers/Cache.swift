//
//  Cache.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 01/11/21.
//

import Foundation
class Cache {
    
    class func saveUserToken(token:String?){
        UserDefaults.standard.setValue(token, forKey: Keys.token)
    }
    
    class func getUserToken() -> String? {
        return UserDefaults.standard.string(forKey: Keys.token)!
    }
    
    class func saveUserDefaults(_ value:Any?, forKey: String) {
        UserDefaults.standard.setValue(value, forKey: forKey)
    }
    
    class func getUserDefaultsString(forKey:String) -> String {
        return UserDefaults.standard.string(forKey: forKey) ?? ""
    }
    
    class func isUserLogged() -> Bool{
        return UserDefaults.standard.string(forKey: Keys.token) != nil
    }
}


//
//  User.swift
//  Twitter
//
//  Created by Oscar Reyes on 2/25/17.
//  Copyright © 2017 Oscar Reyes. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var backgroundURL: NSURL?
    var following: Int?
    var followers: Int?
    var numTweets: Int?
    
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String as NSString?
        

        screenname = dictionary["screen_name"] as? String as NSString?
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString{
            profileUrl = NSURL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String as NSString?
        
        let backgroundUrlString = dictionary["profile_background_image_url_https"] as? String
        if let backgroundUrlString = backgroundUrlString {
            backgroundURL = NSURL(string: backgroundUrlString)
        }
        
        followers = dictionary["followers_count"] as? Int
        following = dictionary["friends_count"] as? Int
        numTweets = dictionary["statuses_count"] as? Int

        
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?
    
    class var currentUser: User?{
        get{
            if _currentUser == nil{
                
                let defaults = UserDefaults.standard
                
                //let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = defaults.object(forKey: "currentUserData") as? Data{
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user){
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
                
            } else{
                defaults.removeObject(forKey: "currentUserData")
                
            }
            
            defaults.synchronize()
        }
    }
    
    
}

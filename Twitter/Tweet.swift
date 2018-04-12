//
//  Tweet.swift
//  Twitter
//
//  Created by Oscar Reyes on 2/25/17.
//  Copyright © 2017 Oscar Reyes. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    var id_string: String?
    
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String as NSString?
        
        retweetCount =  (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        id_string = dictionary["id_str"] as? String

        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString{
            
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        timestamp = formatter.date(from: timestampString) as NSDate?
        }
        
        let userDictionary = dictionary["user"] as! NSDictionary
        user = User(dictionary: userDictionary)
        
      


    }

    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
    
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
    
        }
        return tweets
    }
}

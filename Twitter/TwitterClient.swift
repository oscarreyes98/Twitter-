 //
//  TwitterClient.swift
//  Twitter
//
//  Created by Oscar Reyes on 2/26/17.
//  Copyright © 2017 Oscar Reyes. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let sharedInstance = TwitterClient(baseURL:
        NSURL(string: "https://api.twitter.com") as URL!, consumerKey: "0RB07oxbtx3eG3J5YTy2fgJTi", consumerSecret: "37dkA33N2syXdc4xsPFpIx6HOrrgiMkTAQenLSIIsD4NwTIOpr")
    
    
    var loginSucess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ()){
        loginSucess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "/oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            UIApplication.shared.open(url as! URL)
            
        }, failure: { (error: Error?) -> Void in
            print("Error: \(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    
    
    func retweet(tweet: Tweet, success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        post("1.1/statuses/retweet/" + tweet.id_string! + ".json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
            
        })
    }
    
    func favorite(tweet: Tweet, success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        post("1.1/favorites/create.json", parameters: ["id": tweet.id_string!], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
            
        })
    }
    
    func unfavorite(id: Int, success: @escaping () -> (),
                    failure: @escaping (Error) -> ()) {
        self.post("https://api.twitter.com/1.1/favorites/destroy.json?id=\(id)", parameters: nil, progress:
            nil, success: { (task, response) in
                success()
        }) { (task, error) in
            failure(error)
        }
    }
    
    func tweet(status: String, success: @escaping (String) -> (), failure: @escaping (Error) -> ()){
        let tweetText = status.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        post("1.1/statuses/update.json?status=\(tweetText))", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            success("Done")
        }) { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    func unretweet(id: Int, success: @escaping () -> (),
                   failure: @escaping (Error) -> ()) {
        self.post("https://api.twitter.com/1.1/statuses/unretweet/\(id).json", parameters: nil, progress:
            nil, success: { (task, response) in
                success()
        }) { (task, error) in
            failure(error)
        }
    }
    
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "/oauth/access_token", method: "POST", requestToken: requestToken, success: { (accesToken:BDBOAuth1Credential?) in
            print("I got the access token!")
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSucess?()

            }, failure: { (error: NSError!) in
                self.loginFailure?(error)
            })
            
            
            
        }, failure: { (error:Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        })
        
    }
    
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()){
        
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            
            
            success(tweets)
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
        
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            
            success(user)
            
            print("name: \(user.name)")
            print("screenname: \(user.screenname)")
            print("profile_url: \(user.profileUrl)")
            print("description: \(user.tagline)")
            
            
        }, failure: { (task: URLSessionDataTask?,error: Error) in
            failure(error as NSError)
        })
    }
    
}

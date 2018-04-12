//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Oscar Reyes on 2/26/17.
//  Copyright © 2017 Oscar Reyes. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var loveCountLabel: UILabel!
    
    
    @IBAction func retweetButton(_ sender: Any) {
        print("rt button pressed")
        
    
        TwitterClient.sharedInstance?.retweet(tweet:(tweet!), success: { () in
            self.tweet?.retweetCount = (self.tweet?.retweetCount)! + 1
            if let retweet = self.tweet?.retweetCount{
                self.retweetCountLabel.text = String(describing: retweet)
            }
        }, failure: { (error: NSError) in
            print("Already Re-tweeted")
            print("Error: \(error.localizedDescription)")
            
        })
        
    
    }
    
    @IBAction func loveButton(_ sender: Any) {
        
        print("fav button pressed")
        
        TwitterClient.sharedInstance?.favorite(tweet:(tweet!), success: { () in
            self.tweet?.favoritesCount = (self.tweet?.favoritesCount)! + 1
            if let favorites = self.tweet?.favoritesCount{
                self.loveCountLabel.text = String(describing: favorites)
            }
            
        }, failure: { (error: NSError) in
            print("Already Favorited")
            print("Error: \(error.localizedDescription)")
        })


    }
    
    
    
    var tweet: Tweet?{
        didSet{
           // self.timestampLabel.text = "\(self.tweet?.timestamp)"
            self.tweetLabel.text = self.tweet?.text as String?
            //
            if let profPic = self.tweet?.user?.profileUrl{
                self.picImageView.setImageWith(profPic as URL)
            }
            self.picImageView.layer.cornerRadius = picImageView.bounds.size.width/2;
            self.picImageView.clipsToBounds = true
            
            self.nameLabel.text = self.tweet?.user?.name as String?
            self.usernameLabel.text = "@\((tweet?.user?.screenname as String?)!)"            
            if (self.tweet?.timestamp) != nil{
                self.timestampLabel.text = timeAgoSince((tweet?.timestamp)! as Date)
            }
            
            if let retweet = self.tweet?.retweetCount{
                self.retweetCountLabel.text = String(describing: retweet)
            }
            if let favorites = self.tweet?.favoritesCount{
                self.loveCountLabel.text = String(describing: favorites)
            }
            
            
        }
    }
    
    func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

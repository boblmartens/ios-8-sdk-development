//
//  ParsedTweet.swift
//  PragmaticTweets
//
//  Created by Bob Martens on 2/11/15.
//  Copyright (c) 2015 Bob Martens. All rights reserved.
//

import UIKit

class ParsedTweet: NSObject {
    var tweetText: String?
    var userName: String?
    var createdAt: String?
    var userAvatarURL: NSURL?
    var tweetIdString: String?
    
    override init () {
        super.init()
    }
    
    init (tweetText: String?, userName: String?, createdAt: String?, userAvatarURL: NSURL?) {
        super.init()
        self.tweetText = tweetText;
        self.userName = userName;
        self.createdAt = createdAt;
        self.userAvatarURL = userAvatarURL;
    }
   
}

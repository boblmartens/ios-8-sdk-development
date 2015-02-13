//
//  TwitterAPIRequestDelegate.swift
//  PragmaticTweets
//
//  Created by Bob Martens on 2/12/15.
//  Copyright (c) 2015 Bob Martens. All rights reserved.
//

import Foundation

protocol TwitterAPIRequestDelegate {
    func handleTwitterData (data: NSData!,
        urlResponse: NSHTTPURLResponse!,
        error: NSError!,
        fromRequest: TwitterAPIRequest!)
}
//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Bob Martens on 10/11/14.
//  Copyright (c) 2014 Bob Martens. All rights reserved.
//

import UIKit
import Social
import Accounts

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")

public class ViewController: UITableViewController {
    
    var parsedTweets: [ParsedTweet] = [
        ParsedTweet(tweetText: "iOS 8 SDK Development now in print. Swift programming FTW!", userName: "@pragprog", createdAt: "2014-08-20 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "MAth is cool", userName: "@pragprog", createdAt: "2014-08-16 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Anime is cool", userName: "@invalidname", createdAt: "2014-08-31 16:44:30 EDT", userAvatarURL: defaultAvatarURL)
    ]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        var refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl = refresher
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func reloadTweets() {
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil, completion: {
            (granted: Bool, error: NSError!) -> Void in
            if (!granted) {
                println("account access not granted")
            } else {
                let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
                if twitterAccounts.count == 0 {
                    println("no twitter accounts configured")
                    return
                } else {
                    let twitterParams = [ "count" : "100" ]
                    let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: twitterAPIURL, parameters: twitterParams)
                    request.account = twitterAccounts.first as ACAccount
                    request.performRequestWithHandler({
                        (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
                        self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                    })
                }
            }
        })
    }
    
    func handleTwitterData (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        if let dataValue = data {
            var parseError: NSError? = nil
            let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(0), error: &parseError)
            println("JSON error: \(parseError)\nJSON response: \(jsonObject)")
        } else {
            println("handleTwitterData received no data")
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(_tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }
    
    public override func tableView(_tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetCell") as ParsedTweetCell
        let parsedTweet = parsedTweets[indexPath.row]
        cell.userNameLabel.text = parsedTweet.userName
        cell.tweetTextLabel.text = parsedTweet.tweetText
        cell.createdAtLabel.text = parsedTweet.createdAt
        if parsedTweet.userAvatarURL != nil {
            if let imageData = NSData (contentsOfURL: parsedTweet.userAvatarURL!) {
                cell.avatarImageView.image = UIImage (data: imageData)
            }
        }
        return cell
    }
    
    @IBAction func handleRefresh (sender: AnyObject?) {
        parsedTweets.append(
            ParsedTweet (tweetText: "New row", userName: "@refresh", createdAt: NSDate().description, userAvatarURL: defaultAvatarURL))
        reloadTweets()
        refreshControl!.endRefreshing()
    }
}


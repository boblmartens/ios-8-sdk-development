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

public class RootViewController: UITableViewController, TwitterAPIRequestDelegate {
    
    var parsedTweets: [ParsedTweet] = []
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        var refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl = refresher
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func handleTweetButtonTapped(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController (forServiceType: SLServiceTypeTwitter)
            let message = NSLocalizedString("I just finished the first prpject in iOS 8 SDK Development. #pragios8", comment: "")
            tweetVC.setInitialText(message)
            presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            println("Can't send tweet")
        }
    }
    
    func reloadTweets() {
        let twitterParams: Dictionary = ["count" : "100"]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        let request = TwitterAPIRequest()
        request.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    func handleTwitterData (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let dataValue = data {
            var parseError: NSError? = nil
            let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(0), error: &parseError)
            println("JSON error: \(parseError)\nJSON response: \(jsonObject)")
            if parseError != nil {
                return
            }
            if let jsonArray = jsonObject as? [[String:AnyObject]] {
                self.parsedTweets.removeAll(keepCapacity: true)
                for tweetDict in jsonArray {
                    let parsedTweet = ParsedTweet()
                    parsedTweet.tweetText = tweetDict["text"] as? String
                    parsedTweet.createdAt = tweetDict["created_at"] as? String
                    let userDict = tweetDict["user"] as NSDictionary
                    parsedTweet.userName = userDict["name"] as? String
                    parsedTweet.userAvatarURL = NSURL(string: userDict["profile_image_url"] as String!)
                    parsedTweet.tweetIdString = tweetDict["id_str"] as? NSString
                    self.parsedTweets.append(parsedTweet)
                }
                dispatch_async(dispatch_get_main_queue(),
                    {
                        self.tableView.reloadData()
                })
            }
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
        cell.avatarImageView.image = nil
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
            {
                if let imageData = NSData(contentsOfURL: parsedTweet.userAvatarURL!) {
                    let avatarImage = UIImage(data: imageData)
                    dispatch_async(dispatch_get_main_queue(), {
                        if cell.userNameLabel.text == parsedTweet.userName {
                            cell.avatarImageView.image = avatarImage
                        } else {
                            println("oops, wrong cell, never mind")
                        }
                    })
                }
        })
        return cell
    }
    
    @IBAction func handleRefresh (sender: AnyObject?) {
        reloadTweets()
        refreshControl!.endRefreshing()
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTweetDetailsSegue" {
            if let tweetDetailVC = segue.destinationViewController as? TweetDetailViewController {
                let row = tableView!.indexPathForSelectedRow()!.row
                let parsedTweet = parsedTweets[row] as ParsedTweet
                tweetDetailVC.tweetIdString = parsedTweet.tweetIdString
            }
        }
    }
}


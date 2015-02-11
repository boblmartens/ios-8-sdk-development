//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Bob Martens on 10/11/14.
//  Copyright (c) 2014 Bob Martens. All rights reserved.
//

import UIKit
import Social

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/aticky/default_profile_images/default_profile_6_200x200.png")

public class ViewController: UITableViewController {
    
    var parsedTweets: [ParsedTweet] = [
        ParsedTweet(tweetText: "iOS 8 SDK Development now in print. Swift programming FTW!", userName: "@pragprog", createdAt: "2014-08-20 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "MAth is cool", userName: "@pragprog", createdAt: "2014-08-16 16:44:30 EDT", userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Anime is cool", userName: "@invalidname", createdAt: "2014-08-31 16:44:30 EDT", userAvatarURL: defaultAvatarURL)
    ]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func reloadTweets() {
        tableView.reloadData()
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
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        let parsedTweet = parsedTweets[indexPath.row]
        cell.textLabel?.text = parsedTweet.tweetText
        return cell
    }
    
    @IBAction func handleShowMyTweetsTapped(sender: UIButton) {
        reloadTweets()
    }
}


//
//  UserDetailViewController.swift
//  PragmaticTweets
//
//  Created by Bob Martens on 2/21/15.
//  Copyright (c) 2015 Bob Martens. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, TwitterAPIRequestDelegate {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    
    var screenName: String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if screenName == nil {
            return
        }
        let twitterRequest = TwitterAPIRequest()
        let twitterParams = ["screen_name" : screenName!]
        let twitterAPIURL = NSURL (string: "https://api.twitter.com/1.1/users/show.json")
        twitterRequest.sendTwitterRequest(twitterAPIURL, params: twitterParams, delegate: self)
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!, fromRequest: TwitterAPIRequest!) {
        if let dataValue = data {
            let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding)
            var parseError: NSError? = nil
            let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataValue, options: NSJSONReadingOptions(0), error: &parseError)
            if parseError != nil {
                return
            }
            
            if let tweetDict = jsonObject as? [String:AnyObject] {
                dispatch_async(dispatch_get_main_queue(), {
                    self.userRealNameLabel.text = tweetDict["name"] as? String
                    self.userScreenNameLabel.text = tweetDict["screen_name"] as? String
                    self.userLocationLabel.text = tweetDict["location"] as? String
                    self.userDescriptionLabel.text = tweetDict["description"] as? String
                    if let userImageURL = NSURL (string: tweetDict["profile_image_url"] as! String) {
                        if let userImgaeData = NSData(contentsOfURL: userImageURL) {
                            self.userImageView.image = UIImage(data: userImgaeData)
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func unwindToUserDetailVC (segue: UIStoryboardSegue) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  UserDetailViewController.swift
//  PragmaticTweets
//
//  Created by Chris Adamson on 11/14/14.
//  Copyright (c) 2014 Pragmatic Programmers, LLC. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, TwitterAPIRequestDelegate {

  var screenName : String?
  var userImageURL : NSURL?
  
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userRealNameLabel: UILabel!
  @IBOutlet weak var userScreenNameLabel: UILabel!
  @IBOutlet weak var userLocationLabel: UILabel!
  @IBOutlet weak var userDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  override func viewWillAppear(animated: Bool)  {
    if screenName == nil {
      return;
    }
    let twitterRequest = TwitterAPIRequest()
    let twitterParams = ["screen_name" : screenName!]
    let twitterAPIURL = NSURL (string: "https://api.twitter.com/1.1/users/show.json")
    twitterRequest.sendTwitterRequest(twitterAPIURL,
      params: twitterParams,
      delegate: self)
  }

  func handleTwitterData (data: NSData!,
    urlResponse: NSHTTPURLResponse!,
    error: NSError!,
    fromRequest: TwitterAPIRequest!) {
      
      if let dataValue = data {
        var parseError : NSError? = nil
        let jsonObject : AnyObject? =
        NSJSONSerialization.JSONObjectWithData(dataValue,
          options: NSJSONReadingOptions(0),
          error: &parseError)
        if parseError != nil {
          return
        }
        if let tweetDict = jsonObject as? [String:AnyObject] {
          dispatch_async(dispatch_get_main_queue(),
            {
              self.userRealNameLabel.text = tweetDict["name"] as? String
              self.userScreenNameLabel.text = tweetDict["screen_name"] as? String
              self.userLocationLabel.text = tweetDict["location"] as? String
              self.userDescriptionLabel.text = tweetDict["description"] as? String
              
              if let userImageURL = NSURL (string: tweetDict ["profile_image_url"] as! String) {
                  if let userImageData = NSData (contentsOfURL: userImageURL) {
                    self.userImageView.image = UIImage(data:userImageData)
                  }
              }
              
              self.userImageURL = NSURL (string: tweetDict["profile_image_url"] as! String!)
              
              if self.userImageURL != nil {
                if let userImageData = NSData(contentsOfURL: self.userImageURL!) {
                  self.userImageView.image = UIImage(data: userImageData)
                }
              }
          })
        }
      }
  }

  @IBAction func unwindToUserDetailVC (segue : UIStoryboardSegue) {
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showUserImageDetailSegue" {
      if let imageDetailVC = segue.destinationViewController as? UserImageDetailViewController {
        var urlString = userImageURL!.absoluteString
        urlString = urlString!.stringByReplacingOccurrencesOfString("_normal", withString: "")
        imageDetailVC.userImageURL = NSURL(string: urlString!)
      }
    }
  }

  
}

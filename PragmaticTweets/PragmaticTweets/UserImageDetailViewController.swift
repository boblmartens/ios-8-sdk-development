//
//  UserImageDetailViewController.swift
//  PragmaticTweets
//
//  Created by Bob Martens on 4/21/15.
//  Copyright (c) 2015 Pragmatic Programmers, LLC. All rights reserved.
//

import UIKit

class UserImageDetailViewController: UIViewController {
  var userImageURL : NSURL?
  
  @IBOutlet weak var userImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if userImageURL != nil {
      if let imageData = NSData(contentsOfURL: userImageURL!) {
        userImageView.image = UIImage(data: imageData)
      }
    }
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

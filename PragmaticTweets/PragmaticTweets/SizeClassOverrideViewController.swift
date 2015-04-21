//
//  SizeClassOverrideViewController.swift
//  PragmaticTweets
//
//  Created by Chris Adamson on 11/15/14.
//  Copyright (c) 2014 Pragmatic Programmers, LLC. All rights reserved.
//

import UIKit

class SizeClassOverrideViewController: UIViewController {

  var embeddedSplitVC : UISplitViewController?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  override func viewWillTransitionToSize(size: CGSize,
    withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
      if size.width > 480.0 {
        let overrideTraits = UITraitCollection (
          horizontalSizeClass: UIUserInterfaceSizeClass.Regular)
        setOverrideTraitCollection(overrideTraits,
          forChildViewController: embeddedSplitVC!);
      } else {
        setOverrideTraitCollection(nil,
          forChildViewController: embeddedSplitVC!);
      }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "embedSplitViewSegue" {
      embeddedSplitVC = segue.destinationViewController as? UISplitViewController
    }
  }

}

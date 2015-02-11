//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Bob Martens on 10/11/14.
//  Copyright (c) 2014 Bob Martens. All rights reserved.
//

import UIKit
import Social

public class ViewController: UITableViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    public override func tableView(_tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    public override func tableView(_tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section + 1
    }
    
    public override func tableView(_tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.textLabel!.text = "Row \(indexPath.row)"
        return cell
    }
    
    @IBAction func handleShowMyTweetsTapped(sender: UIButton) {
        reloadTweets()
    }
    
    func reloadTweets() {
    }
}


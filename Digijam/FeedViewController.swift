//
//  FeedViewController.swift
//  Digijam
//
//  Created by Zachary Drossman on 11/13/14.
//  Copyright (c) 2014 Zachary Drossman. All rights reserved.
//

import UIKit
import Alamofire

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var primaryFeed = UserFeed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        var githubAPI = GithubAPI()
        if let username = UserManager.currentUser?.githubUserName {
            githubAPI.filterPushEventsFromAPIForUser(username, completion: { (userFeed, error) -> () in
                if error == nil {
                    if let userFeed = userFeed {
                        self.primaryFeed = userFeed
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return primaryFeed.events.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : EventCell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as EventCell
    
        var cellEvent = primaryFeed.events[indexPath.section];
        cell.titleLabel?.text = cellEvent.title
        cell.contentLabel?.text = cellEvent.content as? String
        cell.typeImageView?.image = UIImage(named: "Github-Mark.png")
        return cell
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var cellEvent = primaryFeed.events[section];
        
       var headerView = NSBundle.mainBundle().loadNibNamed("EventCellHeaderView", owner: nil, options: nil).last as EventCellHeaderView

        
       // if var headerView = headerView {
            headerView.userLabel.text = cellEvent.owner.githubUserName
            
            headerView.timeStampLabel.text = convertNSDateToFormattedDateString(cellEvent.timestamp)
        //}
        
        return headerView;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func convertNSDateToFormattedDateString(timestamp: NSDate) -> String {
        
        var dateFormatter = NSDateFormatter()
        //let usLocale = NSLocale(localeIdentifier: "en_US")
        //dateFormatter.locale = usLocale
        //dateFormatter.timeZone = NSTimeZone(name:"UTC")
        //dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        //dateFormatter.formatterBehavior = NSDateFormatterBehavior.Behavior10_4
        
        // see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
        //dateFormatter.dateFormat = "yyyy"
        
        let formattedDate = dateFormatter.stringFromDate(timestamp)
        return "hey there"
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */

    
    
    
    
}


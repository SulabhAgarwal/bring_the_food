//
//  MainViewController.swift
//  Bring the Food
//
//  Created by federico badini on 13/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, FilterProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var UIMainColor = UIColor(red: 0xf6/255, green: 0xae/255, blue: 0x39/255, alpha: 1)

    weak var donationsObserver: NSObjectProtocol?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let refreshControlColor = UIColor(red: 0xfe/255, green: 0xfa/255, blue: 0xf3/255, alpha: 1)
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = refreshControlColor
        return refreshControl
        }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIMainColor], forState:.Selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIMainColor], forState:.Normal)
        for item in (self.tabBarController?.tabBar.items as NSArray!){
            (item as! UITabBarItem).image = (item as! UITabBarItem).image?.imageWithRenderingMode(.AlwaysOriginal)
        }
        self.tableView.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        // Register as notification center observer
        donationsObserver = NSNotificationCenter.defaultCenter().addObserverForName(getOthersDonationNotificationKey,
            object: ModelUpdater.getInstance(),
            queue: NSOperationQueue.mainQueue(),
            usingBlock: {(notification:NSNotification!) in self.fillTableView(notification)})
        Model.getInstance().downloadOthersDonationsList()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(donationsObserver!)
        super.viewWillDisappear(animated)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        // Set light content status bar
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if segue.identifier == "filterContent" {
            var vc = segue.destinationViewController as! FilterViewController
            vc.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillTableView(notification: NSNotification){
        let othersDonationsList = Model.getInstance().getOthersDonationsList()
        tableView.dataSource = othersDonationsList
        tableView.delegate = othersDonationsList
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        Model.getInstance().downloadOthersDonationsList()
    }
    
    func handleFiltering() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

protocol FilterProtocol {
    func handleFiltering()
}

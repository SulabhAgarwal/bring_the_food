//
//  BookingsViewController.swift
//  Bring the Food
//
//  Created by federico badini on 15/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import UIKit

class BookingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var UIMainColor = UIColor(red: 0xf6/255, green: 0xae/255, blue: 0x39/255, alpha: 1)
    
    weak var donationsObserver:NSObjectProtocol?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let refreshControlColor = UIColor(red: 0xfe/255, green: 0xfa/255, blue: 0xf3/255, alpha: 1)
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = refreshControlColor
        return refreshControl
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl)
        let backgroundView = UIView(frame: CGRectZero)
        tableView.tableFooterView = backgroundView
        tableView.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        // Register as notification center observer
        donationsObserver = NSNotificationCenter.defaultCenter().addObserverForName(getBookingsNotificationKey,
            object: ModelUpdater.getInstance(),
            queue: NSOperationQueue.mainQueue(),
            usingBlock: {(notification:NSNotification!) in self.fillTableView(notification)})
        Model.getInstance().downloadMyBookings()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(donationsObserver!)
        super.viewWillDisappear(animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        // Set light content status bar
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillTableView(notification: NSNotification){
        let bookingsList = Model.getInstance().getMyBookings()
        tableView.dataSource = bookingsList
        tableView.delegate = bookingsList
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        Model.getInstance().downloadMyBookings()
    }
    
}
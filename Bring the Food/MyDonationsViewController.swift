//
//  MyDonationsViewController.swift
//  Bring the Food
//
//  Created by federico badini on 15/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import UIKit

class MyDonationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var UIMainColor = UIColor(red: 0xf6/255, green: 0xae/255, blue: 0x39/255, alpha: 1)
    
    weak var donationsObserver:NSObjectProtocol?

    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        // Register as notification center observer
        donationsObserver = NSNotificationCenter.defaultCenter().addObserverForName(getMyDonationNotificationKey,
            object: ModelUpdater.getInstance(),
            queue: NSOperationQueue.mainQueue(),
            usingBlock: {(notification:NSNotification!) in self.fillTableView(notification)})
        Model.getInstance().downloadMyDonationsList()
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
        let myDonationsList = Model.getInstance().getMyDonationsList()
        tableView.dataSource = myDonationsList
        tableView.delegate = myDonationsList
        tableView.reloadData()
    }

}
//
//  MyDonationsList.swift
//  Bring the Food
//
//  Created by Stefano Bodini on 13/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import UIKit
import Foundation

public class MyDonationsList: NSObject, UITableViewDataSource, UITableViewDelegate {

    private var myAvailableDonationsList: [StoredDonation]!
    private var myBookedDonationsList: [StoredDonation]!
    private var myHistoricDonationsList: [StoredDonation]!
    let textCellIdentifier = "TextCell"
    
    public init(myAvailableDonationsList: [StoredDonation]!, myBookedDonationsList: [StoredDonation]!, myHistoricDonationsList: [StoredDonation]!){
        self.myAvailableDonationsList = myAvailableDonationsList
        self.myBookedDonationsList = myBookedDonationsList
        self.myHistoricDonationsList = myHistoricDonationsList
    }
    
    // MARK:  UITextFieldDelegate Methods
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAvailableDonationsList.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        let mainLabel = cell.viewWithTag(1000) as! UILabel
        mainLabel.text = myAvailableDonationsList[row].getDescription()
        let addressLabel = cell.viewWithTag(1001) as! UILabel
        addressLabel.text = myAvailableDonationsList[row].getSupplier().getAddress().getLabel()
        let expirationLabel = cell.viewWithTag(1002) as! UILabel
        expirationLabel.text = String(myAvailableDonationsList[row].getRemainingDays()) + "d"
        if(myAvailableDonationsList[row].getRemainingDays() > 10){
            let alarm = cell.viewWithTag(1003) as! UIImageView
            alarm.hidden = true
        }
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(myAvailableDonationsList[row])
    }
    
}
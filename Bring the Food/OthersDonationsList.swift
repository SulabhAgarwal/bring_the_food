//
//  OthersDonationsList.swift
//  Bring the Food
//
//  Created by Stefano Bodini on 13/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import Foundation
import UIKit

public class OthersDonationsList: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var othersDonationsList: [StoredDonation]!
    let textCellIdentifier = "TextCell"
    
    public init(othersDonationsList: [StoredDonation]!){
        self.othersDonationsList = othersDonationsList
    }
    
    // MARK:  UITextFieldDelegate Methods
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return othersDonationsList.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        let mainLabel = cell.viewWithTag(1000) as! UILabel
        mainLabel.text = othersDonationsList[row].getDescription()
        let addressLabel = cell.viewWithTag(1001) as! UILabel
        addressLabel.numberOfLines = 2
        let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
        if (iOS8) {
            // do nothing, it will use automatic via the storyboard
        } else {
            let screenWidth = UIScreen.mainScreen().bounds.width
            addressLabel.preferredMaxLayoutWidth = screenWidth - 89;
        }
        addressLabel.text = othersDonationsList[row].getSupplier().getAddress().getLabel()
        let expirationLabel = cell.viewWithTag(1002) as! UILabel
        expirationLabel.text = String(othersDonationsList[row].getRemainingDays()) + "d"
        if(othersDonationsList[row].getRemainingDays() > 20){
            let alarmIcon = cell.viewWithTag(1003) as! UIImageView
            alarmIcon.hidden = true
        }
        let amountLabel = cell.viewWithTag(1004) as! UILabel
        amountLabel.text = "\(othersDonationsList[row].getParcelSize())"
        let parcelUnit = othersDonationsList[row].getParcelUnit()
        let kgIcon = cell.viewWithTag(1005) as! UIImageView
        let ltIcon = cell.viewWithTag(1006) as! UIImageView
        let portionIcon = cell.viewWithTag(1007) as! UIImageView
        if(parcelUnit == ParcelUnit.KILOGRAMS){
            kgIcon.hidden = false
            ltIcon.hidden = true
            portionIcon.hidden = true
        }
        else if(parcelUnit == ParcelUnit.LITERS){
            kgIcon.hidden = true
            ltIcon.hidden = false
            portionIcon.hidden = true
        }
        else{
            kgIcon.hidden = true
            ltIcon.hidden = true
            portionIcon.hidden = false
        }
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(othersDonationsList[row])
    }
    
}
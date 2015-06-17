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

    private var donations: [DonationsList]! = []
    let textCellIdentifier = "TextCell"
    
    public init(myAvailableDonationsList: [StoredDonation]!, myBookedDonationsList: [StoredDonation]!, myHistoricDonationsList: [StoredDonation]!){
        donations.append(DonationsList(donationName: "Available", donationList: myAvailableDonationsList))
        donations.append(DonationsList(donationName: "Booked", donationList: myBookedDonationsList))
        donations.append(DonationsList(donationName: "Historic", donationList: myHistoricDonationsList))
    }
    
    // MARK:  UITextFieldDelegate Methods
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return donations[section].donationName
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(donations[0].donationsList.isEmpty && donations[1].donationsList.isEmpty && donations[2].donationsList.isEmpty){
            createEmptyView(tableView)
            return 0
        }
        return donations.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let donationsInSection = donations[section]
        return donationsInSection.donationsList.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let donationsInSection = donations[indexPath.section]
        let donation = donationsInSection.donationsList[indexPath.row]
        
        let mainLabel = cell.viewWithTag(1000) as! UILabel
        mainLabel.text = donation.getDescription()
        let addressLabel = cell.viewWithTag(1001) as! UILabel
        addressLabel.numberOfLines = 2
        let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
        if (iOS8) {
            // do nothing, it will use automatic via the storyboard
        } else {
            let screenWidth = UIScreen.mainScreen().bounds.width
            addressLabel.preferredMaxLayoutWidth = screenWidth - 89;
        }
        addressLabel.text = donation.getSupplier().getAddress().getLabel()
        let expirationLabel = cell.viewWithTag(1002) as! UILabel
        expirationLabel.text = String(donation.getRemainingDays()) + "d"
        if(donation.getRemainingDays() > 20){
            let alarmIcon = cell.viewWithTag(1003) as! UIImageView
            alarmIcon.hidden = true
        }
        let amountLabel = cell.viewWithTag(1004) as! UILabel
        amountLabel.text = "\(donation.getParcelSize())"
        let parcelUnit = donation.getParcelUnit()
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
        println(row)
    }
    
    func createEmptyView(tableView: UITableView){
        // Display a message when the table is empty
        let emptyTableView = UIView(frame: CGRectMake(0, 0, tableView.bounds.width, tableView.bounds.height))
        let mainMessageLabel: UILabel = UILabel()
        mainMessageLabel.text = "No donations"
        mainMessageLabel.textColor = UIColor.lightGrayColor()
        mainMessageLabel.numberOfLines = 1
        mainMessageLabel.textAlignment = .Center
        mainMessageLabel.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        mainMessageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        var widthConstraint = NSLayoutConstraint(item: mainMessageLabel, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 250)
        mainMessageLabel.addConstraint(widthConstraint)
        
        var heightConstraint = NSLayoutConstraint(item: mainMessageLabel, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100)
        mainMessageLabel.addConstraint(heightConstraint)
        
        var xConstraint = NSLayoutConstraint(item: mainMessageLabel, attribute: .CenterX, relatedBy: .Equal, toItem: emptyTableView, attribute: .CenterX, multiplier: 1, constant: 0)
        
        var yConstraint = NSLayoutConstraint(item: mainMessageLabel, attribute: .CenterY, relatedBy: .Equal, toItem: emptyTableView, attribute: .CenterY, multiplier: 1, constant: 0)
        
        emptyTableView.addSubview(mainMessageLabel)
        emptyTableView.addConstraint(xConstraint)
        emptyTableView.addConstraint(yConstraint)
        
        let secondaryMessageLabel = UILabel()
        secondaryMessageLabel.text = "Pull down to refresh"
        secondaryMessageLabel.textColor = UIColor.lightGrayColor()
        secondaryMessageLabel.numberOfLines = 1
        secondaryMessageLabel.textAlignment = .Center
        secondaryMessageLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13)
        secondaryMessageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        widthConstraint = NSLayoutConstraint(item: secondaryMessageLabel, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 250)
        secondaryMessageLabel.addConstraint(widthConstraint)
        
        heightConstraint = NSLayoutConstraint(item: secondaryMessageLabel, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100)
        secondaryMessageLabel.addConstraint(heightConstraint)
        
        xConstraint = NSLayoutConstraint(item: secondaryMessageLabel, attribute: .CenterX, relatedBy: .Equal, toItem: emptyTableView, attribute: .CenterX, multiplier: 1, constant: 0)
        
        yConstraint = NSLayoutConstraint(item: secondaryMessageLabel, attribute: .CenterY, relatedBy: .Equal, toItem: mainMessageLabel, attribute: .CenterY, multiplier: 1, constant: 30)
        
        emptyTableView.addConstraint(xConstraint)
        emptyTableView.addConstraint(yConstraint)
        
        emptyTableView.addSubview(secondaryMessageLabel)
        tableView.backgroundView = emptyTableView;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
}

struct DonationsList {
    
    var donationsList : [StoredDonation]!
    var donationName: String

    init(donationName: String, donationList: [StoredDonation]!){
        self.donationName = donationName
        self.donationsList = donationList
    }
}
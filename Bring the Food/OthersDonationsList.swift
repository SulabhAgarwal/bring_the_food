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
    private var othersDonationsFilteredList: [StoredDonation]!
    private var emptyTableView: UIView?
    private var secondaryMessageLabel: UILabel?
    let textCellIdentifier = "TextCell"
    
    public init(othersDonationsList: [StoredDonation]!){
        self.othersDonationsList = othersDonationsList
        othersDonationsFilteredList = othersDonationsList
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Available donations"
    }
    
    // MARK:  UITextFieldDelegate Methods
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(othersDonationsFilteredList.count > 0){
            if(emptyTableView != nil){
                emptyTableView?.hidden = true
            }
            return 1
        }
        if(emptyTableView == nil){
            createEmptyView(tableView)
        }
        
        if(othersDonationsList.count == 0){
            secondaryMessageLabel?.text = "Pull down to refresh"
        }
        else{
            secondaryMessageLabel?.text = "Change filtering criteria"
        }
        emptyTableView?.hidden = false
            
        return 0
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return othersDonationsFilteredList.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        let mainLabel = cell.viewWithTag(1000) as! UILabel
        let addressLabel = cell.viewWithTag(1001) as! UILabel
        let expirationLabel = cell.viewWithTag(1002) as! UILabel
        let alarmIcon = cell.viewWithTag(1003) as! UIImageView
        let amountLabel = cell.viewWithTag(1004) as! UILabel
        let kgIcon = cell.viewWithTag(1005) as! UIImageView
        let ltIcon = cell.viewWithTag(1006) as! UIImageView
        let portionIcon = cell.viewWithTag(1007) as! UIImageView
        
        mainLabel.text = othersDonationsFilteredList[row].getDescription()
        addressLabel.numberOfLines = 2
        let iOS8 = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_1)
        if (iOS8) {
            // do nothing, it will use automatic via the storyboard
        } else {
            let screenWidth = UIScreen.mainScreen().bounds.width
            addressLabel.preferredMaxLayoutWidth = screenWidth - 89;
        }
        addressLabel.text = othersDonationsFilteredList[row].getSupplier().getAddress().getLabel()
        expirationLabel.text = String(othersDonationsFilteredList[row].getRemainingDays()) + "d"
        if(othersDonationsFilteredList[row].getRemainingDays() > 20){
            alarmIcon.hidden = true
        }
        amountLabel.text = "\(othersDonationsFilteredList[row].getParcelSize())"
        let parcelUnit = othersDonationsFilteredList[row].getParcelUnit()
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
    
    public func setFilter(filterState: FilterState){
        othersDonationsFilteredList.removeAll(keepCapacity: false)
        for donation in othersDonationsList{
            if(respectFilter(filterState, donation: donation)){
                othersDonationsFilteredList.append(donation)
            }
        }
    }
    
    private func respectFilter(filterState: FilterState, donation: StoredDonation) -> Bool {
        if(donation.getProductType().description == "fresh" && !filterState.isFreshFood){
            return false
        }
        if(donation.getProductType().description == "cooked" && !filterState.isCookedFood){
            return false
        }
        if(donation.getProductType().description == "dried" && !filterState.isDriedFood){
            return false
        }
        if(donation.getProductType().description == "frozen" && !filterState.isFrozenFood){
            return false
        }
        if(donation.getRemainingDays() > filterState.expiration && filterState.expiration < 60){
            return false
        }
        return true
    }
    
    func createEmptyView(tableView: UITableView){
        // Display a message when the table is empty
        emptyTableView = UIView(frame: CGRectMake(0, 0, tableView.bounds.width, tableView.bounds.height))
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
        
        emptyTableView!.addSubview(mainMessageLabel)
        emptyTableView!.addConstraint(xConstraint)
        emptyTableView!.addConstraint(yConstraint)
        
        secondaryMessageLabel = UILabel()
        secondaryMessageLabel!.textColor = UIColor.lightGrayColor()
        secondaryMessageLabel!.numberOfLines = 1
        secondaryMessageLabel!.textAlignment = .Center
        secondaryMessageLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 13)
        secondaryMessageLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        widthConstraint = NSLayoutConstraint(item: secondaryMessageLabel!, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 250)
        secondaryMessageLabel!.addConstraint(widthConstraint)
        
        heightConstraint = NSLayoutConstraint(item: secondaryMessageLabel!, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100)
        secondaryMessageLabel!.addConstraint(heightConstraint)
        
        xConstraint = NSLayoutConstraint(item: secondaryMessageLabel!, attribute: .CenterX, relatedBy: .Equal, toItem: emptyTableView, attribute: .CenterX, multiplier: 1, constant: 0)
        
        yConstraint = NSLayoutConstraint(item: secondaryMessageLabel!, attribute: .CenterY, relatedBy: .Equal, toItem: mainMessageLabel, attribute: .CenterY, multiplier: 1, constant: 30)
        
        emptyTableView!.addConstraint(xConstraint)
        emptyTableView!.addConstraint(yConstraint)
        
        emptyTableView!.addSubview(secondaryMessageLabel!)
        tableView.backgroundView = emptyTableView;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
}
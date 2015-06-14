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
        cell.textLabel!.text = myAvailableDonationsList[row].getDescription()
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(myAvailableDonationsList[row])
    }
    
}
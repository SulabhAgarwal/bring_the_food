//
//  MyDonationsList.swift
//  Bring the Food
//
//  Created by Stefano Bodini on 13/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import Foundation

public class MyDonationsList {

    private var myAvailableDonationsList: [StoredDonation]!
    private var myBookedDonationsList: [StoredDonation]!
    private var myHistoricDonationsList: [StoredDonation]!
    
    
    public init(myAvailableDonationsList: [StoredDonation]!, myBookedDonationsList: [StoredDonation]!, myHistoricDonationsList: [StoredDonation]!){
        self.myAvailableDonationsList = myAvailableDonationsList
        self.myBookedDonationsList = myBookedDonationsList
        self.myHistoricDonationsList = myHistoricDonationsList
    }
    

    
}
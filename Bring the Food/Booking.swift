//
//  Booking.swift
//  Bring the Food
//
//  Created by Stefano Bodini on 12/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import Foundation

public class Booking{
    
    private let id : Int!
    private let donationId : Int!
    private var open : Bool!
    
    init(id: Int!, donationId: Int!, open:Bool!){
        self.id = id
        self.donationId = donationId
        self.open = open
    }
    
    //TODO
    public func getStoredDonation() -> StoredDonation? {
        return nil
    }
    
    //TODO
    public func unbook(){}
}
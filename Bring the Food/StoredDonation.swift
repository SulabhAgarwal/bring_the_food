//
//  Donation.swift
//  Bring the Food
//
//  Created by Stefano Bodini on 12/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import Foundation

public class StoredDonation : NewDonation {
    
    private let id: Int!
    private let supplier: User!
    private let photo_url: String!
    private let can_be_modified: Bool!
    
    
    public init(id:Int!, description: String!, parcelSize: Float!, parcelUnit: ParcelUnit!,
        productDate: Date!, productType: ProductType!, photo_url:String!, supplier: User!, can_be_modified: Bool!){
            
            self.id = id
            self.supplier = supplier
            self.photo_url = photo_url
            self.can_be_modified = can_be_modified
            
            super.init(description, parcelSize: parcelSize, parcelUnit: parcelUnit,
                productDate: productDate, productType: productType)
    }
    
    
    
    public func getRemainingDays() -> Int!{
        
        let prodDate = self.getProductDate().getDate()
        let currentDate = NSDate()
        let gregorian = NSCalendar.currentCalendar()
        
        let components = gregorian.components(NSCalendarUnit.CalendarUnitDay,
            fromDate: currentDate,
            toDate: prodDate,
            options: nil)
        
        return components.day
    }
    
    //TODO
    public func book(){}
    
    public func getPhotoURL() -> String?{
        return self.photo_url
    }
    
    public func canBeModified() -> Bool! {
        return self.can_be_modified
    }
}
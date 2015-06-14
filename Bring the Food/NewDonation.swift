//
//  Donation.swift
//  Bring the Food
//
//  Created by Stefano Bodini on 10/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import Foundation

public class NewDonation{
    
    
    private let description: String!
    private let parcelSize: Float!
    private let parcelUnit: ParcelUnit!
    private let productDate: Date!
    private let productType: ProductType!
    
    
    public init(_ description: String!, parcelSize: Float!, parcelUnit: ParcelUnit!,
        productDate: Date!, productType: ProductType!){
            self.description = description
            self.parcelSize = parcelSize
            self.parcelUnit = parcelUnit
            self.productDate = productDate
            self.productType = productType
    }
    
    public func getDescription() -> String! {
        return self.description
    }
    
    public func getParcelSize() -> Float! {
        return self.parcelSize
    }
    
    public func getParcelUnit() -> ParcelUnit! {
        return self.parcelUnit
    }
    
    public func getProductDate() -> Date! {
        return self.productDate
    }
    
    public func getProductType() -> ProductType! {
        return self.productType
    }
    
}

public enum ParcelUnit : Printable {
    case LITERS
    case KILOGRAMS
    case PORTIONS
    
    public var description : String {
        switch self {
        case .LITERS: return "liters"
        case .KILOGRAMS: return "kg"
        case .PORTIONS: return "portions"
        }
    }
}

public enum ProductType : Printable {
    case DRIED
    case FRESH
    case COOKED
    case FROZEN
    
    public var description : String {
        switch self {
        case .DRIED: return "dried"
        case .FRESH: return "fresh"
        case .COOKED: return "cooked"
        case .FROZEN: return "frozen"
        }
    }
}

public class ParcelUnitFactory {
    
    public static func getParcUnitFromString(string :String)-> ParcelUnit{
        var output :ParcelUnit
        
        switch string {
        case "liters" : output = ParcelUnit.LITERS
        case "kg" : output = ParcelUnit.KILOGRAMS
        default: output = ParcelUnit.PORTIONS
        }
        
        return output
    }
}

public class ProductTypeFactory{
    
    public static func getProdTypeFromString(string :String)-> ProductType{
        var output :ProductType
        
        switch string {
        case "dried" : output = ProductType.DRIED
        case "fresh" : output = ProductType.FRESH
        case "cooked" : output = ProductType.COOKED
        default: output = ProductType.FROZEN
        }
        
        return output
    }
}
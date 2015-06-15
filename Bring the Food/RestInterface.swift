//
//  RestInterface.swift
//  Bring the Food
//
//  Created by Stefano Bodini on 03/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class RestInterface : NSObject{
    
    private let serverAddress: String = "http://dev.ict4g.org/btf/api/v2"
    private let securityToken: String = "e01228ed4aee2b0cd103fa0962f4589a"
    private var userId: Int = 0
    private var singleAccessToken: String = ""
    private static var instance: RestInterface?
    
    // per fare in modo che il costruttore non sia accessibile all'esterno della classe
    private override init() {
        super.init()
    }
    
    public static func getInstance() -> RestInterface{
        if(self.instance == nil){
            self.instance = RestInterface()
        }
        return self.instance!
    }
    
    //*********************************************************************************
    // CREDENTIALS STORAGE
    //*********************************************************************************
    
    public func isLoggedIn() -> Bool {
        if self.singleAccessToken != "" {
            return true
        }
        //deleteCredentials()
        return loadCredentials()
    }
    
    public func setUserCredentials(userId : Int, singleAccessToken:String){
        self.userId = userId
        self.singleAccessToken = singleAccessToken
        storeCredentials(userId, singleAccessToken: singleAccessToken)
        println(self.userId)
        println(self.singleAccessToken)
    }
    
    private func storeCredentials(userId : Int, singleAccessToken:String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate!
        let managedObjectContext = appDelegate.managedObjectContext
        
        let ent = NSEntityDescription.entityForName("Credentials", inManagedObjectContext: managedObjectContext!)
        var newCredentials = Credentials(entity: ent!, insertIntoManagedObjectContext: managedObjectContext)
        
        newCredentials.singleAccessToken = singleAccessToken
        newCredentials.userId = userId
        
        managedObjectContext?.save(nil)
    }
    
    // Ritorna vero se il caricamento delle credenziali ha avuto successo, falso altrimenti
    private func loadCredentials() -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate!
        let managedObjectContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Credentials")
        request.returnsObjectsAsFaults = false
        
        var results = managedObjectContext!.executeFetchRequest(request, error: nil)
        
        if results!.count > 0 {
            println(results![0])
            let cred = results![0] as! Credentials
            /*
            let manCred = results![0] as! NSManagedObject
            let cred = manCred as! Credentials
*/
            self.singleAccessToken = cred.singleAccessToken
            self.userId = Int(cred.userId)
            println(self.userId)
            println(self.singleAccessToken)
            return true
        }
        
        return false
    }
    
    // Da chiamare in seguito al logout, cancella tutte le credenziali salvate
    private func deleteCredentials() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate!
        let managedObjectContext = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Credentials")
        request.returnsObjectsAsFaults = false
        
        var results : NSArray = managedObjectContext!.executeFetchRequest(request, error: nil)!
        
        for cred in results {
            managedObjectContext?.deleteObject(cred as! NSManagedObject)
        }
        
        managedObjectContext?.save(nil)
        
        return
    }
    
    
    //*********************************************************************************
    // DONATIONS
    //*********************************************************************************
    
    public func createDonation(donation:NewDonation!){
        
        if(isLoggedIn()){
            var parameters:String = "?user_credentials=\(singleAccessToken)"
            var request = NSMutableURLRequest(URL: NSURL(string: serverAddress + "/donations" + parameters)!)
            request.HTTPMethod = "POST"
            
            //preparo il body
            var postString = "{ \"donation\" : {  "
            postString += "\"description\": \"\(donation.getDescription())\","
            postString += "\"parcel_size\": \(donation.getParcelSize()),"
            postString += "\"unit\": \"\(donation.getParcelUnit().description)\","
            postString += "\"product_date\": \"\(donation.getProductDate().getDateString())\","
            postString += "\"product_type\": \"\(donation.getProductType().description)\""
            /*    if(donation.photo != nil){
            postString += "\"photo\": \(donation.photo)"
            } */
            postString += " } } "
            println(postString)
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            sendRequest(request, notification_key: donationCreatedNotificationKey)
        }
        else{
            ModelUpdater.getInstance().notifyNotLoggedInError(donationCreatedNotificationKey)
        }
    }
    
    public func getOthersDonations(){
        if(isLoggedIn()){
            var parameters:String = "?user_credentials=\(singleAccessToken)"
            var request = NSMutableURLRequest(URL: NSURL(string: serverAddress + "/donations/" + parameters)!)
            request.HTTPMethod = "GET"
            sendRequest(request, notification_key: getOthersDonationNotificationKey)
        }
        else{
            ModelUpdater.getInstance().notifyNotLoggedInError(getOthersDonationNotificationKey)
        }
    }
    
    public func getMyDonations(){
        if(isLoggedIn()){
            var parameters:String = "?user_credentials=\(singleAccessToken)"
            var request = NSMutableURLRequest(URL: NSURL(string: serverAddress + "/my_donations/" + parameters)!)
            request.HTTPMethod = "GET"
            sendRequest(request, notification_key: getMyDonationNotificationKey)
        }
        else{
            ModelUpdater.getInstance().notifyNotLoggedInError(getMyDonationNotificationKey)
        }
    }
    
    public func getDonationWithId(donation_id: Int){
        if(isLoggedIn()){
            var parameters:String = "\(donation_id)" +
            "?user_credentials=\(singleAccessToken)"
            var request = NSMutableURLRequest(URL: NSURL(string: serverAddress + "/donations/" + parameters)!)
            request.HTTPMethod = "GET"
            sendRequest(request, notification_key: getSingleDonationNotificationKey)
        }
        else{
            ModelUpdater.getInstance().notifyNotLoggedInError(getSingleDonationNotificationKey)
        }
    }
    
    public func deleteDonation(donation_id: Int){
        if(isLoggedIn()){
            var parameters:String = "\(donation_id)" +
            "?user_credentials=\(singleAccessToken)"
            var request = NSMutableURLRequest(URL: NSURL(string: serverAddress + "/donations/" + parameters)!)
            request.HTTPMethod = "DELETE"
            sendRequest(request, notification_key: donationDeletedNotificationKey)
        }
        else{
            ModelUpdater.getInstance().notifyNotLoggedInError(donationDeletedNotificationKey)
        }
    }
    
    
    //*********************************************************************************
    // BOOKINGS
    //*********************************************************************************
    
    //*********************************************************************************
    // USERS
    //*********************************************************************************
    
    public func sendLoginData(email:String, password:String){
        
        var request = NSMutableURLRequest(URL: NSURL(string: serverAddress + "/login")!)
        request.HTTPMethod = "POST"
        
        //preparo il body
        let postString = "{"
            + "\"email\": \"\(email)\","
            + "\"password\": \"\(password)\""
            + "}"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        sendRequest(request, notification_key: loginResponseNotificationKey)
    }
    
    public func logout(){
        if(isLoggedIn()){
            var parameters:String = "?user_credentials=\(singleAccessToken)"
            var request = NSMutableURLRequest(URL: NSURL(string: serverAddress + "/logout" + parameters)!)
            request.HTTPMethod = "GET"
            singleAccessToken = ""
            userId = 0
            deleteCredentials()
            sendRequest(request, notification_key: logoutResponseNotificationKey)
        }
        else{
            ModelUpdater.getInstance().notifyNotLoggedInError(logoutResponseNotificationKey)
        }
    }
    
    public func getEmailAvailability(email:String){
        var request = NSMutableURLRequest(URL: NSURL(string: serverAddress + "/users/check_email_available")!)
        request.HTTPMethod = "POST"
        
        //preparo il body
        let postString = "{"
            + "\"email_to_check\": \"\(email)\""
            + "}"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        sendRequest(request, notification_key: mailAvailabilityResponseNotificationKey)
    }
    
    public func getUserInfo(){
        if(isLoggedIn()){
            var parameters:String = "?user_credentials=\(singleAccessToken)"
            var request = NSMutableURLRequest(URL: NSURL(string: serverAddress + "/users/\(userId)" + parameters)!)
            request.HTTPMethod = "GET"
            sendRequest(request, notification_key: userInfoResponseNotificationKey)
        }
        else{
            ModelUpdater.getInstance().notifyNotLoggedInError(userInfoResponseNotificationKey)
        }
    }
    
    public func getSettings(){
        if(isLoggedIn()){
            var parameters:String = "?user_credentials=\(singleAccessToken)"
            var request = NSMutableURLRequest(URL: NSURL(string: serverAddress + "/settings/" + parameters)!)
            request.HTTPMethod = "GET"
            sendRequest(request, notification_key: getSettingsResponseNotificationKey)
        }
        else{
            ModelUpdater.getInstance().notifyNotLoggedInError(getSettingsResponseNotificationKey)
        }
    }
    
    //*********************************************************************************
    // NOTIFICATIONS
    //*********************************************************************************
    
    public func getNotifications(){
        if(isLoggedIn()){
            var parameters:String = "?user_credentials=\(singleAccessToken)"
            var request = NSMutableURLRequest(URL: NSURL(string: serverAddress + "/notifications" + parameters)!)
            request.HTTPMethod = "GET"
            sendRequest(request, notification_key: getNotificationsResponseNotificationKey)
        }
        else{
            ModelUpdater.getInstance().notifyNotLoggedInError(getNotificationsResponseNotificationKey)
        }
    }
    
    //*********************************************************************************
    // PRIVATE
    //*********************************************************************************
    
    private func sendRequest(request : NSMutableURLRequest, notification_key : String){
        
        //completo l'header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Token token=\"\(securityToken)\"", forHTTPHeaderField: "Authorization")
        
        //preparo il dialogo con il server
        var session = NSURLSession.sharedSession()
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if(error == nil){
                
                let response_status = (response as! NSHTTPURLResponse).statusCode
                
                // attenzione: in swift, gli switch NON hanno
                // l'implicit fallthrough, e NON necessitano dei break
                switch response_status {
                case 200, 201, 204: ModelUpdater.getInstance().notifySuccess(notification_key, data: data)
                case 400, 401, 403, 404, 409, 422: ModelUpdater.getInstance().notifyDataError(notification_key)
                default : ModelUpdater.getInstance().notifyNetworkError(notification_key)
                }
            }
            else{
                // error != nil
                ModelUpdater.getInstance().notifyDeviceError(notification_key)
            }
        })
        
        task.resume()
    }
    
    
    
}

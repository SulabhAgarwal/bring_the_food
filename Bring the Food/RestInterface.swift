//
//  RestInterface.swift
//  Bring the Food
//
//  Created by Stefano Bodini on 03/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import Foundation

public class RestInterface : NSObject{
    
    private let serverAddress: String = "http://dev.ict4g.org/btf/api/v2"
    private let securityToken: String = "e01228ed4aee2b0cd103fa0962f4589a"
    private var userId: Int = 0
    private var singleAccessToken: String = ""
    private let imageCache : NSURLCache
    private var imageSession : NSURLSession!
    private static var instance: RestInterface?
    
    // per fare in modo che il costruttore non sia accessibile all'esterno della classe
    // imposta anche il caching
    private override init() {
        
        self.imageCache = NSURLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "ImageDownloadCache")
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        configuration.URLCache = self.imageCache
        self.imageSession = NSURLSession(configuration: configuration)
        super.init()
    }
    
    public static func getInstance() -> RestInterface{
        if(self.instance == nil){
            self.instance = RestInterface()
        }
        return self.instance!
    }
    
    
    private func clearImageCache(){
        self.imageCache.removeAllCachedResponses()
    }
    
    //TODO
    private func clearRequestCache(){}
    
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
    }
    
    private func storeCredentials(userId : Int, singleAccessToken:String){

        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(singleAccessToken, forKey: singleAccessTokenKey)
        defaults.setInteger(userId, forKey: userIdKey)
    }
    
    // Ritorna vero se il caricamento delle credenziali ha avuto successo, falso altrimenti
    private func loadCredentials() -> Bool {

        let defaults = NSUserDefaults.standardUserDefaults()
        let singleAccessToken = defaults.stringForKey(singleAccessTokenKey)
        let userId = defaults.integerForKey(userIdKey)
        if singleAccessToken != nil
        {
            self.singleAccessToken = singleAccessToken!
            self.userId = userId
        }
        return (self.singleAccessToken != "") && (self.userId != 0)
    }
    
    // Da chiamare in seguito al logout, cancella tutte le credenziali salvate
    private func deleteCredentials() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("", forKey: singleAccessTokenKey)
        defaults.setInteger(0, forKey: userIdKey)

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
        
       /*
            ImageDownloader(url: "http://dev.ict4g.org/btf/system/donations/default/fresh/medium/fresh.jpg",
                type: ImageType.DONATION).downloadImage()
            ModelUpdater.getInstance().notifyDataError(loginResponseNotificationKey)
      */
       
        
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
    public func downloadImage(url:String, imDownloader: ImageDownloader!){
        
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        
        var task = self.imageSession.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            imDownloader.setImage(data, response: response, error: error)
            
        })
        
        task.resume()
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
    
    
    private func sendCachedRequest(request : NSMutableURLRequest, notification_key : String){
        
        //completo l'header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Token token=\"\(securityToken)\"", forHTTPHeaderField: "Authorization")
        
        //preparo il dialogo con il server
        var session = NSURLSession.sharedSession()
        
        //TODO: cambiare la sessione con una sessione che mantenga la cache, e salvare tale sessione come variabile di 
        // classe, come fatto con la cache di immagini.
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if(error == nil){
                
                let response_status = (response as! NSHTTPURLResponse).statusCode
                
                // attenzione: in swift, gli switch NON hanno
                // l'implicit fallthrough, e NON necessitano dei break
                switch response_status {
                case 200, 201, 204:
                    // salvo il risultato in cache
                    ModelUpdater.getInstance().notifySuccess(notification_key, data: data)
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
    
    private func lookForResponseInCache(/*prende come parametri la url e il tipo di errore*/){
        // ricerco la url nella cache
        
        // se trovo, invio notify success
        
        
        // se non trovo il risultato in cache
        // se l'errore era di device chiamo notify device error
        // se l'errore era di network chiamo notify network error
        
    }
    
    
}

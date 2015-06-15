//
//  File.swift
//  Bring the Food
//
//  Created by Stefano Bodini on 14/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import Foundation

public class ImageDownloader : NSObject{
    
    public func getImage(){
        //
        var request = NSMutableURLRequest(URL: NSURL(string: "http://dev.ict4g.org/btf/system/donations/default/fresh/medium/fresh.jpg")!)
        request.HTTPMethod = "GET"
        let notification_key = imageReceivedNotificationKey
        
        //preparo il dialogo con il server
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        let session = NSURLSession(configuration: configuration)
        
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
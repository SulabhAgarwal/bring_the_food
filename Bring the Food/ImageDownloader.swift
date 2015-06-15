//
//  File.swift
//  Bring the Food
//
//  Created by Stefano Bodini on 14/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import Foundation
import UIKit


/*
    Esegue il download dalla url con cui è stato inizializzato.
    La politica di caching assicura che ogni immagine sia scaricata solo una volta dal server.
    Nel caso dovesse fallire, recupera le immagini previste di default.
    Fatto questo, invia una notifica in cui segnala che l'immagine è disponibile.
*/

public class ImageDownloader{
    
    private let url:String!
    private let type: ImageType!
    private var image: UIImage?
    
    public init(url:String!, type: ImageType!){
        self.url = url
        self.type = type
    }
    
    public func downloadImage(){
        RestInterface.getInstance().downloadImage(self.url, imDownloader: self)
    }
    
    public func setImage(data: NSData!, response: NSURLResponse!, error:NSError!){
        
            println("down")
        
            if(error == nil && data != nil){
                //immagine correttamente disponibile
                self.image = UIImage(data: data)
                println("ok")
            }
            else{
                if self.type == ImageType.AVATAR {
                    //carico l'immagine di default per utenti
                    
                } else {
                    //carico l'immagine di default per donazioni
                    
                }
                
            }
            
            // In ogni caso, qui mando la stessa notifica
            NSNotificationCenter.defaultCenter().postNotificationName(
                imageDownloadNotificationKey,
                object: self)

    }

}


//
//  DetailViewController.swift
//  Bring the Food
//
//  Created by federico badini on 18/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class DetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var infoPanelView: UIView!
    
    var donation: StoredDonation?
    let regionRadius: CLLocationDistance = 250
    var UIMainColor = UIColor(red: 0xf6/255, green: 0xae/255, blue: 0x39/255, alpha: 1)
    var donationPosition: BtfAnnotation?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainLabel.text = donation?.getDescription()
        infoPanelView.layer.borderColor = UIMainColor.CGColor
        infoPanelView.layer.borderWidth = 1.0
        mapView.layer.borderColor = UIMainColor.CGColor
        mapView.layer.borderWidth = 1.0
        centerMapOnLocation(CLLocation(latitude: CLLocationDegrees(donation!.getSupplier().getAddress().getLatitude()!), longitude: CLLocationDegrees(donation!.getSupplier().getAddress().getLongitude()!)))
        donationPosition = BtfAnnotation(title: donation!.getDescription(),
            offerer: donation!.getSupplier().getName(), address: donation!.getSupplier().getAddress().getLabel()!, coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(donation!.getSupplier().getAddress().getLatitude()!), longitude: CLLocationDegrees(donation!.getSupplier().getAddress().getLongitude()!)))
        mapView.addAnnotation(donationPosition)
        mapView.delegate = self
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? BtfAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -8, y: 0)
                var launchNavigator: UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
                launchNavigator.setImage(UIImage(named: "launch_navigator")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), forState: UIControlState.Normal)
                view.rightCalloutAccessoryView = launchNavigator as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
        calloutAccessoryControlTapped control: UIControl!) {
            let location = view.annotation as! BtfAnnotation
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
}


class BtfAnnotation: NSObject, MKAnnotation {
    let title: String
    let subtitle: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, offerer: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = offerer
        self.address = address
        self.coordinate = coordinate
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): address]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}


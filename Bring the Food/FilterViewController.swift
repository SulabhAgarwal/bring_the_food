//
//  FilterViewController.swift
//  Bring the Food
//
//  Created by federico badini on 16/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import Foundation
import UIKit

class FilterViewController: UIViewController {
    
    var delegate: FilterProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        self.delegate?.handleFiltering()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        // Set light content status bar
        return UIStatusBarStyle.LightContent
    }
}

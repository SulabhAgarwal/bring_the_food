//
//  DetailViewController.swift
//  Bring the Food
//
//  Created by federico badini on 18/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}


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
    var filterState: FilterState?
    @IBOutlet weak var frozenFoodButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frozenFoodButton.setImage(UIImage(named: "frozen"), forState: UIControlState.Selected)
        frozenFoodButton.highlighted = false
        if(filterState!.isFrozenFood){
            frozenFoodButton.selected = true
        }
        else{
            frozenFoodButton.selected = false
        }
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        self.delegate?.handleFiltering(filterState!)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        // Set light content status bar
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func frozenFoodButtonPressed(sender: UIButton) {
        if(filterState!.isFrozenFood){
            frozenFoodButton.selected = false
            filterState!.isFrozenFood = false
        }
        else{
            frozenFoodButton.selected = true
            filterState!.isFrozenFood = true
        }
    }
    
}

struct FilterState{
    var isFrozenFood: Bool
}

//
//  LoginController.swift
//  Bring the Food
//
//  Created by federico badini on 04/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UIActionSheetDelegate {
    
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var btfViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btfViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldsCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldsView: UIView!
    
    // Interface colors
    var UIMainColor = UIColor(red: 0xf6/255, green: 0xae/255, blue: 0x39/255, alpha: 1)
    var textFieldBorderColor = UIColor(red: 0xe9/255, green: 0xe9/255, blue: 0xe9/255, alpha: 1)
    var buttonBorderColor = UIColor(red: 0xf8/255, green: 0xd0/255, blue: 0x8f/255, alpha: 1)
    
    // Keyboard height
    var kbHeight: CGFloat!
    
    
    // OVERRIDES
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInterface()
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        // Register as notification center observer
        NSNotificationCenter.defaultCenter().addObserverForName(loginResponseNotificationKey,
            object: ModelUpdater.getInstance(),
            queue: NSOperationQueue.mainQueue(),
            usingBlock: {(notification:NSNotification!) in self.loginResponseHandler(notification)})
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification,
            object: nil, queue: NSOperationQueue.mainQueue(),
            usingBlock: {(notification:NSNotification!) in self.keyboardWillShow(notification)})
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification,
            object: nil, queue: NSOperationQueue.mainQueue(),
            usingBlock: {(notification:NSNotification!) in self.keyboardWillHide(notification)})
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Recognize tap on the vieww
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTapOnView:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Unregister as notification center observer
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        // Set light content status bar
        return UIStatusBarStyle.LightContent
    }
    
    
    // FUNCTIONS
    
    
    // On focus textField behaviours
    @IBAction func emailOnFocus(sender: UITextField) {
        emailImageView.hidden = true
        if(sender.text == "Email"){
            sender.text = ""
        }
    }
    
    @IBAction func passwordOnFocus(sender: UITextField) {
        passwordImageView.hidden = true
        if(sender.text == "Password"){
            sender.text! = ""
            sender.secureTextEntry = true
        }
    }
    
    // Off focus textField behaviours
    @IBAction func emailOffFocus(sender: UITextField) {
        if (sender.text.isEmpty){
            emailImageView.hidden = false
            sender.text = "Email"
        }
    }
    
    @IBAction func passwordOffFocus(sender: UITextField) {
        if (sender.text.isEmpty){
            passwordImageView.hidden = false
            sender.text = "Password"
            sender.secureTextEntry = false
        }
    }
    
    @IBAction func reactToFieldsInteraction(sender: UITextField) {
        if (emailTextField.text != "" && passwordTextField.text != ""
            && (passwordTextField.secureTextEntry == true)){
                logInButton.enabled = true
        }
        else{
            logInButton.enabled = false
        }
    }
    
    // Login button pressed
    @IBAction func performLogin(sender: UIButton) {
        RestInterface.getInstance().sendLoginData(emailTextField.text, password: passwordTextField.text)
        self.view.endEditing(true)
        activityIndicatorView.startAnimating()
    }
    
    // Need help pressed
    @IBAction func displayActionSheet(sender: UIButton) {
        if( controllerAvailable()){
            displayIOS8ActionSheet()
        } else {
            displayIOS7ActionSheet()
        }
    }
    
    
    // FUNCTIONS
    
    
    // User interface settings
    func setUpInterface() -> Void {
        self.view.backgroundColor = UIMainColor
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = textFieldBorderColor.CGColor
        emailTextField.layer.cornerRadius = 3
        emailTextField.textColor = UIMainColor
        emailTextField.text = "Email"
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = textFieldBorderColor.CGColor
        passwordTextField.layer.cornerRadius = 3
        passwordTextField.textColor = UIMainColor
        passwordTextField.text = "Password"
        logInButton.layer.borderWidth = 1
        logInButton.layer.borderColor = buttonBorderColor.CGColor
        logInButton.layer.cornerRadius = 3
        logInButton.enabled = false
    }
    
    // Handle login response
    func loginResponseHandler(notification: NSNotification){
        let response = (notification.userInfo as! [String : HTTPResponseData])["info"]
        if(response!.status == RequestStatus.SUCCESS){
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let rootController = storyboard?.instantiateInitialViewController() as! UIViewController
            appDelegate.window?.rootViewController = rootController
        }
        else{
            let alert = UIAlertView()
            alert.title = "Login failed"
            alert.message = "The inserted email-password couple is wrong!"
            alert.addButtonWithTitle("Dismiss")
            alert.show()
        }
        activityIndicatorView.stopAnimating()
    }
    
    // Delegate method for tapping
    func handleTapOnView(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // Check if alert controller is available in the current iOS version
    func controllerAvailable() -> Bool {
        if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
            return true;
        }
        else {
            return false;
        }
    }
    
    // Action sheet display in iOS8
    func displayIOS8ActionSheet() -> Void {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let forgotPassword = UIAlertAction(title: "Forgot Password?", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string:"http://www.bringfood.org/")!)
        })
        let helpCenter = UIAlertAction(title: "Help Center", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string:"http://www.bringfood.org/public/guide")!)
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {(alert:UIAlertAction!) -> Void in}
        optionMenu.addAction(forgotPassword)
        optionMenu.addAction(helpCenter)
        optionMenu.addAction(cancelButton)
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    // Action sheet display in iOS7
    func displayIOS7ActionSheet() -> Void {
        var actionSheet:UIActionSheet
        actionSheet = UIActionSheet(title: nil, delegate: nil, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        actionSheet.addButtonWithTitle("Forgot Password?")
        actionSheet.addButtonWithTitle("Help Center")
        actionSheet.delegate = self
        actionSheet.showInView(self.view)
    }
    
    // Action sheet delegate for iOS7
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        if (buttonIndex == 1){
            UIApplication.sharedApplication().openURL(NSURL(string:"http://www.bringfood.org/")!)
        }
        else if(buttonIndex == 2){
            UIApplication.sharedApplication().openURL(NSURL(string:"http://www.bringfood.org/public/guide")!)
        }
    }
    
    // Called when keyboard appears on screen
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                self.animateTextField(true)
            }
        }
    }
    
    // Called when keyboard disappears from screen
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(false)
    }
    
    // Perform animations when keyboard appears
    func animateTextField(up: Bool) {
        if(up){
            if(self.view.frame.height - self.textFieldsView.center.y - self.textFieldsView.frame.height/2 < kbHeight + 20){
                UIView.animateWithDuration(0.3, animations: {
                    self.textFieldsTopConstraint.constant -= self.kbHeight + 20 - (self.view.frame.height - self.textFieldsView.center.y - self.textFieldsView.frame.height/2)
                    self.textFieldsBottomConstraint.constant += self.kbHeight + 20 - (self.view.frame.height - self.textFieldsView.center.y - self.textFieldsView.frame.height/2 )
                    self.textFieldsCenterYConstraint.constant += self.kbHeight + 20 - (self.view.frame.height - self.textFieldsView.center.y - self.textFieldsView.frame.height/2 )
                    self.btfViewTopConstraint.constant -= 300
                    self.btfViewBottomConstraint.constant += 300
                    self.view.layoutIfNeeded()
                })
            }
        }
        else {
            UIView.animateWithDuration(0.3, animations: {
                self.textFieldsTopConstraint.constant = 0
                self.textFieldsBottomConstraint.constant = 0
                self.textFieldsCenterYConstraint.constant = -14
                self.btfViewTopConstraint.constant = 0
                self.btfViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
}
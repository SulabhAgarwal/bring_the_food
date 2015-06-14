//
//  SignInViewController.swift
//  Bring the Food
//
//  Created by federico badini on 07/06/15.
//  Copyright (c) 2015 Federico Badini, Stefano Bodini. All rights reserved.
//

import UIKit

class SignInStep1ViewController: UIViewController {
    
    @IBOutlet weak var confirmPasswordImageView: UIImageView!
    @IBOutlet weak var passwordImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var btfViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btfViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldsCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldsView: UIView!
    
    var UIMainColor = UIColor(red: 0xf6/255, green: 0xae/255, blue: 0x39/255, alpha: 1)
    var textFieldBorderColor = UIColor(red: 0xe9/255, green: 0xe9/255, blue: 0xe9/255, alpha: 1)
    var buttonBorderColor = UIColor(red: 0xf8/255, green: 0xd0/255, blue: 0x8f/255, alpha: 1)
    
    weak var mailObserver:NSObjectProtocol?
    weak var keyboardWillShowObserver:NSObjectProtocol?
    weak var keyboardWillHideObserver:NSObjectProtocol?
    var tapRecognizer:UITapGestureRecognizer!
    
    var kbHeight: CGFloat!
    
    
    // OVERRIDES
    
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        // Register as notification center observer
        mailObserver = NSNotificationCenter.defaultCenter().addObserverForName(mailAvailabilityResponseNotificationKey,
            object: ModelUpdater.getInstance(),
            queue: NSOperationQueue.mainQueue(),
            usingBlock: {(notification:NSNotification!) in self.emailAvailabilityHandler(notification)})
        keyboardWillShowObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification,
            object: nil, queue: NSOperationQueue.mainQueue(),
            usingBlock: {(notification:NSNotification!) in self.keyboardWillShow(notification)})
        keyboardWillHideObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification,
            object: nil, queue: NSOperationQueue.mainQueue(),
            usingBlock: {(notification:NSNotification!) in self.keyboardWillHide(notification)})
        // Set tap recognizer on the view
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTapOnView:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInterface()
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Unregister as notification center observer
        NSNotificationCenter.defaultCenter().removeObserver(mailObserver!)
        NSNotificationCenter.defaultCenter().removeObserver(keyboardWillShowObserver!)
        NSNotificationCenter.defaultCenter().removeObserver(keyboardWillHideObserver!)
        self.view.removeGestureRecognizer(tapRecognizer)
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToSignUpStep2") {
            var DestViewController : SignInStep2ViewController = segue.destinationViewController as! SignInStep2ViewController
            DestViewController.email = emailTextField.text
            DestViewController.password = passwordTextField.text
        }
    }
    
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
    
    @IBAction func confirmPasswordOnFocus(sender: UITextField) {
        confirmPasswordImageView.hidden = true
        if(sender.text == "Confirm Password"){
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
    
    @IBAction func confirmPasswordOffFocus(sender: UITextField) {
        if (sender.text.isEmpty){
            confirmPasswordImageView.hidden = false
            sender.text = "Confirm Password"
            sender.secureTextEntry = false
        }
    }
    
    @IBAction func reactToFieldsInteraction(sender: UITextField) {
        if (emailTextField.text != "" && passwordTextField.text != ""
            && (passwordTextField.secureTextEntry == true)
            && confirmPasswordTextField.text != "" && (confirmPasswordTextField.secureTextEntry == true)){
                nextButton.enabled = true
        }
        else{
            nextButton.enabled = false
        }
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        if(!isValidEmail(emailTextField.text)){
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Invalid email"
            alert.addButtonWithTitle("Dismiss")
            alert.show()
        }
        else if(passwordTextField.text != confirmPasswordTextField.text){
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Password Mismatch"
            alert.addButtonWithTitle("Dismiss")
            alert.show()
        }
        else{
            RestInterface.getInstance().getEmailAvailability(emailTextField.text)
        }
    }
    
    @IBAction func abortRegistration(sender: UIButton) {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func learnMoreButtonPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string:"http://www.bringfood.org/")!)
        
    }
    func setUpInterface() -> Void {
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
        confirmPasswordTextField.layer.borderWidth = 1
        confirmPasswordTextField.layer.borderColor = textFieldBorderColor.CGColor
        confirmPasswordTextField.layer.cornerRadius = 3
        confirmPasswordTextField.textColor = UIMainColor
        confirmPasswordTextField.text = "Confirm Password"
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = buttonBorderColor.CGColor
        nextButton.layer.cornerRadius = 3
        nextButton.enabled = false
    }
    
    func handleTapOnView(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func emailAvailabilityHandler(notification: NSNotification){
        let response = (notification.userInfo as! [String : HTTPResponseData])["info"]
        if(response!.status == RequestStatus.SUCCESS){
            performSegueWithIdentifier("goToSignUpStep2", sender: nil)
        }
        else{
            let alert = UIAlertView()
            alert.title = "Email not available"
            alert.message = "The inserted email is already taken!"
            alert.addButtonWithTitle("Dismiss")
            alert.show()
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
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
            if(self.view.frame.height - self.textFieldsView.center.y - self.textFieldsView.frame.height/2 < kbHeight + 10){
                UIView.animateWithDuration(0.3, animations: {
                    self.textFieldsTopConstraint.constant -= self.kbHeight + 10 - (self.view.frame.height - self.textFieldsView.center.y - self.textFieldsView.frame.height/2)
                    self.textFieldsBottomConstraint.constant += self.kbHeight + 10 - (self.view.frame.height - self.textFieldsView.center.y - self.textFieldsView.frame.height/2 )
                    self.textFieldsCenterYConstraint.constant += self.kbHeight + 10 - (self.view.frame.height - self.textFieldsView.center.y - self.textFieldsView.frame.height/2 )
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


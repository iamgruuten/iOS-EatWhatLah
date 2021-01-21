//
//  EmailViewContrller.swift
//  EatWhatLah
//
//  Created by Apple on 21/1/21.
//
//This controller is used to manage sign in and create account


import UIKit
import FirebaseAuth
import Firebase

class EmailViewController : UIViewController{
    
    let user:User = User();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var appDelegate:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    @IBAction func nextBtnOnClick(_ sender: Any) {
        let email:String = emailField.text!;
        
        //Empty email
        if(email == ""){
            emailField.layer.borderColor = UIColor.red.cgColor
            emailField.layer.borderWidth = 1.0
            
        }
        
        //Check if email is valid using regex
        else if(email.isValidEmail){
            
            //Check if email is existed before proceeding
            Auth.auth().fetchSignInMethods(forEmail: email, completion: { (signInMethods, error) in
                if(signInMethods == nil){
                    
                    print("Email does not exist")
                    //Proceed
                    self.user.email = email
                    print(email)
                    self.performSegue(withIdentifier: "setPasswordDetails", sender: nil)
                    
                }else{
                    
                    print("Email exist")
                    let alert = UIAlertController(title: "Oh No!", message: "This email is already being used", preferredStyle: UIAlertController.Style.alert)
                    
                    // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default, handler: { _ in
                        self.emailField.text = "";
                        self.dismiss(animated: true, completion: nil)
                        
                    }))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            )
            
        }else{
            // create the alert
            let alert = UIAlertController(title: "Invalid Email", message: "Please Enter a valid email address", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default, handler: { _ in
                
                self.dismiss(animated: true, completion: nil)
                
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //Work around to check if email registed in system
    //    func emailCheck(input: String, callback: @escaping (_ isValid: Bool) -> Void) {
    //        Auth.auth().signIn(withEmail: input, password: " ") { (user, error) in
    //            var canRegister = false
    //            let authError = error! as NSError
    //
    //            if error != nil {
    //                if (authError.code == 17009) {
    //                    canRegister = false
    //                } else if(authError.code == 17011) {
    //                    //email doesn't exist
    //                    canRegister = true
    //                }
    //            }
    //
    //            callback(canRegister)
    //        }
    //    }
    
}



//
//  editProfileController.swift
//  EatWhatLah
//
//  Created by Apple on 2/2/21.
//

import UIKit
import LocalAuthentication


class editProfileController:ViewController{
    
    let firebaseController:FirebaseController = FirebaseController();
    let userController:UserController = UserController();
    
    var appDelegate:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextFIeld: UITextField!
    @IBOutlet var bioTextField: UITextView!
    @IBOutlet var faceButton: UISwitch!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var confirmtextField: UITextField!
    
    
    let localAuthenticationContext = LAContext()
    var authorizationError: NSError?
    let reason = "Authentication is required for you to continue"

    
    @IBOutlet var profileImage: UIImageView!
    
    override func viewDidLoad() {
        self.setupToHideKeyboardOnTapOnView()
        let user = appDelegate.user;
        nameTextField.text = user.name;
        emailTextFIeld.text = user.email;
        bioTextField.text = user.bio;
        faceButton.isOn = user.locked;
        profileImage.image = user.profilePicture
    }
    
    // MARK - Actions
    
    @IBAction func doneOnClick(_ sender: Any) {
        //Done
        let name:String = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines);
        let bio:String = bioTextField.text.trimmingCharacters(in: .whitespacesAndNewlines);
        
        let locked:Bool = faceButton.isOn;
        
        if(name != "" && bio != ""){
            firebaseController.updateUserDetails(name: name, bio: bio, uid: appDelegate.user.uid)
            userController.updateUser(name: name, bio: bio, uid: appDelegate.user.uid, locked: locked)
            
           
            self.appDelegate.user.bio = bio;
            self.appDelegate.user.name = name;
            self.appDelegate.user.locked = locked;
            self.dismiss(animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController(title: "Oh No!", message: "Please fill in the field", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //Update password of user
    //Ensures that both matches, 8 characters long and empty field
    @IBAction func passwordChange(_ sender: Any) {
        //Change Password
        let newPassword = newPasswordTextField.text
        let confirmPassword = confirmtextField.text
        
        if(newPassword != ""){
            
            if(newPassword == confirmPassword){
                
                if(newPassword?.count == 8){
                    firebaseController.passwordUpdate(newPassword: confirmPassword!){
                        success in
                        
                        if(success){
                            
                            let alert = UIAlertController(title: "Password Changed", message: "Successfully changed", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default, handler:{_ in
                                
                                
                                self.dismiss(animated: false, completion: nil)
                                
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            
                        }
                    }
                }else{
                    
                    newPasswordTextField.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    confirmtextField.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                    let alert = UIAlertController(title: "Oh No!", message: "Password must be at least 8 characters", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler:{_ in
                        
                        self.newPasswordTextField.text = ""
                        self.confirmtextField.text = ""
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }else{
                newPasswordTextField.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                confirmtextField.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                let alert = UIAlertController(title: "Oh No!", message: "Password does not match", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler:{_ in
                    
                    self.newPasswordTextField.text = ""
                    self.confirmtextField.text = ""
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            newPasswordTextField.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            confirmtextField.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            let alert = UIAlertController(title: "Oh No!", message: "Please fill in the field", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler:{_ in
                
                self.newPasswordTextField.text = ""
                self.confirmtextField.text = ""
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func faceOnClick(_ sender: Any) {
        
            localAuthenticationContext.localizedFallbackTitle = "Please use your Passcode"
            
            if localAuthenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authorizationError) {
                
                let biometricType = localAuthenticationContext.biometryType == LABiometryType.faceID ? "Face ID" : "Touch ID"
                print("Supported Biometric type is: \( biometricType )")
                
                localAuthenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reason) { (success, evaluationError) in
                    if success {
                        print("Success")
                    } else {
                        print("Error \(evaluationError!)")
                        self.faceButton.isOn = false;
                    }
                }
                
            } else {
                print("User has not enrolled into using Biometrics")
                faceButton.isOn = false;

            }
            
            let biometricType = localAuthenticationContext.biometryType == LABiometryType.faceID ? "Face ID" : "Touch ID"
            print("Supported Biometric type is: \( biometricType )")
        
    }
    
    @IBAction func cancelOnClick(_ sender: Any) {
        //Cancel
        self.dismiss(animated: true, completion: nil)
    }
}

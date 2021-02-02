//
//  EmailViewContrller.swift
//  EatWhatLah
//
//  Created by Apple on 21/1/21.
//
//This controller is used to manage create account


import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import SwiftSpinner
import CoreLocation
import FirebaseDatabase

class EmailViewController : UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate{
    
    //AppDelegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
    private lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    let userController:UserController = UserController();

    //Location Services
    var locationManager: CLLocationManager?

    //Password Init
    var password:String = "";
    
    //Firebase
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    @IBAction func imageProfileOnClick(_ sender: Any) {
        
        SwiftSpinner.show("Uploading image")
        //Upload image to google storage
        
        let storage = Storage.storage(url:"gs://eatwhatlah-d17f2.appspot.com")
        
        let storageRef = storage.reference()
        
        let folderRef = storageRef.child("profileImage")
        
        // Collect data from imageView
        let data = imageView.image?.pngData()
        
        appDelegate.user.profilePicture = imageView.image!;
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        // Create a reference to the profile image upload
        let imageRef = folderRef.child(appDelegate.user.uid+".png")
        
        // Upload the file to the path
        let uploadTask = imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            print(size)
            
            imageRef.downloadURL {
                
                (url, error) in
                if url != nil{
                    self.ref = Database.database().reference()
                    
                    self.ref.child("users").child(self.appDelegate.user.uid).updateChildValues(
                        ["profileURL":url?.absoluteString as Any]
                    )
                    
                } else {
                    
                    let alert = UIAlertController(title: "Oops...", message: "An error has occur. Please Try Again", preferredStyle: UIAlertController.Style.alert)
                    
                    // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        
        
        
        uploadTask.observe(.success) { snapshot in
            
            SwiftSpinner.hide()
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "onboard", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "successCreated")
            
            nextViewController.modalPresentationStyle = .fullScreen
            
            self.present(nextViewController, animated:false, completion:nil)
            
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                SwiftSpinner.hide()
                let alert = UIAlertController(title: "An error eccord", message: error.code.description, preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default, handler: { _ in
                    self.confirmPasswordField.text = "";
                    
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func setProfileImageOnClick(_ sender: Any) {
        print("tapped on image view to set users image")
        showOptionsForProfilePicture()
    }
    
    @IBAction func usernameOnClick(_ sender: Any) {
        if(username.text == ""){
            username.layer.borderColor = UIColor.red.cgColor
            username.layer.borderWidth = 1.0
        }else{
            // Create a root reference
            
            ref = Database.database().reference()
            
            // Create a user into firebase database
            ref.child("users").child(appDelegate.user.uid).setValue(
                ["Email": appDelegate.user.email,
                 "Bio": "0",
                 "Name":username.text!,
                 "Preference": "0"
                ]
            )
            
//            //Initialize user favourite places
//            ref.child("favourite").child(appDelegate.user.uid).setValue(
//                [
//                   
//                ]
//            )
            
            appDelegate.user.name = username.text!;
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "onboard", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "profileSB")
            
            nextViewController.modalPresentationStyle = .fullScreen
            
            self.present(nextViewController, animated:false, completion:nil)
        }
    }
    
    //Back Button On Click to dimiss
    @IBAction func backButn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    //Back Button On Click
    @IBAction func backBtnOnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //Next button for confirmation password field
    @IBAction func nextConfirmPasswordBtnOnClick(_ sender: Any) {
        
        password = confirmPasswordField.text!;
        print(password)
        
        //Empty email
        if(password == ""){
            confirmPasswordField.layer.borderColor = UIColor.red.cgColor
            confirmPasswordField.layer.borderWidth = 1.0
        }else{
            if(appDelegate.user.password != password){
                let alert = UIAlertController(title: "Try Again", message: "Does not match with your password", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default, handler: { _ in
                    self.confirmPasswordField.text = "";
                    
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }else{
                view.endEditing(true)
                
                //Creating of account starts here
                SwiftSpinner.show("Creating Account..")
                
                SwiftSpinner.show(delay: 2.0, title: "It's taking longer than expected")
                let email:String = appDelegate.user.email;
                let password:String = appDelegate.user.password;
                
                Auth.auth().createUser(withEmail: email, password: password) {_, error in
                    
                    if let error = error as NSError? {
                        print(AuthErrorCode(rawValue: error.code)!)
                    } else {
                        print("User signs up successfully")
                        let newUserInfo = Auth.auth().currentUser
                        let email = newUserInfo?.email
                        self.appDelegate.user.uid = newUserInfo!.uid;
                        
                        print(email!);
                        SwiftSpinner.hide();
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "onboard", bundle:nil)
                        
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "usernameSB")
                        
                        nextViewController.modalPresentationStyle = .fullScreen
                        
                        self.present(nextViewController, animated:false, completion:nil)
                    }
                    
                }
                
            }
        }
        
    }
    
    //Next button for password field under register
    @IBAction func nextPasswordBtnOnClick(_ sender: Any) {
        password = passwordField.text!;
        
        //Empty email
        if(password == ""){
            passwordField.layer.borderColor = UIColor.red.cgColor
            passwordField.layer.borderWidth = 1.0
        }else{
            
            if(password.count > 7){
                appDelegate.user.password = password;
                print(appDelegate.user.password)
                let storyBoard : UIStoryboard = UIStoryboard(name: "onboard", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "retypePassword")
                
                nextViewController.modalPresentationStyle = .fullScreen
                
                self.present(nextViewController, animated:false, completion:nil)
                
            }else{
                let alert = UIAlertController(title: "Weak Password!", message: "Minimum 8 character length", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default, handler: { _ in
                    self.passwordField.text = "";
                    
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                
            }
        }
    }
    
    //Next button for email field under register
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
                    
                    self.appDelegate.user.email = email;
                    self.appDelegate.user.bio = "0";

                    print(self.appDelegate.user.email )
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "onboard", bundle:nil)
                    
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "setPasswordDetails") as! UINavigationController
                    
                    nextViewController.modalPresentationStyle = .fullScreen
                    
                    
                    self.present(nextViewController, animated:true, completion:nil)
                    
                    
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
            alert.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func enableLocationOnClick(_ sender: Any) {
        locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestAlwaysAuthorization()

            view.backgroundColor = .gray
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    //Go to main page
                    self.userController.AddUser(user: self.appDelegate.user)

                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let nextViewController = storyBoard.instantiateInitialViewController()!
                    
                    nextViewController.modalPresentationStyle = .fullScreen
                    
                    self.present(nextViewController, animated:false, completion:nil)
                }
            }
        }else if status == .denied{
            //User deny request
            let alert = UIAlertController(title: "We need your location", message: "No location found, please enable location service", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Action Sheet
    @IBAction func showOptionsForProfilePicture() {
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take a picture", style: .default , handler:{ (UIAlertAction)in
            print("User click picture button")
            self.imagePicker.cameraAccessRequest();
        }))
        
        alert.addAction(UIAlertAction(title: "Select photo from album", style: .default , handler:{ (UIAlertAction)in
            print("User click album button")
            self.imagePicker.photoGalleryAccessRequest();

        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
            
        }))

        
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

// MARK: ImagePickerDelegate

extension EmailViewController: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        imageView.image = image
        imagePicker.dismiss()
    }
    
    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}

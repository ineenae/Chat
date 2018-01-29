//
//  LoginViewController.swift
//  Chat
//
//  Created by Nora on 22/04/1439 AH.
//  Copyright © 1439 Nora. All rights reserved.
//

import UIKit
import Firebase




class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_image")
        self.view.insertSubview(backgroundImage, at: 0)
        
}
    override func viewDidAppear(_ animated: Bool) {
        if AuthProvider.instance.isLoggedIn() {
        performSegue(withIdentifier: "goToContacts", sender: self)
            
        }
    }

    

    
    @IBAction func loginPressed(_ sender: UIButton) {
   
       guard emailTextField.text != "" && passTextField.text != "" else {
        alertTheUser(title: "Email And Password Are Required", message: "plese enter email and password in the text feilds")
        return
        }
            AuthProvider.instance.login(withEmail: emailTextField.text!, password: passTextField.text!) { (message) in
                if message != nil {
                self.alertTheUser(title: "Problem With Authentication", message: message!)
                }else {

                    self.emailTextField.text = ""
                    self.passTextField.text = ""
                    self.performSegue(withIdentifier: "goToContacts", sender: self)
                }
            }
 }
    
    
    
        
    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard emailTextField.text != "" && passTextField.text != "" else {
            
            
            alertTheUser(title:"Error" , message: "Email address is not valid")
            return
        }
        
        AuthProvider.instance.signUp(withEmail: emailTextField.text!, password: passTextField.text!) { (message) in
            if message != nil {
                
                self.alertTheUser(title: "Wrong", message: "Try again" )
                
            }else {
                
                self.emailTextField.text = ""
                self.passTextField.text = ""
                self.performSegue(withIdentifier: "goToContacts", sender: self)
                
            }
        }
    }
    
 
    
    func alertTheUser (title : String , message : String) {
        
        let alert = UIAlertController(title: title , message: message , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
} //class








































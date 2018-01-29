//
//  AuthProvider.swift
//  Chat
//
//  Created by Nora on 23/04/1439 AH.
//  Copyright © 1439 Nora. All rights reserved.
//

import Foundation
import FirebaseAuth



typealias LoginHandler = (_ msg:String?) -> Void

struct LoginErrorCode {
    
    static let WRONG_PASSWORD = "Worng Password , Please Enter The Correct Password"
    static let INVALID_EMAIL = "Invaild Email Address Please Provide A Real Email Address"
    static let PROBLEM_CONNECTING = "Problem Conecting To Database , Please Try Later"
    static let USER_NOT_FOUND = "User Not Found , Please Register"
    static let EMAIL_ALREADY_IN_USE = "Email Already In Use , Please Use Another Email"
    static let WEAK_PASSWORD = "Password Should Be At Least 6 Character Long"
    
}

class AuthProvider {
    
    
    static let instance = AuthProvider()
    
    var userName = ""
    

    
    //MARK : - Login Func
    
func login(withEmail:String , password: String , loginHandler: LoginHandler?){
        
    Auth.auth().signIn(withEmail: withEmail, password: password) { (user, error) in
            if error != nil {
                self.self.handlerErrors(err: error! as NSError , loginHandler: loginHandler)
            }else {
                loginHandler?(nil)
            }
        }
    }
    
    
    
//MARK: - SignUp Methods
    
func signUp(withEmail:String , password: String , loginHandler: LoginHandler?){
    Auth.auth().createUser(withEmail: withEmail, password: password) { (user, error) in
        if error != nil {
            self.self.handlerErrors(err: error! as NSError, loginHandler: loginHandler)
        }else {
            if user?.uid != nil {
                
                
            //store the user to database
                DatabaseProvider.instance.saveUser(withID: user!.uid, email: withEmail, password: password)
                
            // login the user 
                self.login(withEmail: withEmail, password: password, loginHandler: loginHandler)
            }
        }
    }
    
} // sign up func
    
    
    func isLoggedIn () -> Bool {
        if Auth.auth().currentUser != nil {
           return true
        }
        return false
    }
    
    func logOut() -> Bool {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                return true
            }catch {
                return false
            }
        }
        return true
 }
    
    func userID() -> String {
        return Auth.auth().currentUser!.uid
        
    }
    
            


//MARK: - HandelerError

    func handlerErrors(err:NSError , loginHandler: LoginHandler?) {
        if let errCode = AuthErrorCode(rawValue: err.code) {
            
            switch errCode {
                
            case .wrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)
                break
            case .emailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
                break
            case .invalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break
            case .userNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                break
            case .weakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)
                break
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING)
                break
          
            }
        }
    }

    
}//class







































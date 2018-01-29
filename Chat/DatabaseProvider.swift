//
//  DBProvider.swift
//  Chat
//
//  Created by Nora on 29/04/1439 AH.
//  Copyright © 1439 Nora. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol FetchData:class {
    func dataReceived(contacts : [Contact])
}

class DatabaseProvider {
    
   static let instance = DatabaseProvider()
    
    weak var delegate :FetchData?
    
   
    
    

    var DBRef : DatabaseReference {
        return Database.database().reference()
    }
   
    var contactsRef : DatabaseReference {
        return DBRef.child(Constants.contacts)
        
    }
    var messageRef : DatabaseReference {
        return DBRef.child(Constants.massege)
    }
    var mediaMessagesRef : DatabaseReference {
        return DBRef.child(Constants.mediaMessage)
    }
    
    var storgeRef : StorageReference {
        return Storage.storage().reference(forURL: "gs://chat-d3aa2.appspot.com")
    }
    
    
    
    
    
    
    var mediaRef : StorageReference {
        return storgeRef.child(Constants.mediaMessage)
    }
    var imageRef : StorageReference {
        return storgeRef.child(Constants.imageStorge)
    }
    var videoRef : StorageReference {
        return storgeRef.child(Constants.videoStorge)
    }
    
    
    
    
//    var emailRef : DatabaseReference {
//        return DBRef.child(Constants.email)
//    }
//    var senderRef : DatabaseReference {
//        return DBRef.child(Constants.senderName)
//    }
//    var idRef : DatabaseReference {
//        return DBRef.child(Constants.senderId)
//    }
//
//    var urlRef : DatabaseReference {
//        return DBRef.child(Constants.url)
//    }
//    var textRef : DatabaseReference {
//        return DBRef.child(Constants.text)
//    }
//    var passwordRef : DatabaseReference {
//        return DBRef.child(Constants.password)
//    }
//    var dataRef : DatabaseReference {
//        return DBRef.child(Constants.data)
//    }
    
    
    func saveUser(withID: String , email:String , password: String){
        let data: Dictionary<String,Any> = [Constants.email: email , Constants.password: password]
        
        contactsRef.child(withID).setValue(data)
    }
    
    
    
    func getContacts()  {
       
        contactsRef.observeSingleEvent(of: DataEventType.value) {(snapshot: DataSnapshot) in
            
           var contacts = [Contact]()
            if let myContacts = snapshot.value as? NSDictionary {
          
                for (key,value) in myContacts {
           
                    if let contactData = value as? NSDictionary {
              
                        if let email = contactData [Constants.email] as? String {
                        let id = key as! String
                        let newContact = Contact(name: email, id: id)
                        contacts.append(newContact)
                    }
                }
            }
        }
            
           self.delegate?.dataReceived(contacts: contacts)
    }
       
    }
    
    
    
    
} //class






































































































































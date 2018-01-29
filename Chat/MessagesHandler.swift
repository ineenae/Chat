//
//  MessagesHandler.swift
//  Chat
//
//  Created by Nora on 09/05/1439 AH.
//  Copyright © 1439 Nora. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseCore


protocol MessageReceivedDelegate: class {
    
    func messageRecieved(senderID : String, senderName:String, text: String)
    func mediaReceived(senderID : String, senderName:String, url: String)
}

class MessagesHandler {
    
    
    var protocolDelegat : MessageReceivedDelegate?
    
    static var instance = MessagesHandler()
    
    
    func sendMessage(senderID: String, senderName:String, text:String) {
       
        let data:Dictionary<String, Any> = [Constants.senderId: senderID ,Constants.senderName: senderName, Constants.text: text]
        
        DatabaseProvider.instance.messageRef.childByAutoId().setValue(data)
    }
    
    
    func sendMediaMessage(senderId: String, senderName:String, url:String) {
        
        let data: Dictionary<String, Any> = [Constants.senderId: senderId, Constants.senderName: senderName, Constants.url: url]
        
       DatabaseProvider.instance.mediaMessagesRef.childByAutoId().setValue(data)
    }
    
    
    
    func sendMedia(image:Data?, video:URL?, senderName: String, senderId:String ){
        if image != nil {
         
            DatabaseProvider.instance.imageRef.child(senderId + "\(NSUUID().uuidString).jpg").putData(image!, metadata: nil) { (metadata: StorageMetadata? , err:Error?) in
                
                if err != nil {
                    
                    //inform the user that there was a problem uploading his image
                } else {
                    
                    self.sendMediaMessage(senderId: senderId, senderName: senderName, url: String(describing: metadata!.downloadURL()!))
                    
                }
                
            }
    
        }else{
            
            
            DatabaseProvider.instance.videoRef.child(senderId + "\(NSUUID().uuidString)").putFile(from: video!, metadata: nil) { (metadata:StorageMetadata?, err:Error?) in
                
                if err != nil {
                    
                     //inform the user that there was a problem uploading his video using delegation
                }else {
                    
                     self.sendMediaMessage(senderId: senderId, senderName: senderName, url: String(describing: metadata!.downloadURL()!))
                }
            }
    
        }
    }
    
    
        
    func observeMessages() {
      
        DatabaseProvider.instance.messageRef.observe(DataEventType.childAdded) { (snapshot : DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let senderID = data[Constants.senderId] as? String {
                    if let senderName = data[Constants.senderName] as? String {
                        if let text = data[Constants.text] as? String {
                            self.protocolDelegat?.messageRecieved(senderID: senderID, senderName: senderName, text: text)
                        }
                    }
                }
            }
        }
  
 }
    
    func observeMediaMessages() {
        DatabaseProvider.instance.mediaMessagesRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let id = data[Constants.senderId] as? String {
                    if let name = data[Constants.senderName] as? String {
                        if let fileURL = data[Constants.url] as? String {
                            self.protocolDelegat?.mediaReceived(senderID:id , senderName: name, url: fileURL)
                        }
            }
            }
            }
        }
    }
    
} //class




























































//
//  ChatViewController.swift
//  Chat
//
//  Created by Nora on 22/04/1439 AH.
//  Copyright © 1439 Nora. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import SDWebImage



class ChatViewController: JSQMessagesViewController, MessageReceivedDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    var messages = [JSQMessage]()
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = AuthProvider.instance.userID()
        self.senderDisplayName = AuthProvider.instance.userName
        picker.delegate = self
        MessagesHandler.instance.protocolDelegat = self
        MessagesHandler.instance.observeMessages()
        MessagesHandler.instance.observeMediaMessages()
    }
    // COLLECTION VIEW FUNCATIONS
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "avatar"), diameter: 40)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.item]
        if message.senderId == self.senderId {
            
        return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.gray)
        }
        
        
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
   
   override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
    
    let msg = messages[indexPath.item]
    
    if msg.isMediaMessage {
        if let mediaItem = msg.media as? JSQVideoMediaItem {
            let player = AVPlayer(url: mediaItem.fileURL)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.present(playerController, animated: true, completion: nil)
        }
    }
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as!
        JSQMessagesCollectionViewCell
        return cell
    }
    // END COLLECATION VIEW MESSAGE
    
    
    // SENDING BUTTON
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
//        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
//        collectionView.reloadData()
        
        MessagesHandler.instance.sendMessage(senderID: senderId, senderName: senderDisplayName, text: text)
        
        
        
        //remove the text from text field
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let alert = UIAlertController(title: "Media Messages", message: "Please Select A Media", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let photos = UIAlertAction(title: "Photos", style: .default) { (alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeImage)
        }
        let videos = UIAlertAction(title: "Videos", style: .default) { (alert: UIAlertAction) in
             self.chooseMedia(type: kUTTypeMovie)
        }
        alert.addAction(photos)
        alert.addAction(cancel)
        alert.addAction(videos)
        present(alert, animated: true, completion: nil)
    }
    
    // END SENDING BUTTON
    
    // BICKER VIEW FUNCATIONS
    
    func chooseMedia (type: CFString) {
        picker.mediaTypes = [type as String]
//        picker.allowsEditing = true
//        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pic = info[UIImagePickerControllerOriginalImage]{
            
            let data = UIImageJPEGRepresentation(pic as! UIImage, 0.01)
            
            MessagesHandler.instance.sendMedia(image: data, video: nil, senderName: senderDisplayName, senderId: senderId)
        
        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            
            MessagesHandler.instance.sendMedia(image: nil, video: videoURL , senderName: senderDisplayName, senderId: senderId)
            
        }
        dismiss(animated: true, completion: nil)
        collectionView.reloadData()
            
        }
    
    
    // END BICKER VIEW FUNCATIONS
    
    //DELEGATION FUNCATIONS
    
    func messageRecieved(senderID: String, senderName: String, text: String) {
        messages.append(JSQMessage(senderId: senderID, displayName: "empty", text: text))
        collectionView.reloadData()
    }
    
    func mediaReceived(senderID: String, senderName: String, url: String) {
        if let mediaURL = URL(string: url) {
            do {
                let data = try Data(contentsOf: mediaURL)
                
                if let _ = UIImage(data: data) {
                    
                    let _ = SDWebImageDownloader.shared().downloadImage(with: mediaURL, options: [], progress: nil, completed: { (image, data, error, finished) in
                        
                        DispatchQueue.main.async {
                            let photo = JSQPhotoMediaItem(image: image)
                            if senderID == self.senderId {
                                photo?.appliesMediaViewMaskAsOutgoing = true
                            }else{
                                photo?.appliesMediaViewMaskAsOutgoing = false
                            }
                            self.messages.append(JSQMessage(senderId: senderID, displayName: senderName, media: photo))
                            self.collectionView.reloadData()
                        }
                    })
                    
                }else {
                    let video = JSQVideoMediaItem(fileURL: mediaURL, isReadyToPlay: true)
                    if senderID == self.senderId {
                        video?.appliesMediaViewMaskAsOutgoing = true
                    }else{
                        video?.appliesMediaViewMaskAsOutgoing = false
                    }
                    
                    self.messages.append(JSQMessage(senderId: senderID, displayName: senderName, media: video))
                    self.collectionView.reloadData()
                }
                
            } catch {
                // catch error were we get
            }
        }
        
    }
    
     //END DELEGATION FUNCATIONS
    
 
}// class





























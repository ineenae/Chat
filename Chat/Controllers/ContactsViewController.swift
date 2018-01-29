//
//  ContactsViewController.swift
//  Chat
//
//  Created by Nora on 22/04/1439 AH.
//  Copyright © 1439 Nora. All rights reserved.
//

import UIKit
import Firebase



class ContactsViewController: UITableViewController , FetchData {
    
    var contacts = [Contact]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
      DatabaseProvider.instance.delegate = self
        
      DatabaseProvider.instance.getContacts()
        
        tableView.reloadData()
      
    }

    func dataReceived(contacts: [Contact]) {
        self.contacts = contacts
        
        //get the name for current user
        for Contact in contacts {
            
            if Contact.id == AuthProvider.instance.userID() {
                AuthProvider.instance.userName = Contact.name
                
            }
        }
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = contacts[indexPath.row]._name
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "goToChat", sender: self)
    }
    
    
    
    @IBAction func logOut(_ sender: Any) {
        
        if AuthProvider.instance.logOut() {
        navigationController?.popViewController(animated: true)
        }
        
    }
    

 
}// class



























//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Kristine Laranjo on 2/21/18.
//  Copyright © 2018 Kristine Laranjo. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    var message: [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        message = []
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        // Auto size row height based on cell autolayout constraints
        messageTableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        messageTableView.estimatedRowHeight = 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageTextField.text ?? ""
        chatMessage["user"] = PFUser.current()
        chatMessage.saveInBackground { (success, error) in
            if success {
                self.messageTextField.text = ""
                print("The message was saved!")
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.messageLabel?.text = message[indexPath.row]["text"] as? String
        
        if let user = message[indexPath.row]["user"] as? PFUser {
            // User found! update username label with username
            cell.nameLabel.text = user.username
        } else {
            // No user found, set default username
            cell.nameLabel.text = "🤖"
        }
        
        return cell
    }
    
    @objc func onTimer() {
        onRefresh()
    }
    
    func onRefresh() {
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if error == nil {
                if let messages = messages {
                    for message in messages {
                        print(message["text"])
                    }
                    self.message = messages
                    self.messageTableView.reloadData()
                }
            } else {
                print(error!)
            }
        }
    }
}

//
//  ChatViewController.swift
//  FirebaseLogin
//
//  Created by Yu Jin on 12/12/21.
//

import UIKit
import Firebase
let db = Firestore.firestore()
class ChatViewController: UIViewController {


    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var messages : [Message] = [Message(sender: "1@1", body: "Hi"),Message(sender: "2@2.com", body: "Hey")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        navigationItem.hidesBackButton = true
        title = "Chat Screen"
        loadData()
        // Do any additional setup after loading the view.
        
    }
    func loadData() {
        
        

               db.collection("NewMessages").order(by: "date").addSnapshotListener { (querySnapshot, error) in

                   

                   

                   self.messages = []

                   if let e = error {

                       print("Unable to retrieve")

                   }

                   

                   else {

                       

                       if let snapshotDocuments = querySnapshot?.documents{

                         

                           for doc in snapshotDocuments {

                               

                               print(doc.data())

                               

                               let data = doc.data()

                               

                               if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String

                               {

                                   

                                   let newMessage = Message(sender: messageSender, body: messageBody)

                                   

                                   self.messages.append(newMessage)

                                       

                                       

                                   self.tableView.reloadData()

                                       

                                   

                               }

                           }

                       }
                   }

        
               }
        
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let messagSender = Auth.auth().currentUser?.email,   let messageBody = textField.text

              

           

              {

                  

                  

                  db.collection("NewMessages").addDocument(data: [



                      "sender" : messagSender,

                      "body" : messageBody,

                      "date" : Date().timeIntervalSince1970

                  

                  

                  ]) { (error) in

                      

                      

                      

                      if let e = error {

                          

                          print("Unsuccessful")

                      }

                      

                      else {

                          

                          print("Successful")

                      }

                      

                  }

                  

                  

                  

                  

                  

                  

              }

              

              

              
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
   

    
    @IBAction func signoutPressed(_ sender: Any) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
            
            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
    }
}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return messages.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)as!
            MessageCell
        
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email{
            cell.meImage.isHidden = false
            cell.youImage.isHidden = true
        }
        else {
            cell.meImage.isHidden = true
            cell.youImage.isHidden = false
            
        }
        
        
        return cell
        
        
    }
    
    
    
}

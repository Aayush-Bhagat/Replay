//
//  FriendRequestsViewController.swift
//  Replay
//
//  Created by Aayush Bhagat on 8/6/22.
//

import UIKit
import Firebase
import FirebaseAuth

class FriendRequestsViewController: UITableViewController, FriendRequestCellDelegate {
    
    
    var friendRequests: [User] = []

    @IBOutlet weak var friendRequestLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserFriendRequests()
        self.tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.FriendRequestCell) as! FriendRequestTableViewCell
        
        let user = friendRequests[indexPath.row]
        
        cell.configure(user: user)
        cell.delegate = self
        
        return cell
    }
    
    func didTapAcceptButton(user: User) {
        let curUserId = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        
        db.collection("friends").whereField("user1id", isEqualTo: user.uid).whereField("user2id", isEqualTo: curUserId!).getDocuments { snapshot, err in
            if let snapshot = snapshot{
                let doc = snapshot.documents[0]
                doc.reference.updateData(["status": "friends"])
                
                self.getUserFriendRequests()
            }
        }
    }
    
    func didTapDeclineButton(user: User) {
        let curUserId = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        
        db.collection("friends").whereField("user1id", isEqualTo: user.uid).whereField("user2id", isEqualTo: curUserId!).getDocuments { snapshot, err in
            
            if let snapshot = snapshot{
                let doc = snapshot.documents[0]
                doc.reference.delete()
                
                self.getUserFriendRequests()
            }
        }

    }
    
    func reloadTable(){
        self.tableView.reloadData()
    }
    
    
    func getUserFriendRequests(){
        let curUserId = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        var requests: [User] = []
        
        db.collection("friends").whereField("user2id", isEqualTo: curUserId!).whereField("status", isEqualTo: "requested").getDocuments { snapshot, err in
            
            if let snapshot = snapshot{
                for doc in snapshot.documents{
                    let user = User(firstname: doc["user1firstname"] as! String, lastname: doc["user1lastname"] as! String, pic: doc["user1pic"] as! String, uid: doc["user1id"] as! String, username: doc["user1username"] as! String)
                    
                    requests.append(user)
                }
                
                self.friendRequests = requests
                self.reloadTable()
                
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

}

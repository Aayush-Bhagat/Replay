//
//  FriendsViewController.swift
//  Replay
//
//  Created by Aayush Bhagat on 8/6/22.
//

import UIKit
import Firebase
import FirebaseAuth

class FriendsViewController: UITableViewController {
    
    var friends: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getuserFriends()
        self.tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)

        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.FriendCell) as! FriendsTableViewCell
        
        let user = friends[indexPath.row]
        
        cell.configure(user: user)
        
        return cell
    }
    
    func reloadTable(){
        self.tableView.reloadData()
    }
    
    func getuserFriends(){
        let db = Firestore.firestore()
        
        let curUserId = Auth.auth().currentUser?.uid
        
        var friendData: [User] = []
        
        db.collection("friends").whereField("user1id", isEqualTo: curUserId!).whereField("status", isEqualTo: "friends").getDocuments { snapshot, error in
            
            if let snapshot = snapshot{
                
                for doc in snapshot.documents{
                    
                    let user = User(firstname: doc["user2firstname"] as! String, lastname: doc["user2lastname"] as! String, pic: doc["user2pic"] as! String, uid: doc["user2id"] as! String, username: doc["user2username"] as! String)
                    
                    friendData.append(user)
                }
            }
            
            db.collection("friends").whereField("user2id", isEqualTo: curUserId!).whereField("status", isEqualTo: "friends").getDocuments { snap, err in
                
                if let snap = snap{
                    for doc in snap.documents{
                        let user = User(firstname: doc["user1firstname"] as! String, lastname: doc["user1lastname"] as! String, pic: doc["user1pic"] as! String, uid: doc["user1id"] as! String, username: doc["user1username"] as! String)
                        
                        friendData.append(user)
                    }
                }
                
                self.friends = friendData
                self.reloadTable()
            }
        }
        
    }

}

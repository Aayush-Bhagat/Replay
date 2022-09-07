//
//  SearchFriendsViewController.swift
//  Replay
//
//  Created by Aayush Bhagat on 8/6/22.
//

import UIKit
import Firebase
import FirebaseAuth

class SearchFriendsViewController: UITableViewController, UISearchBarDelegate, SearchFriendTableViewCellDelegate {
    
    
//    @IBOutlet weak var searchFriendsTextField: UITextField!
    var data: [User] = []
    var friendId: [String] = []
    var searchInput = ""
    
    @IBOutlet var searchFriendsTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getuserAllFriends()
        searchBar.delegate = self
        initializeHideKeyboard()
    }
    
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(dismissMyKeyboard))
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
     //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
     //In short- Dismiss the active keyboard.
     view.endEditing(true)
     }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.FriendCellPrototype) as! SearchFriendCell
        
        let user = data[indexPath.row]
        
        cell.isFriendLabel.isHidden = false
        cell.addFriendButton.isHidden = false
        
        if friendId.contains(user.uid){
            cell.addFriendButton.isHidden = true
        }
        else{
            cell.isFriendLabel.isHidden = true
        }
        cell.configure(user: user)
        cell.delegate = self
        
        return cell
    }
    
    func didTapAddFriendButton(user: User) {
        let db = Firestore.firestore()
        let curUserId = Auth.auth().currentUser?.uid
        
        db.collection("users").whereField("uid", isEqualTo: curUserId!).getDocuments { snapshot, error in
            
            if let snapshot = snapshot{
                let userData = snapshot.documents[0]
                let curUser = User(firstname: userData["firstname"] as! String, lastname: userData["lastname"] as! String, pic: userData["pic"] as! String, uid: userData["uid"] as! String, username: userData["username"] as! String)
                
                db.collection("friends").addDocument(data: ["user1id" : curUser.uid, "user1firstname": curUser.firstname, "user1lastname": curUser.lastname, "user1pic": curUser.pic, "user1username": curUser.username, "user2id": user.uid, "user2firstname": user.firstname, "user2lastname": user.lastname, "user2pic": user.pic, "user2username": user.username, "status": "requested"])
            }
            
            self.getuserAllFriends()
            
        }
    }
    
    // MARK: Search Bar Config
    
    func initTable(users: [User]){
        
        data = users
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchInput = searchText
        
        if searchText == ""{
            data = []
            self.tableView.reloadData()
            return
        }
        
        searchUsers(input: searchText)
    }
    
    
    func searchUsers(input: String){
        let db = Firestore.firestore()
        
        var users: [User] = []
        
        db.collection("users").whereField("username", isGreaterThanOrEqualTo: input.uppercased()).getDocuments { snapshot, error in
            if let snapshot = snapshot{
                users = snapshot.documents.map({ document in
                    let user = User(firstname: document["firstname"] as! String, lastname: document["lastname"] as! String, pic: document["pic"] as! String, uid: document["uid"] as! String, username: document["username"] as! String)
                    return user
                })
            }
            
            users = users.filter { User in
                return User.username.lowercased().contains(input.lowercased()) &&  Auth.auth().currentUser?.uid != User.uid
            }
            
            self.initTable(users: users)
        }
        
        
    }
    
    func getuserAllFriends(){
        let db = Firestore.firestore()
        
        let curUserId = Auth.auth().currentUser?.uid
        
        var friendIds: [String] = []
        
        db.collection("friends").whereField("user1id", isEqualTo: curUserId!).getDocuments { snapshot, error in
            
            if let snapshot = snapshot{
                
                for document in snapshot.documents{
                    friendIds.append(document["user2id"] as! String)
                }
            }
            
            db.collection("friends").whereField("user2id", isEqualTo: curUserId!).getDocuments { snap, err in
                
                if let snap = snap{
                    for doc in snap.documents{
                        friendIds.append(doc["user1id"] as! String)
                    }
                }
                
                self.friendId = friendIds

                self.searchUsers(input: self.searchInput)
                
            }
        }
        
    }
    
}

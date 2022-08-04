//
//  VideoModel.swift
//  Replay
//
//  Created by Aayush Bhagat on 8/1/22.
//

import Foundation
import Firebase
import FirebaseAuth

public struct userVideo{
    let postURL: URL
    let uid: String
    let username: String
    let caption : String
    let createdDate: Date
}

func createUserVideo(videoURL: String){
    let db = Firestore.firestore()
    let userUid = Auth.auth().currentUser?.uid
    
    db.collection("users").whereField("uid", isEqualTo: userUid!).getDocuments { snapshot, error in
        if error == nil{
            
            if let snapshot = snapshot {
                let userData = snapshot.documents[0]
                
                db.collection("videos").addDocument(data: ["userUID" : userData["uid"], "videoURL": videoURL, "username": userData["username"],"userPic": userData["pic"], "createdDate": Date.now])
                
            }
        }
    }
}

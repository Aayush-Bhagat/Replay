//
//  VideoPlayback.swift
//  Replay
//
//  Created by Aayush Bhagat on 8/2/22.
//

import UIKit
import AVFoundation
import FirebaseStorage
import Firebase
import FirebaseAuth

class VideoPlayback: UIViewController {
    
        @IBOutlet weak var postButton: UIButton!
        
        @IBOutlet weak var loadingView: UIView!
        
        @IBOutlet weak var spinner: UIActivityIndicatorView!
        
        
        
        
        let avPlayer = AVPlayer()
        var avPlayerLayer: AVPlayerLayer!

        var videoURL: URL!
        //connect this to your uiview in storyboard
        @IBOutlet weak var videoView: UIView!

        override func viewDidLoad() {
            super.viewDidLoad()
            
            postButton.layer.cornerRadius = 20.0
            loadingView.layer.cornerRadius = 25.0
            loadingView.isHidden = true
            self.tabBarController?.tabBar.isHidden = true

            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame = view.bounds
            avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoView.layer.insertSublayer(avPlayerLayer, at: 0)
            
            view.layoutIfNeeded()

            let playerItem = AVPlayerItem(url: videoURL as URL)
            avPlayer.replaceCurrentItem(with: playerItem)

            avPlayer.play()
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(true)
            self.tabBarController?.tabBar.isHidden = false
            videoURL.removeAllCachedResourceValues()
            do {
                try FileManager.default.removeItem(at: videoURL)
            } catch  {
                fatalError()
            }
       }
    
        
        @IBAction func postButtonTapped(_ sender: Any){
            loadingView.isHidden = false
            spinner.startAnimating()
            
            //upload video
            let storageRef = Storage.storage().reference()
        
            let fileRef = storageRef.child("Videos/\(UUID().uuidString).mp4")
            
            let uploadTask = fileRef.putFile(from: videoURL) { metadata, error in
                if error != nil{
                    print(error!)
                }
                else{
                    fileRef.downloadURL { URL, error in
                        if error == nil && URL != nil{
                            createUserVideo(videoURL: URL!.absoluteString)
                            self.loadingView.isHidden=true
                            
                            let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.TabViewController) as? UITabBarController
                            
                            self.view.window?.rootViewController = tabViewController
                            self.view.window?.makeKeyAndVisible()
                            
                        }
                    }
                }
                                                            
            }
            
        }
}


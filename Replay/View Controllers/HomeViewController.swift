//
//  HomeViewController.swift
//  Replay
//
//  Created by Aayush Bhagat on 7/27/22.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        tabBarController?.tabBar.isHidden = false
        
        Auth.auth().addStateDidChangeListener { auth, user in
            
            if user == nil{
                let startViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.startViewController) as? ViewController
                
                self.view.window?.rootViewController = startViewController
                self.view.window?.makeKeyAndVisible()
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

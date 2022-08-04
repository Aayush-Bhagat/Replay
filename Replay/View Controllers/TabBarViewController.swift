//
//  TabBarViewController.swift
//  Replay
//
//  Created by Aayush Bhagat on 7/28/22.
//

import UIKit
import FirebaseAuth

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener { auth, user in
            
            print(user?.uid)
            
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

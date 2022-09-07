//
//  SignUpViewController.swift
//  Replay
//
//  Created by Aayush Bhagat on 7/27/22.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
    }
    
    func setupElements(){
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String? {
        
        //check that all fiellds are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields"
        }
        
        //check if password is secure and valid
        let cleanedPass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if FormUtilities.isPasswordValid(cleanedPass) == false{
            return "Please make sure that password is atleast 8 characters long, contains a special character and a number"
        }
        
        
        return nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //validate fields
        let error = validateFields()
        
        if error != nil{
            showError(error!)
        }
        else{
            //create user
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                
                if let err = err {
                    print(err)
                    self.showError("Error creating user")
                }
                else{
                    
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":firstname, "lastname":lastname, "uid": result!.user.uid , "pic": "" ]) { (error) in
                        
                        if error != nil{
                            self.showError("Error saving user data")
                        }
                    }
                    
                    //transistion to home screen
                    self.transitionToHome()
                }
            }
            
        }
        
    }
    
    func showError(_ message: String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        
        let homeViewController =  storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.TabViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
        
    }
    

}

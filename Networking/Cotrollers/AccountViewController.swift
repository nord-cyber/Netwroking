//
//  AccountViewController.swift
//  Networking
//
//  Created by Vadzim Ivanchanka on 18.01.21.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase
class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        self.nameLabel.isHidden = true
        self.nameLabel.textColor = .black
        self.nameLabel.numberOfLines = 0 
        createFacebookButton()
        
        
    }
    
    // потому что он вызывается каждый раз когда появляется экран в отличии от вью дид лоуд который может просто прогрузиться в память один раз
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.activityIndicator.startAnimating()
       
        fetchDataUserFromFirebase()
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    private func createFacebookButton () {
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: self.view.frame.height - 140, width: self.view.frame.width - 64, height: 50)
        loginButton.delegate = self
        self.view.addSubview(loginButton)
    }


}

extension AccountViewController:LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        
        do{
            
            // выходим из firebase
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                
                let  mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loginStoryboard = mainStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                self.present(loginStoryboard, animated: true, completion: nil)
            }
            
        } catch let error {
            print("error LogOut, \(error.localizedDescription)")
        }
        
    }
    
    
    private func fetchDataUserFromFirebase() {
        
        if Auth.auth().currentUser != nil {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            Database.database().reference()
                .child("users")
                .child(uid).observeSingleEvent(of: .value) { (snapshot) in
                    
                    guard let userData = snapshot.value as? [String:Any] else {return}
                    
                    if let user = FromDatabase(data: userData) {
                        self.activityIndicator.stopAnimating()
                        self.nameLabel.isHidden = false
                        self.nameLabel.text = "\(user.name) \n is logged with Facebook"
                    }
                    
                }
        }
    }
}

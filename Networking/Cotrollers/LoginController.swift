//
//  LoginController.swift
//  Networking
//
//  Created by Vadzim Ivanchanka on 17.01.21.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

// MARK: Ошибка прилетает при попытка заюзать аунтефикацию с помощью гугла! С ФБ все нормально.



class LoginController: UIViewController {

    var user:UserDataModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        createButtonFB()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        // проверка на входил ли пользователь в систему
        if let token = AccessToken.current, !token.isExpired {
            print("We already logged")
        }
       
        self.view.addSubview(loginButtonGoogle)
    }
    
    
    
    lazy var loginButtonGoogle:GIDSignInButton = {
        let loginButton = GIDSignInButton()
        loginButton.frame = CGRect(x: 32, y: self.view.frame.height / 2 - 60, width: self.view.frame.width - 64, height: 50)
        
        return loginButton
    }()
    
    private func createButtonFB() {
        let loginButton = FBLoginButton()
        loginButton.delegate = self
        loginButton.frame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: self.view.frame.width - 64, height: 50)
        loginButton.center = view.center
        view.addSubview(loginButton)
        loginButton.permissions = ["public_profile", "email"]
    }
   
}


extension LoginController:  LoginButtonDelegate {
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        guard AccessToken.isCurrentAccessTokenActive else {return}
        
        
        singInFirebase()
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    private func openMainController() {
        dismiss(animated: true, completion: nil)
    }
    
    private func singInFirebase() {
        
        guard let accessToken = AccessToken.current?.tokenString else {return}
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credentials) { (result, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "error")
                return
            }
            
            self.fetchToDataUser()
            print("Success logged in firebase")
        }
    }
    
    
    
    // Чекаем путь к данным юзера
    private func fetchToDataUser() {
        GraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"]).start { (_ ,result, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return}
            
            guard let result = result as? [String: Any] else {return}
            self.user = UserDataModel(dict: result)
            
            self.createFetchInDataBase()
        }
    }
    
    
    private func createFetchInDataBase() {
        
        let uid = (Auth.auth().currentUser?.uid)
        let userData = ["name":user?.name, "email":user?.email]
        let values = [uid:userData]
        Database.database().reference().child("users").updateChildValues(values) { error,_ in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            print("Success database pathtree")
            self.openMainController()
        }
    }
}


extension LoginController: GIDSignInDelegate {
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let authorization = user.authentication {
            let credential = GoogleAuthProvider.credential(withIDToken: authorization.idToken, accessToken: authorization.accessToken)
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print("We have problems with google SignIn \(error.localizedDescription)")
                }
                
                print("Success logIn google")
                self.openMainController()
            }
        }
    }
    
    
}

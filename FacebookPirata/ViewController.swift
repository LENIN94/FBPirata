//
//  ViewController.swift
//  FacebookPirata
//
//  Created by Omar Lenin Reyes Alonso on 04/11/16.
//  Copyright © 2016 Omar Lenin Reyes Alonso. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import  FirebaseAuth
class ViewController: UIViewController {

    
    
    @IBOutlet weak var txtUsr: SexyTextField!
    @IBOutlet weak var txtPass: SexyTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        navigationController?.navigationBar.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func bntLoginEmail(_ sender: UIButton) {
    
        if let email = txtUsr.text, let pwd = txtPass.text{
            
            
        }else{
            
              print("📲📲📲📲Log =>>> Favor de introducir su u y pwd")
            
        }
    
    
    }
    

    @IBAction func btnFBLogin(_ sender: UIButton) {
        
        let loginManager = FBSDKLoginManager()
        
        loginManager.logIn(withReadPermissions: ["email"], from: self){ user, error in
            print(user)
            
           /* if let user =  user, user.isCancelled {
                print("📲📲📲📲Log =>>>el usuario ha cancelado el login por fb")
                
            }*/
            
            if error != nil{
                 print("📲📲📲📲Log =>>> No se pudo conectar con fb")
            }else if user?.isCancelled ==  true{
                 print("📲📲📲📲Log =>>>el usuario ha cancelado el login por fb")
            }else{
                 print("📲📲📲📲Log =>>> Login exitoso")
                
                let credentials = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credentials)
            }
            
            
            
        }
        
    }
    
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: {
        user, error in
            
            if error != nil{
                
                 print("📲📲📲📲Log =>>> No se pudo autenticar con firebase error : \(error.debugDescription)")
            }else{
                  print("📲📲📲📲Log =>>> Autenticacion exitosa")
            }
        
        
        })
    }

}


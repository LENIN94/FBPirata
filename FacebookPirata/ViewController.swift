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
import SwiftKeychainWrapper
class ViewController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var txtUsr: SexyTextField!
    @IBOutlet weak var txtPass: SexyTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        navigationController?.navigationBar.isHidden = true
        txtPass.delegate = self
        txtUsr.delegate = self
        if (KeychainWrapper.standard.string(forKey: "FB_UID") != nil) || (KeychainWrapper.standard.string(forKey: "EMAIL_UID") != nil){
            
             print("📲📲📲📲Log =>>> Usuario ya logeado")
        }
        
        
    }
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
       //  textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        self.view.endEditing(true)
   
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func bntLoginEmail(_ sender: UIButton) {
    
        if let email = txtUsr.text, let pwd = txtPass.text{
            
            FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: {
                user, error in
                
                
                if error != nil, let err = error as? NSError{
                     print("📲📲📲📲Log =>>> Ocurrio un error al ingresar con firebase")
                    
                    if err.code == pass_not_long {
                        print("📲📲📲📲Log =>>> ingresa pass mayor de 6 chars")
                    }else if err.code == acount_already_in_use{
                        print("📲📲📲📲Log =>>> La cuenta de correo ya esta en uso")
                        
                        
                        
                        FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: {
                            user, error in
                            
                            
                            
                            if error != nil, let err =  error as? NSError{
                                
                                if err.code == invalid_pass_us {
                                    print("📲📲📲📲Log =>>> cuenta invalida o password no coincide")

                                }else{
                                    
                                }
                                
                                
                                print("📲📲📲📲Log =>>>   \(err.code)")
                            }else{
                                print("📲📲📲📲Log =>>>  Exito usr  \(user!.email)")
                            }
                            
                        })
                    }
                    
                    
                }else{
                     print("📲📲📲📲Log =>>> Exito!!!   USUARIO  \(user!.email)")
                    
                    KeychainWrapper.standard.set(user!.uid, forKey: "EMAIL_UID")
                    
                }
                
            })
            
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
                
                KeychainWrapper.standard.set(user!.uid, forKey: "FB_UID")
            }
        
        
        })
    }

}


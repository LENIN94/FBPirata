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
    var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        activityIndicator =  UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
        view.addSubview(activityIndicator)
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        navigationController?.navigationBar.isHidden = true
        txtPass.delegate = self
        txtUsr.delegate = self
        if (KeychainWrapper.standard.string(forKey: "FB_UID") != nil) || (KeychainWrapper.standard.string(forKey: "EMAIL_UID") != nil){
            
             print("📲📲📲📲Log =>>> Usuario ya logeado")
            
            sendToNextVC()
            
         
            
            
            
        }
        
        
    }
   
    
    func sendToNextVC(){
        if let fblogin = KeychainWrapper.standard.string(forKey: "FB_UID"){
            
            performSegue(withIdentifier: "toMain", sender: fblogin)
        }
        
        if let elogin = KeychainWrapper.standard.string(forKey: "EMAIL_UID"){
            
            performSegue(withIdentifier: "toMain", sender: elogin)
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
        
        activityIndicator.startAnimating()
        activityIndicator.backgroundColor = UIColor(red: 171/255.0, green: 208/255.0, blue: 83/255.0, alpha: 1)

    
        if let email = txtUsr.text, let pwd = txtPass.text{
            
            FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: {
                user, error in
                
                
                if error != nil, let err = error as? NSError{
                      self.activityIndicator.stopAnimating()
                     print("📲📲📲📲Log =>>> Ocurrio un error al ingresar con firebase \(err.debugDescription)")
                   // self.showAlert(title: "Error", message: "Ocurrio un error al ingresar con firebase \(err.debugDescription)")

                    
                    if err.code == pass_not_long {
                        print("📲📲📲📲Log =>>> ingresa pass mayor de 6 chars")
                         self.showAlert(title: "Error", message: "ingresa pass mayor de 6 chars")
                    }else if err.code == acount_already_in_use{
                        print("📲📲📲📲Log =>>> La cuenta de correo ya esta en uso")
                         self.showAlert(title: "Error", message: "La cuenta de correo ya esta en uso")
                        
                        
                        FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: {
                            user, error in
                            
                            
                            
                            if error != nil, let err =  error as? NSError{
                                
                                if err.code == invalid_pass_us {
                                    print("📲📲📲📲Log =>>> cuenta invalida o password no coincide")
                                    
                                    self.showAlert(title: "Error", message: "cuenta invalida o password no coincide")


                                }else{
                                    
                                }
                                
                                  self.activityIndicator.stopAnimating()
                                
                                print("📲📲📲📲Log =>>>   \(err.code)")
                                
                                
                                
                            }else{
                                
                                print("📲📲📲📲Log =>>>  Exito usr  \(user!.email)")
                                self.sendToNextVC()
                            }
                            
                        })
                    }
                    
                    
                }else{
                    
                 //   self.showAlert(title: "OK", message: "Autenticacion exitosa")

                     print("📲📲📲📲Log =>>> Exito!!!   USUARIO  \(user!.email)")
                    
                    KeychainWrapper.standard.set(user!.uid, forKey: "EMAIL_UID")
                    
                    self.sendToNextVC()
                    
                }
                
            })
            
        }else{
            
            self.showAlert(title: "Error", message: "Favor de introducir su u y pwd")

              print("📲📲📲📲Log =>>> Favor de introducir su u y pwd")
             activityIndicator.stopAnimating()
            
        }
        
       
    
    
    }
    

    @IBAction func btnFBLogin(_ sender: UIButton) {
        
        let loginManager = FBSDKLoginManager()
        
        loginManager.logIn(withReadPermissions: ["email"], from: self){ user, error in
            print(user!)
            
           /* if let user =  user, user.isCancelled {
                print("📲📲📲📲Log =>>>el usuario ha cancelado el login por fb")
                
            }*/
            
            if error != nil{
                 print("📲📲📲📲Log =>>> No se pudo conectar con fb")
                
                self.showAlert(title: "Error", message: "No se pudo conectar con fb")
            }else if user?.isCancelled ==  true{
                 print("📲📲📲📲Log =>>>el usuario ha cancelado el login por fb")
                 self.showAlert(title: "Error", message: "el usuario ha cancelado el login por fb")
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
               //   self.showAlert(title: "OK", message: "Autenticacion exitosa")
                  print("📲📲📲📲Log =>>> Autenticacion exitosa")
                
                KeychainWrapper.standard.set(user!.uid, forKey: "FB_UID")
                
                self.sendToNextVC()
            }
        
        
        })
    }
    
    
    func showAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }

}


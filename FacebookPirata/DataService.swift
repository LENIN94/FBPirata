//
//  DataService.swift
//  FacebookPirata
//
//  Created by Omar Lenin on 09/11/16.
//  Copyright © 2016 Omar Lenin Reyes Alonso. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper
let DB_BASE = FIRDatabase.database().reference()
let STORANGE_DB = FIRStorage.storage().reference()


class DataService {
 
    static let ds = DataService()
    
    private var _Ref_base = DB_BASE
    
    private let _ref_posts = DB_BASE.child("posts")
    
    private let _ref_usuarios = DB_BASE.child("users")

    private var _ref_post_images = STORANGE_DB.child("post-images")
    
    
    
    var ref_base: FIRDatabaseReference{
        return _Ref_base
    }
    
    var ref_post: FIRDatabaseReference{
        return _ref_posts
    }
    
    var ref_users: FIRDatabaseReference{
        return _ref_usuarios
    }
    
    var ref_usuario_actual: FIRDatabaseReference{
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        
        let user = ref_users.child(uid!)
        
        
        return user
        
    }
    
  
    var ref_post_images: FIRStorageReference{
        return _ref_post_images
    }
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        ref_users.child(uid).updateChildValues(userData)
        
        
    }
    
}

//
//  PostTableViewCell.swift
//  FacebookPirata
//
//  Created by Omar Lenin on 11/11/16.
//  Copyright © 2016 Omar Lenin Reyes Alonso. All rights reserved.
//

import UIKit
import FirebaseStorage

class PostTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var imgLike: UIImageView!
    
    @IBOutlet weak var imgPost: UIImageView!
    
    @IBOutlet weak var txtPost: UITextView!
    
    @IBOutlet weak var lblLikes: UILabel!
    
   
    
    var post: Post!
    func configureCell(post: Post, img: UIImage?){
        
        self.post = post
        self.txtPost.text = post.descripcion
        self.lblLikes.text = "\(post.likes) Likes"
        
        
        if img != nil{
            self.imgPost.image = img
        }else{
            
            
            let ref = FIRStorage.storage().reference(forURL: post.imgurl)
            
            
            
            
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { data, error in
                
                
                if error != nil {
                    print("Occurio un error al bajar informacion del storange")
                }else{
                    
                    
                    if let imgData = data{
                        if let img = UIImage(data: imgData){
                            self.imgPost.image = img
                            
                            
                        }
                    }
                }
                
            })
        }
        
        let likesRef = DataService.ds.ref_usuario_actual.child("likes")
        likesRef.observeSingleEvent(of: .value, with: {
            
            snapshot in
            
            if (snapshot.value as? NSNull) != nil{
                
                self.imgLike.image = UIImage(named: "heart_material_design_logo_by_xxharutxx-d8vbil5")
                
                
            }else{
                
                self.imgLike.image = UIImage(named: "heartplus")
                
            }
        
        })
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap =  UITapGestureRecognizer(target: self, action: #selector(liketap))
        tap.numberOfTapsRequired = 1
        imgLike.addGestureRecognizer(tap)
        imgLike.isUserInteractionEnabled = true
    }
    
    
    func liketap(){
        
      //  post.ajustarlikes(addlike: <#T##Bool#>)
    }

}

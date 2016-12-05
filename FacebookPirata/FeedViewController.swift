//
//  FeedViewController.swift
//  FacebookPirata
//
//  Created by Omar Lenin on 09/11/16.
//  Copyright © 2016 Omar Lenin Reyes Alonso. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseDatabase
import FirebaseStorage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var imgPhoto: UIImageView!
    var imageSelected = false
    var Posts = [Post]()
    
    @IBOutlet weak var txtPost: UITextField!
    var imagePicker: UIImagePickerController!
    
    
  //  static var imageCache: NSCache<String, UIImage> = NSCache()
    @IBAction func btnPost(_ sender: Any) {
        
        guard let description = txtPost.text , description != "" else{
            print("Descripcion es necesario")
            return
        }
        
        guard let img = imgPhoto.image, imageSelected == true else{
            print("imagen necesaria")
            
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            
            let imgUID = NSUUID().uuidString
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.ref_post_images.child(imgUID).put(imgData, metadata: metadata){
                metadata, error in
                
                if error != nil {
                    
                    print("no se pudo subir a Firebase")
                }else{
                    print("Si se pudo subir la imagen")
                    
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl{
                        
                        self.postToFirebase(imgUrl: url)
                    }
                    
                   // print("\(metadata?.downloadURL()?.absoluteString)")
                }
                
            }
        }
        
        
        
    }
    
    
    func postToFirebase( imgUrl: String){
        
        let post: Dictionary<String, Any> = ["descripcion": txtPost.text!, "imageUrl": imgUrl, "likes": 0]
        
        let firebasePost = DataService.ds.ref_post.childByAutoId()
        firebasePost.setValue(post)
        
        txtPost.text = ""
        imgPhoto.image = UIImage(named: "Motorola-Camera-Icon")
        imageSelected = false
        tableView.reloadData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        
        imagePicker = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        // Make sure ViewController is notified when the user picks an image.
       imagePicker.delegate = self
       // imagePicker = UINavigationController()
        
        let tapimgbutton = UITapGestureRecognizer(target: self, action: #selector(imgPhotoPressed))
        
        
        tapimgbutton.numberOfTapsRequired = 1
        imgPhoto.addGestureRecognizer(tapimgbutton)
        DataService.ds.ref_post.observe(.value, with: {
            snapshot in
          // print(" == \(snapshot.value)")
            if let _snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                
                for snap in _snapshot{
                    print("📱📱📱📱📱📱📱Span=== >  \(snap)")
                    
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        
                        let post = Post(postKey: key, postData: postDict)
                        self.Posts.append(post)
                        
                    }
                    
                }
                self.tableView.reloadData()
            }
        })
        KeychainWrapper.standard.removeObject(forKey: "FB_UID")
        KeychainWrapper.standard.removeObject(forKey: "EMAIL_UID")
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Posts.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell
        
        cell.configureCell(post: Posts[indexPath.row], img: nil)
        
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("")
    }
    
    func imgPhotoPressed(){
        
        print("boton camara ca📷")
        
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image  = info[UIImagePickerControllerEditedImage] as? UIImage{
            imgPhoto.image = image
            imageSelected = true
        }else{
            imageSelected = false
            print("no se selecciono")
        }
        
        
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
        
    }
    
}

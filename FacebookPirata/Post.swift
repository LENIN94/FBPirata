//
//  Post.swift
//  FacebookPirata
//
//  Created by Omar Lenin on 09/11/16.
//  Copyright © 2016 Omar Lenin Reyes Alonso. All rights reserved.
//

import Foundation


class Post {
    
    private var _descripcion: String!
    private var _imgurl: String!
    private var _likes: Int!
    private var _postKey: String!
    
    var descripcion: String{
        return _descripcion
    }
    
    var imgurl: String{
        return _imgurl
        
    }
    
    var likes: Int{
        return _likes
    }
    
    
    
    
    init(descripcion: String, imgurl: String, likes: Int) {
        self._descripcion = descripcion
        self._imgurl = imgurl
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        
        self._postKey = postKey
        if let descripcion = postData["descripcion"] as? String{
            self._descripcion = descripcion
        }
        
        if let imageurl = postData["imageUrl"] as? String{
            self._imgurl = imageurl
        }
        
        
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
        
        
    
    }
    
    
    func ajustarlikes(addlike: Bool){
        
        if addlike{
            _likes = likes + 1
        }else{
            _likes = likes - 1
        }
    }
    
}

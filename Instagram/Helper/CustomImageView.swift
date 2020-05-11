//
//  UIImageViewExtension.swift
//  Instagram
//
//  Created by Ammar Elshamy on 5/11/20.
//  Copyright © 2020 Ammar Elshamy. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    var lastImageUrl: String?
    
    func loadImage(urlString: String) {
        
        lastImageUrl = urlString
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("failed to fetch image ", error)
                return
            }
            
            if(url.absoluteString != self.lastImageUrl) {
                return
            }
           
            guard let imagedata = data else {return}
            let imagePhoto = UIImage(data: imagedata)
           
            DispatchQueue.main.async {
                self.image = imagePhoto
            }
        }.resume()
   }
}

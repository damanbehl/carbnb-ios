//
//  UIImageView+Extensions.swift
//  
//
//  Created by 2022M3 on 20/01/22.
//

import Foundation

extension UIImageView{
    func setImgWebUrl(url : String, isIndicator : Bool){
        if isIndicator == true{
            SDWebImageActivityIndicator.gray.indicatorView.color = UIColor.systemPink
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        }else{
            self.sd_imageIndicator = nil
        }
        
        self.sd_setImage(with: URL(string: url), placeholderImage:UIImage(named: "PlaceHolder"))
    }
}

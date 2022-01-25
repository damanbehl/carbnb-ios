//
//  InsuranceModel.swift
//  CarRental
//
//

import Foundation

class InsuranceModel {
    var brand: String!
    var description: String!
    var title: String!
    var price: String!
    var imageString: String!
    
    init(brand:String, description:String, title:String, imageString:String, price:String){
        self.brand = brand
        self.description = description
        self.title = title
        self.imageString = imageString
        self.price = price
    }
    
    init(){
        
    }
}

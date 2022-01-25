//
//  CarsModel.swift
//  CarRental
//
//

import Foundation

class CarsModel {
    var brand: String!
    var description: String!
    var images_array: [String]!
    var image: String!
    var name: String!
    var price: String!
    var price_tag_line: String!
    var id: String!
    var type: String!
    
    init(brand:String, description:String, images_array:[String], image:String, name:String, price:String, price_tag_line:String, id:String, type:String){
        self.brand = brand
        self.description = description
        self.images_array = images_array
        self.image = image
        self.name = name
        self.price = price
        self.price_tag_line = price_tag_line
        self.id = id
        self.type = type
    }
    
    init(){
        
    }
}





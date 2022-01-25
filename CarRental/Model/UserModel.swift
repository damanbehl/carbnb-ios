//
//  UserModel.swift
//  CarRental
//
//

import Foundation


class UserModel {
    var emailId: String!
    var username: String!
    var name:String!
    
    init(emailId:String,username:String,name:String){
        self.emailId = emailId
        self.username = username
        self.name = name
    }
    
    init(){
        
    }
}

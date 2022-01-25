//
//  OrderModel.swift
//  CarRental
//
//

import Foundation



class OrderModel {
    var totalAmount: Float!
    var insurenceAmount: String!
    var expiryDate: String!
    var bookingID: Int!
    var transactionID:String!
    var carName: String!
    var username: String!
    var carImage: String!
    var carRentPrice: String!
    var cardNumber: String!
    var timeStamp: String!
    var insuranceName: String!
    
    
    init(){
        
    }
    
    init(totalAmount: Float,insurenceAmount: String,expiryDate: String,bookingID: Int,transactionID: String,carName: String,username: String,carImage: String,carRentPrice: String,cardNumber: String,timeStamp: String,insuranceName: String){
        self.totalAmount = totalAmount
        self.insurenceAmount = insurenceAmount
        self.expiryDate = expiryDate
        self.bookingID = bookingID
        self.transactionID = transactionID
        self.carName = carName
        self.username = username
        self.carImage = carImage
        self.carRentPrice = carRentPrice
        self.cardNumber = cardNumber
        self.timeStamp = timeStamp
        self.insuranceName = insuranceName
    }
    
}

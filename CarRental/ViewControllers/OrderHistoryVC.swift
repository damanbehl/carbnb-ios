//
//  OrderHistoryVC.swift
//  CarRental
//
//  Created by 2022M3 on 14/01/22.
//

import UIKit
import FirebaseStorage


class OrderHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListViewCell", for: indexPath) as! OrderListViewCell
        cell.configCell(data: arrOrder[indexPath.row])
        return cell
    }
    

    @IBOutlet weak var tblOrderList: UITableView!
    
    
    var arrOrder: [OrderModel] = [OrderModel]()
   // var arrRecentOrder : [Dictionary<String,Any>] = [Dictionary<String,Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblOrderList.delegate = self
        self.tblOrderList.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getOrderList(userName: GFunction.user.username)
    }

}


class OrderListViewCell: UITableViewCell {
    @IBOutlet weak var lblCarName: UILabel!
    @IBOutlet weak var imgCars: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    
    func configCell(data: OrderModel){
        self.lblDate.text = "Rented at> \(data.timeStamp.description.dropLast(5))"
        self.lblCarName.text = data.carName.description
        
        let storage = Storage.storage().reference().child("cars/\(data.carImage.description)")
        storage.downloadURL { url, error in
          if let error = error {
            // Handle any errors
          } else {
            // Get the download URL for 'images/stars.jpg'
              self.imgCars.setImgWebUrl(url: (url?.absoluteString.description)!, isIndicator: true)
          }
        }
    }
}



extension OrderHistoryVC {
    
    func getOrderList(userName:String) {
        _ = AppDelegate.shared.db.collection(cOrders).whereField(cUserName, isEqualTo: userName).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.arrOrder.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents{
                    let data = data.data()
                    print(data)
                    //self.arrOrder.append(InsuranceModel(brand: data["brand"] as! String, description: data["description"] as! String, title: data["title"] as! String, imageString: data["imageString"] as! String, price: data["price"] as! String))
                    //["totalAmount": 375, "insurenceAmount": 200, "expiryDate": 12 / 22, "bookingID": 1651888, "transactionID": TID696, "carName": MAZDA CX5 2021, "username": test99, "carImage": mazda_cx5_front.jpg, "carRentPrice": 175, "cardNumber": 1234 1234 1324 1324, "timeStamp": <FIRTimestamp: seconds=1642701900 nanoseconds=242000000>, "insuranceName": BELAIR]


                    self.arrOrder.append(OrderModel(totalAmount: data["totalAmount"] as! Float, insurenceAmount: data["insurenceAmount"] as! String, expiryDate: data["expiryDate"] as! String, bookingID: data["bookingID"] as! Int, transactionID: data["transactionID"] as! String, carName: data["carName"] as! String, username: data["username"] as! String, carImage: data["carImage"] as! String, carRentPrice: data["carRentPrice"] as! String, cardNumber: data["cardNumber"] as! String, timeStamp: ((data["timeStamp"] as? Timestamp)?.dateValue().description) as! String, insuranceName: data["insuranceName"] as! String))
                }
                self.tblOrderList.delegate = self
                self.tblOrderList.dataSource = self
                self.tblOrderList.reloadData()
    
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
        
    }
}

//
//  PaymentDoneVC.swift
//  CarRental
//
//   on 24/12/21.
//

import UIKit

class PaymentDoneVC: UIViewController {

    
    //MARK:- Outlets
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblBookingID: UILabel!
    @IBOutlet weak var lblTransactionID: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    var bookingID: String!
    var transactionID: String!
    var date: String!
    
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwMain.layer.cornerRadius = 45
        self.lblBookingID.text = "Booking Id: \(bookingID.description)"
        self.lblTransactionID.text = "Transaction Id: \(transactionID.description)"
        self.lblDate.text = "executed on: \(date.description)"
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

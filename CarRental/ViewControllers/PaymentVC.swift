//
//  PaymentVC.swift
//  CarRental
//
//   on 23/12/21.
//

import UIKit


class PaymentVC: UIViewController, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //TxtMobileNumber allowed only Digits, - and maximum 12 Digits allowed
        if textField == txtCardNumber {
            if ((string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil) && textField.text!.count < 19) || string.isEmpty {
                if (textField.text!.count == 4 || textField.text!.count == 9 || textField.text!.count == 14)  && !string.isEmpty {
                    textField.text?.append(" ")
                }
                //self.lblCardNumber.text = textField.text
                return true
            }
        }
        
        if textField == txtCardHolderName {
            if ((string.rangeOfCharacter(from: CharacterSet.letters) != nil || string.rangeOfCharacter(from: CharacterSet.whitespaces) != nil) || string.isEmpty) {
                return true
            }
        }
        
        //TxtDate allowed only Digits, / and maximum 6 Digits allowed
        if textField == txtExp {
            if ((string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil) && textField.text!.count < 7) || string.isEmpty{
                if (textField.text?.count == 2) && !string.isEmpty {
                    textField.text?.append(" / ")
                }
                return true
            }
            //self.setPicker()
        }
        
        //TxtCVV allowed only 3 Digits
        if textField == txtCVV {
            if ((string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil) && textField.text!.count < 3) || string.isEmpty{
                return true
            }
        }
        return false
    }
    
    //MARK:- Outlets
    @IBOutlet weak var btnValidate: UIButton!
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwFront: UIView!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtExp: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var txtCardHolderName: UITextField!
    
    //MARK:- Class Variables
    var carsData: CarsModel!
    var insurenceData: InsuranceModel!
    
    
    //MARK:- Custom Methods
    private func setUpView(){
        self.vwMain.layer.cornerRadius = 40
        self.vwMain.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.vwFront.layer.cornerRadius = 10
        self.btnValidate.layer.cornerRadius = 5
        self.txtExp.delegate = self
        self.txtCVV.delegate = self
        self.txtCardHolderName.delegate = self
        self.txtCardNumber.delegate = self
        
        self.txtCardNumber.text = "1234 1234 1234 1234"
        self.txtCVV.text = "123"
        self.txtCardHolderName.text = "gjdjajdhgahjdgjgas"
        self.txtExp.text = "12 / 23"
        
        //        if !MFMailComposeViewController.canSendMail() {
        //            Alert.shared.showAlert(message: "Mail services are not available", completion: nil)
        //            return
        //        }
    }
    
    //MARK:- Action Methods
    func Validation() -> String {
        if self.txtCardNumber.text!.trim().isEmpty {
            return "Please enter card number"
        }else if self.txtCardNumber.text!.count != 19 {
            return "Please enter valid card number"
        }else if self.txtExp.text!.trim().isEmpty {
            return "Please enter expiry date"
        }else if self.txtExp.text!.count != 7 {
            return "Please valid expiry date"
        }else if self.txtCVV.text!.trim().isEmpty {
            return "Please enter CVV"
        }else if self.txtCVV.text!.trim().count != 3 {
            return "Please valid CVV"
        }else if self.txtCardHolderName.text!.trim().isEmpty {
            return "Please enter card holder name"
        }
        
        return ""
    }
    
    @IBAction func btnValidateClick(_ sender: Any) {
        let msg = Validation()
        if msg.isEmpty {
            self.addOrder()
        }else{
            Alert.shared.showAlert(message: msg, completion: nil)
        }
    }
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
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
}


extension PaymentVC {
    
    func addOrder() {
        
        
        let randomTransaction = arc4random_uniform(9999999 + 1)
        let random = "TID\(arc4random_uniform(999 + 1))"
        var ref : DocumentReference? = nil
        var total = Float(insurenceData.price)! + Float(carsData.price)!
        ref = AppDelegate.shared.db.collection(cOrders).addDocument(data:
                                                                        [ cUserName: GFunction.user.username!,
                                                                           cCarName: carsData.name!,
                                                                         cCarPrice : carsData.price!,
                                                                          cCarImage: carsData.image!,
                                                                     cInsurenceName: insurenceData.brand!,
                                                                   cInsurenceAmount: insurenceData.price!,
                                                                        cCardNumber: self.txtCardNumber.text!,
                                                                        cExpiryDate: self.txtExp.text!,
                                                                       cTotalAmount: total,
                                                                         cBookingId: randomTransaction,
                                                                     cTransactionId: random,
                                                                       cServerTime : FieldValue.serverTimestamp()
                                                                        ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.sendEmail(random: random, random1: Int(randomTransaction))
            }
        }
    }
    
    
    func sendEmail(random:String,random1:Int) {
        
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = "ios.test394@gmail.com"
        smtpSession.password = "Test@1234"
        smtpSession.port = 465
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        smtpSession.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "Charles", mailbox: "ios.test394@gmail.com")]
        builder.header.from = MCOAddress(displayName: "Car Rental", mailbox: "ios.test394@gmail.com")
        builder.header.subject = "Test Email"
        builder.htmlBody="<p> Your Order has been placed successFully. </p>"
        
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(error)")
                
                
            } else {
                NSLog("Successfully sent email!")
                let navigationData = PaymentDoneVC.instantiate(fromAppStoryboard: .main)
                navigationData.transactionID = random
                navigationData.bookingID = random1.description
                navigationData.date =  Date().description
                self.navigationController?.pushViewController(navigationData, animated: true)
            }
        }
    }
}

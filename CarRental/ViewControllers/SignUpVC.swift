//
//  SignUpVC.swift
//  CarRental
//
//   on 24/12/21.
//

import UIKit

class SignUpVC: UIViewController {

    
    //MARK:- Outlets
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
   
    //MARK:- Class Variables
    var flag: Bool = false
    
    //MARK:- Custom Methods
    func setUpView(){
        self.btnSubmit.layer.cornerRadius = 5
    }
    
    func validationView() -> String{
        if self.txtName.text!.trim().isEmpty {
           return "Please enter name"
        }else if self.txtUserName.text!.trim().isEmpty {
            return "Please enter user name"
        }else if self.txtEmail.text!.trim().isEmpty {
            return "Please enter email"
        }else if self.txtPassword.text!.trim().isEmpty {
            return "Please enter password"
        }else if self.txtConfirmPassword.text!.trim().isEmpty {
            return "Please enter confirm password"
        }else if self.txtPassword.text != self.txtConfirmPassword.text {
            return "Both Password mismatch"
        }
        return ""
    }
    //MARK:- Action Methods
    
    @IBAction func bntSubmitClick(_ sender: Any) {
        self.flag = false
        let msg = validationView()
        if msg.isEmpty {
            self.getExistingUser(userName: self.txtUserName.text!, email: self.txtEmail.text!, password: self.txtPassword.text!, userFullName: self.txtName.text!)
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


//MARK:- Extension for Login Function
extension SignUpVC {
    
    func createAccount(username:String,fullName:String,password:String,email:String) {
        var ref : DocumentReference? = nil
        
        ref = AppDelegate.shared.db.collection(cUser).addDocument(data:
            [ cUserName: username,
              cFullName: fullName,
              cPassword : password,
              cEmail: email,
              cServerTime : FieldValue.serverTimestamp()
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                GFunction.user = UserModel(emailId: email, username: username, name: fullName)
                UserDefaults.standard.set(true, forKey: UserDefaults.Keys.currentUser)
                UserDefaults.standard.set(GFunction.user, forKey: UserDefaults.Keys.user)
                UserDefaults.standard.synchronize()
                UIApplication.shared.setHome()
            }
        }
    }
    
    func getExistingUser(userName:String,email:String,password:String,userFullName:String) {
    
        _ = AppDelegate.shared.db.collection(cUser).whereField(cUserName, isEqualTo: userName).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count == 0 {
                self.createAccount(username: userName, fullName: userFullName, password: password, email: email)
                self.flag = true
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "UserName already exist !!!", completion: nil)
                    self.flag = true
                }
            }
        }
        
    }
}

//
//  LoginVC.swift
//  CarRental
//
//   on 22/12/21.
//

import UIKit

class LoginVC: UIViewController {

    
    //MARK:- Outlets
    @IBOutlet weak var vwMain: UIView!
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
  
    //MARK:- Class Variables
    var flag: Bool = true
    
    
    //MARK:- Custom Methods
    private func setUpView(){
        self.vwMain.layer.cornerRadius = 32
        self.btnSignIn.layer.cornerRadius = 14
        self.txtPassword.layer.cornerRadius = 14
        self.txtUserName.layer.cornerRadius = 14
        
        self.txtUserName.text = "test99"
        self.txtPassword.text = "Test@1234"
    }
    
    func validationView(userName: String,password: String) -> String? {
        var error = ""
        if userName.isEmpty {
            error =  "Please Enter User Name"
        }else if password.isEmpty {
            error =  "Please Enter Password"
        }
        return error
    }
    //MARK:- Action Methods
    
    @IBAction func btnForgotPasswordClick(_ sender: Any) {
        
    }
    
    @IBAction func btnAppleClick(_ sender: Any) {
        
    }
    
    @IBAction func btnLoginClick(_ sender: Any) {
        self.flag = true
        let msg = validationView(userName: self.txtUserName.text!.trim(), password: self.txtPassword.text!.trim())
        if !msg!.isEmpty {
            Alert.shared.showAlert(message: msg!, completion: nil)
        }else{
            self.loginUser(userName: self.txtUserName.text!, password: self.txtPassword.text!)
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


extension LoginVC {
   
    func loginUser(userName:String,password:String) {
    
        _ = AppDelegate.shared.db.collection(cUser).whereField(cUserName, isEqualTo: userName).whereField(cPassword, isEqualTo: password).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                if let fullName : String = snapshot.documents[0].data()["fullName"] as? String, let username:String = snapshot.documents[0].data()["username"] as? String, let email:String = snapshot.documents[0].data()["email"] as? String{
                    GFunction.shared.firebaseLogin(data: email)
                    GFunction.user = UserModel(emailId: email, username: username, name: fullName)
                    UserDefaults.standard.set(true, forKey: UserDefaults.Keys.currentUser)
                    UserDefaults.standard.set(email, forKey: UserDefaults.Keys.user)
                    UserDefaults.standard.synchronize()
                    self.flag = false
                    UIApplication.shared.setHome()
                }
            }else{
                if self.flag {
                    Alert.shared.showAlert(message: "Please check your credentials !!!", completion: nil)
                    self.flag = false
                }
            }
        }
        
    }
    
    func createAccount(username:String,fullName:String,password:String,email:String) {
        var ref : DocumentReference? = nil
        
        ref = AppDelegate.shared.db.collection(cUser).addDocument(data:
            [ cUserName: username,
              cFullName: fullName,
              cPassword : password,
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
    
}






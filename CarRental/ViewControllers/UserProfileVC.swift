//
//  UserProfileVC.swift
//  CarRental
//
//

import UIKit

class UserProfileVC: UIViewController {

    @IBOutlet weak var btnSignOut: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserFullName: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // let username = UserDefaults.standard.string(forKey: UserDefaults.Keys.userName)
        self.loginUser(userName: GFunction.user.username)
        self.btnUser.setTitle("", for: .normal)
        self.btnEmail.setTitle("", for: .normal)
        self.btnPhone.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnSignOut(_ sender: Any) {
        UIApplication.shared.logoutAppUser()
    }
    
    func loginUser(userName:String) {
    
        _ = AppDelegate.shared.db.collection(cUser).whereField(cUserName, isEqualTo: userName).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                if let fullName : String = snapshot.documents[0].data()["fullName"] as? String, let username:String = snapshot.documents[0].data()["username"] as? String, let email:String = snapshot.documents[0].data()["email"] as? String{
                    GFunction.shared.firebaseLogin(data: email)
                    GFunction.user = UserModel(emailId: email, username: username, name: fullName)
                    self.lblUserName.text = GFunction.user.username
                    self.lblUserFullName.text = GFunction.user.name
                    self.lblUserEmail.text = GFunction.user.emailId
                }
            }
        }
        
    }
}



//
//  StartVC.swift
//  CarRental
//
//   on 23/12/21.
//

import UIKit

class StartVC: UIViewController {

    
    //MARK:- Outlets
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignInWithFB: UIButton!
    
    //MARK:- Class Variables
    var appleData: AppleLoginModel!
    private let appleLoginManager: AppleLoginManager = AppleLoginManager()
    
    //MARK:- Custom Methods
    private func setUpView(){
        self.btnLogin.layer.cornerRadius = 12.0
        self.btnSignIn.layer.cornerRadius = 12.0
        self.btnSignInWithFB.layer.cornerRadius = 12.0
        self.btnSignIn.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.003921568627, blue: 0.1568627451, alpha: 1)
        //self.btnSignInWithFB.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.3490196078, blue: 0.5960784314, alpha: 1)
    }
    //MARK:- Action Methods
    
    @IBAction func btnLogin(_ sender: Any) {
        let navigationData = storyboard!.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(navigationData, animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let navigationData = SignUpVC.instantiate(fromAppStoryboard: .main)
        self.navigationController?.pushViewController(navigationData, animated: true)
    }
    
    @IBAction func btnFB(_ sender: Any) {
        self.appleLoginManager.performAppleLogin()
        
//        let navigationData = storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        //        {
//        self.navigationController?.pushViewController(navigationData, animated: true)
//        //        }
    }
    
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setUpView()
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


//MARK:- Apple Login
extension StartVC: AppleLoginDelegate {
    
    
    
    func appleLoginData(data: AppleLoginModel) {
        
        print("Social Id==>", data.socialId ?? "")
        print("First Name==>", data.firstName ?? "")
        print("Last Name==>", data.lastName ?? "")
        print("Email==>", data.email ?? "")
        print("Login type==>", data.loginType ?? "")
        
        //self.getExistingUser(userName: <#T##String#>, email: <#T##String#>, password: <#T##String#>)
        
        
        //Pass Data among this
    }
    
}

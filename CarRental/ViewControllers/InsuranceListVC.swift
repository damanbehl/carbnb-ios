//
//  InsuranceListVC.swift
//  CarRental
//
//   on 23/12/21.
//

import UIKit

class InsuranceListVC : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.insuranceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InsuranceCell", for: indexPath) as! InsuranceCell
        cell.configCell(data: self.insuranceList[indexPath.row])
        cell.btnSelect.addAction(for: .touchUpInside) {
            let navigationData = PaymentVC.instantiate(fromAppStoryboard: .main)
            navigationData.insurenceData = self.insuranceList[indexPath.row]
            navigationData.carsData = self.carData
            self.navigationController?.pushViewController(navigationData, animated: true)
        }
        return cell
    }
    

    
    //MARK:- Outlets
    @IBOutlet weak var tblInsuranceList: UITableView!
    
    //MARK:- Class Variables
    var insuranceList: [InsuranceModel] = [InsuranceModel]()
    
    
    //MARK:- Custom Methods
    var carData: CarsModel!
    
    
    //MARK:- Action Methods
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblInsuranceList.delegate = self
        self.tblInsuranceList.dataSource = self        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getInsurenceList()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }

}


class InsuranceCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var btnReadMore: UIButton!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwMain.layer.cornerRadius = 43.0
        self.btnSelect.layer.cornerRadius = 5
        self.btnReadMore.layer.cornerRadius = 5
        self.btnSelect.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.1921568627, blue: 0.3490196078, alpha: 1)
        self.btnReadMore.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.1921568627, blue: 0.3490196078, alpha: 1)
    }
    
    
    func configCell(data:InsuranceModel) {
        self.lblTitle.text = data.brand.description
        self.lblDescription.text = data.description.description
        let storage = Storage.storage().reference().child("cars/\(data.imageString.description)")
        storage.downloadURL { url, error in
          if let error = error {
            // Handle any errors
          } else {
            // Get the download URL for 'images/stars.jpg'
              self.imageLogo.setImgWebUrl(url: (url?.absoluteString.description)!, isIndicator: true)
          }
        }
    }
   
}


extension InsuranceListVC {
    
    func getInsurenceList() {
        _ = AppDelegate.shared.db.collection(cInsurence).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                self.insuranceList.removeAll()
                for data in snapshot.documents{
                    let data = data.data()
                    self.insuranceList.append(InsuranceModel(brand: data["brand"] as! String, description: data["description"] as! String, title: data["title"] as! String, imageString: data["imageString"] as! String, price: data["price"] as! String))
                }
                self.tblInsuranceList.delegate = self
                self.tblInsuranceList.dataSource = self
                self.tblInsuranceList.reloadData()
    
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
        
    }
}

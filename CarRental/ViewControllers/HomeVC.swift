//
//  HomeVC.swift
//  CarRental
//
//   on 23/12/21.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.carListDemo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarListCell") as! CarListCell
        cell.configCell(data: self.carListDemo[indexPath.row])
       
        let tap = UITapGestureRecognizer()
        tap.addAction() {
            let navigationData = CarDetailsVC.instantiate(fromAppStoryboard: .main)
            navigationData.carData = self.carListDemo[indexPath.row]
            self.navigationController?.pushViewController(navigationData, animated: true)
        }
        
        cell.btnPay.addAction(for: .touchUpInside) {
            let navigationData = InsuranceListVC.instantiate(fromAppStoryboard: .main)
            navigationData.carData = self.carListDemo[indexPath.row]
            self.navigationController?.pushViewController(navigationData, animated: true)
        }
        
        cell.vwMain.addGestureRecognizer(tap)
        return cell
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtSearch {
            self.openPicker()
            return false
        }
        
        return true
    }
    //MARK:- Outlets
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var vwBMW: UIView!
    @IBOutlet weak var vwMazda: UIView!
    @IBOutlet weak var vwMercedz: UIView!
    @IBOutlet weak var tblCarList: UITableView!
    //MARK:- Class Variables
    var carList: [CarsModel] = [CarsModel]()
    var carListDemo: [CarsModel] = [CarsModel]()
    var str = ""
    //MARK:- Custom Methods
    
    //MARK:- Action Methods
    
    //MARK:- View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblCarList.delegate = self
        self.tblCarList.dataSource = self
        self.txtSearch.delegate = self
        self.vwBMW.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.vwMazda.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.vwMercedz.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
       // self.view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.addShadow(view: self.vwBMW,offset: CGSize(width: 0, height: 1),radius: 1, color: .black)
        self.vwBMW.layer.cornerRadius = 8
        self.getTap(sender: self.vwBMW, str: "BMW")
        
        self.addShadow(view: self.vwMazda,offset: CGSize(width: 0, height: 1),radius: 1, color: .black)
        self.vwMazda.layer.cornerRadius = 8
        self.getTap(sender: self.vwMazda, str: "MAZADA")
        
        self.addShadow(view: self.vwMercedz,offset: CGSize(width: 0, height: 1),radius: 1, color: .black)
        self.vwMercedz.layer.cornerRadius = 8
        self.getTap(sender: self.vwMercedz, str: "KIA")
        // Do any additional setup after loading the view.
    }
    
    func getTap(sender: UIView,str:String) {
        let tap = UITapGestureRecognizer()
        tap.addAction {
            self.carListDemo = self.getCarsData(type: str)
            self.changeView(sender: sender, flag: true)
            self.tblCarList.reloadData()
        }
        sender.addGestureRecognizer(tap)
    }
    
    func changeView(sender: UIView,flag:Bool) {
       
        vwBMW.layer.borderWidth = 0.0
        vwMazda.layer.borderWidth = 0.0
        vwMercedz.layer.borderWidth = 0.0
        
        if flag {
            sender.layer.borderColor = UIColor.black.cgColor
            sender.layer.borderWidth = 1.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getCarList()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }

    
    func addShadow(view: UIView,offset: CGSize = .zero, opacity: Float = 0.65, radius: CGFloat = 2, color: UIColor = .black) {
        view.layer.shadowOffset = offset
        view.layer.shadowOpacity = opacity
        view.layer.shadowRadius = radius
        view.layer.shadowColor = color.cgColor
        view.layer.masksToBounds = false
    }
    
    
    func openPicker(){
        
        let actionSheet = UIAlertController(title: nil, message: "Select Car Type", preferredStyle: .actionSheet)
        
        let daily = UIAlertAction(title: "SUV", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.txtSearch.text = "SUV"
            self.carListDemo = self.getSortData(type: "SUV")
            self.changeView(sender: self.vwBMW, flag: false)
            self.tblCarList.reloadData()
        })
        
        let weekly = UIAlertAction(title: "Pick up trucks", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.txtSearch.text = "Pick up trucks"
            self.carListDemo = self.getSortData(type: "PICKUP")
            self.changeView(sender: self.vwBMW, flag: false)
            self.tblCarList.reloadData()
        })
        
        let monthly = UIAlertAction(title: "Sedan", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.txtSearch.text = "Sedans"
            self.carListDemo = self.getSortData(type: "SEDAN")
            self.changeView(sender: self.vwBMW, flag: false)
            self.tblCarList.reloadData()
        })
        
        let yearly = UIAlertAction(title: "Limousins", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.txtSearch.text = "Limousins"
            self.carListDemo = self.getSortData(type: "LIMOUSINS")
            self.changeView(sender: self.vwBMW, flag: false)
            self.tblCarList.reloadData()
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
            self.txtSearch.text = ""
            self.carListDemo = self.getSortData(type: "")
            self.changeView(sender: self.vwBMW, flag: false)
            self.tblCarList.reloadData()
        })
        
        actionSheet.addAction(daily)
        actionSheet.addAction(weekly)
        actionSheet.addAction(monthly)
        actionSheet.addAction(yearly)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
        

    }
    
    
}


class CarListCell: UITableViewCell {
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var lblCarName: UILabel!
    @IBOutlet weak var lblArea: UILabel!
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnPay.layer.cornerRadius = 8
        self.vwMain.layer.cornerRadius = 21
        self.vwMain.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.addShadow(offset: CGSize(width: 2, height: 2), opacity: 0.35, radius: 2, color: .black)
        
    }
    
    func addShadow(offset: CGSize = .zero, opacity: Float = 0.65, radius: CGFloat = 2, color: UIColor = .black) {
        self.vwMain.layer.shadowOffset = offset
        self.vwMain.layer.shadowOpacity = opacity
        self.vwMain.layer.shadowRadius = radius
        self.vwMain.layer.shadowColor = color.cgColor
        self.vwMain.layer.masksToBounds = false
    }
    
    func configCell(data:CarsModel){
        let storage = Storage.storage().reference().child("cars/\(data.image.description)")
        storage.downloadURL { url, error in
          if let error = error {
            // Handle any errors
          } else {
            // Get the download URL for 'images/stars.jpg'
              self.imgProfile.setImgWebUrl(url: (url?.absoluteString.description)!, isIndicator: true)
          }
        }
        self.lblCarName.text = data.name.description
        self.btnPay.setTitle("\(data.price.description)$", for: .normal)
    }
}


extension HomeVC {
    func getSortData(type:String) -> [CarsModel]{
        if type.isEmpty {
            return self.carList
        }else{
            return self.carList.filter({ $0.type == type })
        }
    }
    
    func getCarsData(type:String) -> [CarsModel]{
        if type.isEmpty {
            return self.carList
        }else{
            return self.carList.filter({ $0.brand == type })
        }
    }
    
    func getCarList() {
        _ = AppDelegate.shared.db.collection(cCars).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count != 0 {
                self.carList.removeAll()
                for data in snapshot.documents{
                    self.carList.append(CarsModel(brand: data.data()["brand"] as! String, description: data.data()["description"] as! String, images_array: data.data()["images_array"] as! [String], image: data.data()["main_image"] as! String, name: data.data()["name"] as! String, price: data.data()["price_numerical"] as! String, price_tag_line: data.data()["price_tag_line"] as! String, id: data.data()["self_id"] as! String, type: data.data()["type"] as! String))
                }
                self.carListDemo = self.carList
                self.tblCarList.reloadData()
    
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
        
    }
}

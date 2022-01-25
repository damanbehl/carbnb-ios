//
//  CarDetailsVC.swift
//  CarRental
//
//   on 23/12/21.
//

import UIKit
import Cosmos

class CarDetailsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        carData.images_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarImageCell", for: indexPath) as! CarImageCell
        cell.configCell(data: carData.images_array[indexPath.row])
        return cell
    }
    

    
    //MARK:- Outlets
    
    @IBOutlet weak var lblCarName: UILabel!
    @IBOutlet weak var colImages: UICollectionView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnBlue: UIButton!
    @IBOutlet weak var btnGreen: UIButton!
    @IBOutlet weak var btnYellow: UIButton!
    @IBOutlet weak var btnRed: UIButton!
    @IBOutlet weak var btnRentType: UIButton!
    @IBOutlet weak var btnWishList: UIButton!
    @IBOutlet weak var btnRentThisCar: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var vwStar: CosmosView!
    
    //MARK:- Class Variables
    var carData : CarsModel!
    
    //MARK:- Custom Methods
    private func setUpView(){
        self.btnRed.layer.cornerRadius = (self.btnRed.layer.frame.height/2)
        self.btnBlue.layer.cornerRadius = (self.btnRed.layer.frame.height/2)
        self.btnGreen.layer.cornerRadius = (self.btnRed.layer.frame.height/2)
        self.btnYellow.layer.cornerRadius = (self.btnRed.layer.frame.height/2)
        self.btnRentThisCar.layer.cornerRadius = 5
        self.btnRentType.layer.cornerRadius = 5
        self.vwStar.settings.fillMode = .precise
        self.vwStar.rating = 3.90
    }
    
    func setUpButtonView(){
        self.btnBlue.isSelected = false
        self.btnGreen.isSelected = false
        self.btnRed.isSelected = false
        self.btnYellow.isSelected = false
    }
    
    
    func setUpData(){
        self.lblPrice.text = "$\(carData.price.description)"
        self.lblDescription.text = carData.description
        self.colImages.delegate = self
        self.colImages.dataSource = self
        self.colImages.reloadData()
        self.lblCarName.text = carData.name.description
    }
    
    
    func openPicker(){
        
        let actionSheet = UIAlertController(title: nil, message: "Select Lease Type", preferredStyle: .actionSheet)
        
        let daily = UIAlertAction(title: "Daily Rent", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.btnRentType.setTitle("Daily Rent", for: .normal)
        })
        
        let weekly = UIAlertAction(title: "Weekly Rent", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.btnRentType.setTitle("Weekly Rent", for: .normal)
        })
        
        let monthly = UIAlertAction(title: "Monthly Rent", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.btnRentType.setTitle("Monthly Rent", for: .normal)
        })
        
        let yearly = UIAlertAction(title: "Yearly Rent", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.btnRentType.setTitle("Yearly Rent", for: .normal)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
            
        })
        
        actionSheet.addAction(daily)
        actionSheet.addAction(weekly)
        actionSheet.addAction(monthly)
        actionSheet.addAction(yearly)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    //MARK:- Action Methods
    
    @IBAction func btnColorsClick(_ sender: UIButton) {
        self.setUpButtonView()
        sender.isSelected = true
    }
    
    @IBAction func btnLeaseClick(_ sender: UIButton) {
        self.openPicker()
    }
    
    @IBAction func btnRentCarClick(_ sender: UIButton) {
        let navigationData = InsuranceListVC.instantiate(fromAppStoryboard: .main)
        navigationData.carData = self.carData
        self.navigationController?.pushViewController(navigationData, animated: true)
    }
    
    @IBAction func btnWishListClick(_ sender: UIButton) {
        Alert.shared.showAlert(message: "Your car has been added into wishlist", completion: nil)
    }
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpButtonView()
        self.btnBlue.isSelected = true
        self.setUpData()
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



class CarImageCell: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        imgWidth.constant = UIScreen.main.bounds.width
        imgHeight.constant = UIScreen.main.bounds.height * (400/812)
    }
    
    func configCell(data:String){
        let storage = Storage.storage().reference().child("cars/\(data.description)")
        storage.downloadURL { url, error in
          if let error = error {
            // Handle any errors
          } else {
            // Get the download URL for 'images/stars.jpg'
              self.image.setImgWebUrl(url: (url?.absoluteString.description)!, isIndicator: true)
          }
        }
    }
}

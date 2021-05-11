//
//  ViewController.swift
//  AlamofireCollection
//
//  Created by Neha Penkalkar on 25/04/21.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var brandCV: UICollectionView!
    var brandArr = [NSDictionary]()
    
    var idSort = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        alamofirePostExample()
    }
    
    func alamofirePostExample(){
        
        if Connectivity.isConnectedToInternet(){
            
            
            let param = ["request":"brand_listing","device_type":"ios","country":"india"]
            
            AF.request("https://www.kalyanmobile.com/apiv1_staging/brand_listing.php",method: .post,parameters: param).responseJSON { (resp) in
                if let dict = resp.value as? NSDictionary{
                    //print("RESPONSE HERE \(dict)")
                    if let respCode = dict.value(forKey: "responseCode") as? String,let respMsg = dict.value(forKey: "responseMessage") as? String{
                        if respCode == "success" {
                            print("SUCCESS")
                            if let brand = dict.value(forKey: "brand") as? [NSDictionary] {
                                self.brandArr = brand
                                self.brandCV.reloadData()
                            }else{
                                print("ERR \(respMsg)")
                            }
                        }
                    }
                }
            }
            
        }else{
            print("Network Error, Please turn on the internet.")
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCVC", for: indexPath) as! CustomCVC
        cell.layer.cornerRadius = 20
        
        let a = brandArr[indexPath.row]
        let name = a.value(forKey: "brand_name") as? String ?? ""
        let id = a.value(forKey: "brand_id") as? String ?? ""
        cell.nameLbl.text  = "\(id). \(name)"
        
        let img = a.value(forKey: "brand_image_path") as? String ?? ""
        let url = URL(string: "\(img)")
        cell.imgV.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: floor((collectionView.frame.size.width-2)/2), height: floor(collectionView.frame.size.height-4)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}


class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

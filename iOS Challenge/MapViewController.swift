//
//  MapViewController.swift
//  iOS Challenge
//
//  Created by Signe Ruprecht on 6/12/21.
//  Copyright © 2021 Signe Ruprecht. All rights reserved.
//

import UIKit
import YelpAPI

class MapViewController: UIViewController {
    
    var businessId: String?
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var numOfReviews: UILabel!
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(businessId)
        getBusinessDetails()

        // Do any additional setup after loading the view.
    }
    
    
    func getBusinessDetails() {
        guard let id = businessId else {
            // need to show some error message fail here
            return
        }
        
    
        
        let apikey = "fIbyljOuO_kXY7RN5afW6Xk8I8rhu_DgpbmJSgmzH_xJ-feuDEauPpsQlR6xB5SoueCm2FRkZHvC5Dam6va0x2PGHJWXAKu740r9v3UIobkWSZrpvqbKx0NbXffDYHYx"
        let client = YLPClient(apiKey: apikey)
        
        client.business(withId: id, completionHandler: { (business, error)  in
              
            if let err = error {
                print(err.localizedDescription)
            }
            
            if let result = business {
                
                DispatchQueue.main.async {
                    let address = result.location.address[0] + "\n" + result.location.city + ", " + result.location.stateCode + " " + result.location.postalCode
                    
                    var display = 2
                    var categories = ""
                    if(result.categories.count < 3) {
                        display = result.categories.count - 1
                    }
                    
                    for i in 0...display {
                        categories = categories + result.categories[i].name
                        if(i != display) {
                            categories = categories + " • "
                        }
                    }
                    
                    self.businessName.text = result.name
                    self.numOfReviews.text = "(" + String(result.reviewCount) + ")"
                    self.phoneNumber.text = result.phone
                    self.address.text = address
                    self.categories.text = categories
                    
                }
                print(result.location.address)
                print(result.categories)
                print(result.phone)
                print(result.reviewCount)
                
                
       
                
            }
        })
        
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

//
//  YelpQueries.swift
//  iOS Challenge
//
//  Created by Signe Ruprecht on 6/11/21.
//  Copyright © 2021 Signe Ruprecht. All rights reserved.
//

import YelpAPI
import BrightFutures
import CoreLocation

//let appId = "iaTWy8yp8yOwG7EwY69FUQ"
//let appKey = "fIbyljOuO_kXY7RN5afW6Xk8I8rhu_DgpbmJSgmzH_xJ-feuDEauPpsQlR6xB5SoueCm2FRkZHvC5Dam6va0x2PGHJWXAKu740r9v3UIobkWSZrpvqbKx0NbXffDYHYx"

class YelpQueries {
    
    static func searchBusinesses(searchTerm: String, longitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        let apikey = "fIbyljOuO_kXY7RN5afW6Xk8I8rhu_DgpbmJSgmzH_xJ-feuDEauPpsQlR6xB5SoueCm2FRkZHvC5Dam6va0x2PGHJWXAKu740r9v3UIobkWSZrpvqbKx0NbXffDYHYx"
        let client = YLPClient(apiKey: apikey)
        
        let location = YLPCoordinate(latitude: latitude, longitude: longitude)
        client.search(with: location, term: searchTerm, limit: 50, offset: 0, sort: .bestMatched, completionHandler: { (search, error)  in
            
            if let err = error {
                print(err.localizedDescription)
            }
            
            if let result = search {
                for business in result.businesses {
                    print(business.name)
                }
            }
        })
  

        
    }
    
   
}



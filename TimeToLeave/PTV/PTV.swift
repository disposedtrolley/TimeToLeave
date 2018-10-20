//
//  PTV.swift
//  TimeToLeave
//
//  Created by James Liu on 20/10/18.
//  Copyright © 2018 James Liu. All rights reserved.
//

import Foundation
import Alamofire

class PTV {
    static let PTV_API_DEVID = "1000851"
    static let PTV_API_SIGNATURE = "1BD56AA0F194639BE4FA2B22687D9275F7E21343"
    
    static let PTV_BASEURL = "https://timetableapi.ptv.vic.gov.au"
    
    static func stops(latitude: Float, longitude: Float, routeTypes: [RouteType]) {
        let endpoint = "\(PTV.PTV_BASEURL)/v3/stops/location/\(latitude),\(longitude)"
        
        let routeTypesFormtted = routeTypes.map { $0.rawValue }
        
        let parameters: Parameters = [
            "route_types": routeTypesFormtted,
            "devid": PTV.PTV_API_DEVID,
            "signature": PTV.PTV_API_SIGNATURE]
        
        
        Alamofire.request(endpoint, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            print(response)
        }
    }
}

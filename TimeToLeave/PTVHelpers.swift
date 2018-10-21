//
//  PTVHelpers.swift
//  
//
//  Created by James Liu on 21/10/18.
//

import Foundation
import SwiftPTV

class PTVHelpers {
    static let communicator: SwiftPTV = SwiftPTV(
        apiKey: APICredentials.API_KEY,
        userID: APICredentials.API_DEVID)
    
    
    static public func getStopsNear(location: Location, routeTypes: [Int], _ completionHandler: @escaping ([StopGeosearch]?) -> ()) {
        
        self.communicator.retrieveStopsNearLocation(location: Location(latitude: -37.8584388, longitude: 145.0268829), parameters: ["route_types": routeTypes.map { String($0) }, "max_distance": 1000]) { response in
            
            completionHandler(response?.stops)
        }
    }
}



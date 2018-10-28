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
        
        PTVHelpers.getRouteTypes() { types in
            
            let selectedTypes: [Int] = types
                .filter({ routeTypes.contains($0.type!) })
                .map({ $0.type! })
            
            self.communicator.retrieveStopsNearLocation(
                location: Location(latitude: -37.8584388, longitude: 145.0268829),
                parameters: ["route_types": selectedTypes,
                            "max_distance": 1000]) { response in
                completionHandler(response?.stops)
            }
        }
    }

    static public func getNextDeparturesFrom(stopId: Int, routeId: Int, direction: Int, _ completionHandler: @escaping ([Departure]?) -> ()) {
        
        PTVHelpers.getRoute(routeId: routeId) { route in
            PTVHelpers.getRouteTypes() { routeTypes in
                self.communicator.retrieveDepartures(stopID: stopId, route: route!, routeType: routeTypes[Config.TEST_ROUTE_TYPE], parameters: nil) { response in
                    
                    // Filter out past departures.
                    let filteredDepartures = response?.departures!.filter({ $0.scheduledDeparture! >= Date() })
                    
                    completionHandler(filteredDepartures)
                }
            }
        }
    }
    
    static public func getRoute(routeId: Int, _ completionHandler: @escaping (Route?) -> ()) {
        self.communicator.retrieveRouteDetails(routeID: routeId, parameters: nil) { response in
            completionHandler(response?.route)
        }
    }
    
    static public func getRouteTypes(_ completionHandler: @escaping ([RouteType]) -> ()) {
        self.communicator.retrieveRouteTypes(parameters: nil) { response in
            completionHandler((response?.routeTypes)!)
        }
    }
    
    static public func getStopsOn(routeId: Int, _ completionHandler: @escaping ([StopOnRoute]) -> ()) {
        PTVHelpers.getRouteTypes() { routeTypes in
            self.communicator.retrieveStopsOnRoute(routeID: routeId, routeType: routeTypes[Config.TEST_ROUTE_TYPE], parameters: nil) { stops in
                completionHandler((stops?.stops)!)
            }
        }
    }
}

//
//  PTVHelpers.swift
//  
//
//  Created by James Liu on 21/10/18.
//

import Foundation
import SwiftPTV

//enum RouteType: Int {
//    case train = 0
//    case tram = 1
//    case bus = 2
//    case vline = 3
//    case nightbus = 4
//}

struct TTLStop {
    var id: Int
    var name: String
    var routeTypes: [RouteType]
}

//struct Departure {
//    var stop: Stop
//    var route: Route
//    var direction: Int
//    var scheduledDeparture: Date
//    var estimatedDeparture: Date
//    var platform: Int
//}

//struct Route {
//    var id: Int
//
//}

class PTVHelpers {
    static let communicator: SwiftPTV = SwiftPTV(
        apiKey: APICredentials.API_KEY,
        userID: APICredentials.API_DEVID)
    
    
//    static public func getStopsNear(location: Location, routeTypes: [RouteType], _ completionHandler: @escaping ([TTLStop]?) -> ()) {
//
//        self.communicator.retrieveStopsNearLocation(location: Location(latitude: -37.8584388, longitude: 145.0268829), parameters: ["route_types": routeTypes.map { String($0.rawValue) }, "max_distance": 1000]) { response in
//
//            var stops: [Stop] = []
//            response?.stops?.forEach() {
//                stops.append(Stop(id: $0.ID!, name: $0.name!, routeTypes: [RouteType(rawValue: $0.routeType!)!]))
//            }
//
//            completionHandler(stops)
//        }
//    }

    static public func getNextDeparturesFrom(stopId: Int, routeId: Int, direction: Int) {
        
        PTVHelpers.getRoute(routeId: routeId) { route in
            PTVHelpers.getRouteType(routeType: 0) { routeType in
                self.communicator.retrieveDepartures(stopID: stopId, route: route!, routeType: routeType, parameters: nil) { departures in
                    print(departures)
                }
            }
        }
    }
    
    static fileprivate func getRoute(routeId: Int, _ completionHandler: @escaping (Route?) -> ()) {
        self.communicator.retrieveRouteDetails(routeID: routeId, parameters: nil) { response in
            completionHandler(response?.route)
        }
    }
    
    static fileprivate func getRouteType(routeType: Int, _ completionHandler: @escaping (RouteType) -> ()) {
        self.communicator.retrieveRouteTypes(parameters: nil) { response in
            completionHandler((response?.routeTypes![routeType])!)
        }
    }


}

//
//  PTVDepartures.swift
//  SwiftPTV
//
//  Copyright (c) 2017 evilgoldfish.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

public extension SwiftPTV {

    typealias DeparturesResponseClosure = (_ response: DeparturesResponse?) -> ()

    /// Retrieve departures for all routes from a stop.
    ///
    /// - Parameters:
    ///   - stopID: Identifier of stop, returned by Stops API.
    ///   - routeType: Object identifying transport mode, returned by RouteTypes API.
    ///   - parameters: The parameters to be passed to the API as a query string. Can be `nil`.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func retrieveDepartures(stopID: Int, routeType: RouteType, parameters: [String : Any]?, _ completionHandler: @escaping DeparturesResponseClosure) {
        guard let routeType = routeType.type else {
            completionHandler(nil)
            return
        }
        
        retrieveURL(endpoint: "/v3/departures/route_type/\(routeType)/stop/\(stopID)", parameters: parameters) { data in
            if let data = data {
                let response = try? self.decoder.decode(DeparturesResponse.self, from: data)
                completionHandler(response)
            } else {
                completionHandler(nil)
            }
        }
    }

    /// Retrieve departures for a specific route from a stop.
    ///
    /// - Parameters:
    ///   - stopID: Identifier of stop, returned by Stops API.
    ///   - route: Object identifying route, returned by Routes API.
    ///   - routeType: Object identifying transport mode, returned by RouteTypes API.
    ///   - parameters: The parameters to be passed to the API as a query string. Can be `nil`.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func retrieveDepartures(stopID: Int, route: Route, routeType: RouteType, parameters: [String : Any]?, _ completionHandler: @escaping DeparturesResponseClosure) {
        guard let routeType = routeType.type,
            let routeID = route.ID else {
            completionHandler(nil)
            return
        }
        
        retrieveURL(endpoint: "/v3/departures/route_type/\(routeType)/stop/\(stopID)/route/\(routeID)", parameters: parameters) { data in
            if let data = data {
                let response = try? self.decoder.decode(DeparturesResponse.self, from: data)
                completionHandler(response)
            } else {
                completionHandler(nil)
            }
        }
    }

}

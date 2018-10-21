//
//  Responses.swift
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

public enum Health: Int, Codable {
    case Offline, Online
}

public struct Status: Codable {
    public let version: String?
    public let health: Health? // 0 == Offline, 1 == Online
}

public struct RouteTypesResponse: Codable {
    public let routeTypes: [RouteType]?
    public let status: Status?
    
    internal enum CodingKeys: String, CodingKey {
        case routeTypes = "route_types", status
    }
}

public struct RoutesResponse: Codable {
    public let routes: [Route]?
    public let status: Status?
}

public struct RouteResponse: Codable {
    public let route: Route?
    public let status: Status?
}

public struct StopsOnRouteResponse: Codable {
    public let stops: [StopOnRoute]?
    public let status: Status?
}

public struct StopsByDistanceResponse: Codable {
    public let stops: [StopGeosearch]?
    public let status: Status?
}

public struct StopResponse: Codable {
    public let stop: StopDetails?
    public let status: Status?
}

public struct DeparturesResponse: Codable {
    public let departures: [Departure]?
    public let status: Status?
}

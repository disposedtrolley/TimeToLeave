//
//  SwiftPTV.swift
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

public class SwiftPTV {
    internal let apiKey: String
    internal let userID: String
    
    internal var routeTypes: [RouteType]?
    internal let decoder: JSONDecoder

    public init(apiKey: String, userID: String) {
        self.apiKey = apiKey
        self.userID = userID
        self.decoder = JSONDecoder()
    }
    
    internal func retrieveURL(endpoint: String, parameters: [String:Any]?, _ completionHandler: @escaping (Data?) -> ()) {
        guard let url = self.returnURL(endpoint: endpoint, parameters: parameters) else {
            completionHandler(nil)
            return
        }

        URLSession.shared.dataTask(with: url) {data, request, error in
            guard let data = data else {
                completionHandler(nil)
                return
            }
            
            completionHandler(data)
            }.resume()
    }
    
    internal func returnURL(endpoint: String, parameters: [String:Any]?) -> URL?
    {
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let timestampComponent = URLQueryItem(name: "timestamp", value: RFC3339DateFormatter.string(from: Date()))

        var components = URLComponents()
        components.path = endpoint
        var queryItems = [URLQueryItem]()

        if let parameters = parameters {
            for (name, value) in parameters {
                if let arrayValue = value as? Array<Any> {
                    // If the parameter passed is an array, re-add the same query
                    // for each item in the array.
                    for subValue in arrayValue {
                        queryItems.append(URLQueryItem(name: name, value: String(describing: subValue)))
                    }
                } else {
                    queryItems.append(URLQueryItem(name: name, value: String(describing: value)))
                }
            }
        }
        
        let userIDComponent = URLQueryItem(name: "devid", value: self.userID)
        queryItems.append(userIDComponent)
        queryItems.append(timestampComponent)

        components.queryItems = queryItems

        guard let urlWithID = components.string,
            let keyData = self.apiKey.data(using: .utf8),
            let urlData = urlWithID.data(using: .utf8),
            let signature = HMAC.sha1(key: keyData, message: urlData) else {
            return nil
        }
        
        components.scheme = "https"
        components.host = "timetableapi.ptv.vic.gov.au"

        let signatureString = signature.map({String(format:"%02hhx",$0)}).joined().uppercased()
        components.queryItems?.append(URLQueryItem(name: "signature", value: signatureString))
        
        return components.url
    }
}

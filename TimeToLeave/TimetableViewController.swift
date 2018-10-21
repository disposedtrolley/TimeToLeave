//
//  TimetableViewController.swift
//  TimeToLeave
//
//  Created by James Liu on 20/10/18.
//  Copyright © 2018 James Liu. All rights reserved.
//

import Cocoa
import SwiftPTV

class TimetableViewController: NSViewController {

    var communicator: SwiftPTV
    
    required init?(coder: NSCoder) {
        self.communicator = SwiftPTV(apiKey: APICredentials.API_KEY, userID: APICredentials.API_DEVID)
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.communicator.retrieveStopsNearLocation(location: Location(latitude: -37.8584388, longitude: 145.0268829), parameters: ["route_types": "[0]", "max_distance": 1000]) {response in
            
            print(response?.stops)
        }
    }
    
}

extension TimetableViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> TimetableViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("TimetableViewController")
        
        guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? TimetableViewController else {
            fatalError("Why can't I find TimetableViewController? - Check Main.storyboard")
        }
        
        return viewController
    }
}

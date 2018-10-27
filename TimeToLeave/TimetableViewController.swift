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
    
    @IBOutlet weak var minsToNextDeparture: NSTextField!
    @IBOutlet weak var minsToNextDepartureDesc: NSTextField!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide all UI elements whilst loading
//        self.minsToNextDeparture.isHidden = true
//        self.minsToNextDepartureDesc.isHidden = true
        
        PTVHelpers.getStopsNear(location: Location(latitude: -37.8584388, longitude: 145.0268829), routeTypes: [0]) { response in
        }
        
        PTVHelpers.getNextDeparturesFrom(stopId: 1071, routeId: 12, direction: 11) { response in
            if response!.count > 0 {
                let nextDept = response![0]
                
                self.updateNextDeparture(nextDept)
            } else {
                print("No departures found")
            }
        }
    }
    
    fileprivate func updateNextDeparture(_ departure: Departure) {
        let departureTime = departure.scheduledDeparture?.toLocalTime()
        let minutesToDeparture = departureTime?.minutesFromNow()
        
        
        self.minsToNextDeparture.stringValue = String(minutesToDeparture!)
        
        self.minsToNextDeparture.isHidden = false
        self.minsToNextDepartureDesc.isHidden = false
        
        
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

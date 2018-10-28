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
    
    @IBOutlet weak var nextDeptMinsTo: NSTextField!
    @IBOutlet weak var nextDeptStation: NSTextField!
    @IBOutlet weak var nextDeptPlatform: NSTextField!
    @IBOutlet weak var nextDeptLine: NSTextField!
    @IBOutlet weak var nextDeptScheduled: NSTextField!
    
    @IBOutlet weak var subsequentDeptsTableView: NSTableView!
    
    @IBOutlet weak var loadingView: NSView!
    @IBOutlet weak var resultsView: NSView!
    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        // @TODO need to preload stop, route, and direction info and persist to local storage
    }
    
    override func viewWillAppear() {
        super.viewDidLoad()
        
        // Animate the loading indicator
        self.loadingIndicator.startAnimation(self)
        
        // Hide all UI elements whilst loading
        self.resultsView.isHidden = true
        self.loadingView.isHidden = false
        
        
        PTVHelpers.getStopsNear(location: Location(latitude: Config.TEST_LATITUDE, longitude: Config.TEST_LONGITUDE), routeTypes: [0]) { response in
        }
        
        PTVHelpers.getNextDeparturesFrom(stopId: Config.ORIGINATING_STOP_ID, routeId: Config.ORIGINATING_ROUTE_ID, direction: Config.ORIGINATIG_DIRECTION) { response in
            // Hide loading indicator and show results
            DispatchQueue.main.async {
                self.resultsView.isHidden = false
                self.loadingView.isHidden = true
                self.loadingIndicator.stopAnimation(self)
                
                if response!.count > 0 {
                    let nextDept = response![0]
                    
                    self.updateNextDeparture(nextDept)
                } else {
                    print("No departures found")
                }
            }
        }
    }
    
    fileprivate func getNextDepartureInfo() {
        
    }
    
    fileprivate func updateNextDeparture(_ departure: Departure) {
        let departureTime = departure.scheduledDeparture!
        let minutesToDeparture = departureTime.minutesFromNow()
        
        self.nextDeptScheduled.stringValue = departure.scheduledDeparture!.toSimpleString()
        self.nextDeptMinsTo.stringValue = String(minutesToDeparture)
        
        let departurePlatform = departure.platformNumber
        self.nextDeptPlatform.stringValue = "Platform \(departurePlatform!)"
        
        let departureStation = "Flinders St"
        self.nextDeptStation.stringValue = departureStation
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

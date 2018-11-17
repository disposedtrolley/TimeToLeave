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
    
    @IBOutlet weak var nextDeptDesc: NSTextField!
    @IBOutlet weak var nextDeptMinsTo: NSTextField!
    @IBOutlet weak var nextDeptStation: NSTextField!
    @IBOutlet weak var nextDeptPlatform: NSTextField!
    @IBOutlet weak var nextDeptLine: NSTextField!
    @IBOutlet weak var nextDeptScheduled: NSTextField!
    
    @IBOutlet weak var subsequentDeptsTableView: NSTableView!
    
    @IBOutlet weak var loadingView: NSView!
    @IBOutlet weak var resultsView: NSView!
    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    
    @IBAction func showSettingsView(_ sender: Any) {
        var myWindow: NSWindow? = nil
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateController(withIdentifier: "settingsWindow") as! NSViewController
        myWindow = NSWindow(contentViewController: controller)
        NSApp.activate(ignoringOtherApps: true)
        myWindow?.makeKeyAndOrderFront(self)
        let vc = NSWindowController(window: myWindow)
        vc.showWindow(self)
    }
    
    var nextDepartures: [Departure]?
    var stops: [StopOnRoute]?
    var route: Route?
    var group: DispatchGroup
    
    required init?(coder: NSCoder) {
        self.nextDepartures = []
        self.stops = []
        self.route = nil
        self.group = DispatchGroup()
        
        super.init(coder: coder)
        
        // @TODO need to preload stop, route, and direction info and persist to local storage
    }
    
    override func viewDidLoad() {
        self.subsequentDeptsTableView.delegate = self
        self.subsequentDeptsTableView.dataSource = self
    }
    
    override func viewWillAppear() {
        super.viewDidLoad()
        
        self.getNextDepartureInfo()
        
        // Animate the loading indicator
        self.loadingIndicator.startAnimation(self)
        
        // Hide all UI elements whilst loading
        self.resultsView.isHidden = true
        self.loadingView.isHidden = false
        
        
        self.group.notify(queue: .main) {
            self.resultsView.isHidden = false
            self.loadingView.isHidden = true
            self.loadingIndicator.stopAnimation(self)
            
            if self.nextDepartures!.count > 0 {
                self.updateNextDeparture(self.nextDepartures![0])
                
                self.subsequentDeptsTableView.reloadData()
            } else {
                print("No departures found")
            }
        }
    }
    
    fileprivate func getNextDepartureInfo() {
        self.group.enter()
        PTVHelpers.getRoute(routeId: Config.ORIGINATING_ROUTE_ID) { response in
            self.route = response
            self.group.leave()
        }
        
        self.group.enter()
        PTVHelpers.getStopsOn(routeId: Config.ORIGINATING_ROUTE_ID) { response in
            self.stops = response
            self.group.leave()
        }
        
        self.group.enter()
        PTVHelpers.getNextDeparturesFrom(stopId: Config.ORIGINATING_STOP_ID, routeId: Config.ORIGINATING_ROUTE_ID, direction: Config.ORIGINATIG_DIRECTION) { response in
            self.nextDepartures = response
            self.group.leave()
        }
        
    }
    
    fileprivate func updateNextDeparture(_ departure: Departure) {
        let departureTime = departure.scheduledDeparture!
        let minutesToDeparture = departureTime.minutesFromNow()
        
        self.nextDeptScheduled.stringValue = departure.scheduledDeparture!.toSimpleString()
        self.nextDeptMinsTo.stringValue = String(minutesToDeparture)
        
        let departurePlatform = departure.platformNumber
        self.nextDeptPlatform.stringValue = "Platform \(departurePlatform!)"
        
        let departureStation = self.stops?.filter({ $0.ID == Config.ORIGINATING_STOP_ID }).first
        self.nextDeptStation.stringValue = (departureStation?.name)!
        
        let line = self.route?.name
        self.nextDeptLine.stringValue = line!
        
        self.nextDeptDesc.stringValue = minutesToDeparture == 1 ? "minute" : "minutes"
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

extension TimetableViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if (self.nextDepartures?.count)! > 0 {
            return self.nextDepartures!.count / 5
        } else {
            return 0
        }
    }
}

extension TimetableViewController: NSTableViewDelegate {
    fileprivate enum CellIdentifiers {
        static let MinutesToDeptCell = "MinutesToDeptCellID"
        static let ScheduledCell = "ScheduledCellID"
        static let LineCell = "LineCellID"
        static let PlatformCell = "PlatformCellID"
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        
        guard let departure = self.nextDepartures?[row] else {
            return nil
        }
        
        // 2
        if tableColumn == tableView.tableColumns[0] {
            text = String(departure.scheduledDeparture!.minutesFromNow())
            cellIdentifier = CellIdentifiers.MinutesToDeptCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = departure.scheduledDeparture!.toSimpleString()
            cellIdentifier = CellIdentifiers.ScheduledCell
        } else if tableColumn == tableView.tableColumns[2] {
            text = self.route!.name!
            cellIdentifier = CellIdentifiers.LineCell
        } else if tableColumn == tableView.tableColumns[3] {
            text = departure.platformNumber!
            cellIdentifier = CellIdentifiers.PlatformCell
        }
        
        // 3
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
}

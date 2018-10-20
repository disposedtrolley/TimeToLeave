//
//  TimetableViewController.swift
//  TimeToLeave
//
//  Created by James Liu on 20/10/18.
//  Copyright © 2018 James Liu. All rights reserved.
//

import Cocoa

class TimetableViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        PTV.stops(latitude: -37.8584388, longitude: 145.0268829, routeTypes: [RouteType.train])
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

//
//  TimeDetailInterfaceController.swift
//  TimeTracker WatchKit Extension
//
//  Created by Rohith Raju on 18/06/18.
//  Copyright © 2018 Rohith Raju. All rights reserved.
//

import WatchKit
import Foundation


class TimeDetailInterfaceController: WKInterfaceController {

    @IBOutlet var clockInLbl: WKInterfaceLabel!
    @IBOutlet var clockOutLbl: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let dates = context as? [Date]{
            let clockIn = dates[0]
            let clockOut = dates[1]
            clockInLbl.setText(clockIn.description)
            clockOutLbl.setText(clockOut.description)
        }
        
    }


}

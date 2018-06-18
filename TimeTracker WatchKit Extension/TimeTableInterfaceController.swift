//
//  TimeTableInterfaceController.swift
//  TimeTracker WatchKit Extension
//
//  Created by Rohith Raju on 18/06/18.
//  Copyright © 2018 Rohith Raju. All rights reserved.
//

import WatchKit
import Foundation


class TimeTableInterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    var clockIns: [Date] = []
    var clockOuts: [Date] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date]{
            self.clockIns = clockIns
        }
        
        if let clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date]{
            self.clockOuts = clockOuts
        }
        
        // Configure interface objects here.
        table.setNumberOfRows(self.clockIns.count, withRowType: "clockInRow")
        
        for i in 0..<self.clockIns.count{
            if let rowController = table.rowController(at: i) as? ClockInRowController{
                let timeInterval = Int(self.clockOuts[i].timeIntervalSince(self.clockIns[i]))
                var currentTimeStr = ""
                
                let hrs = timeInterval / 3600
                let mins = (timeInterval % 3600) / 60
                let secs = timeInterval % 60
                
                if hrs != 0{
                    currentTimeStr += "\(hrs)h"
                }
                if mins != 0 || hrs != 0{
                    currentTimeStr += "\(mins)m"
                }
                
                currentTimeStr += "\(secs)s"
                
                rowController.label.setText(currentTimeStr)
            }
            
        }
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        pushController(withName: "TimeDetail", context: [clockIns[rowIndex],clockOuts[rowIndex]])
    }



}

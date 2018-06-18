//
//  InterfaceController.swift
//  TimeTracker WatchKit Extension
//
//  Created by Rohith Raju on 18/06/18.
//  Copyright © 2018 Rohith Raju. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var topLbl: WKInterfaceLabel!
    @IBOutlet var middleLbl: WKInterfaceLabel!
    @IBOutlet var Btn: WKInterfaceButton!
    var clockedIn: Bool = false
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        updateUI(clockedIn: clockedIn)
    }
    
    
    
    //MARK: Actions
    
    @IBAction func clockInAndClockOut() {
        
        if clockedIn{
          clockedIn = false
        }else{
          clockedIn = true
        }
        updateUI(clockedIn: clockedIn)

    }
    
    func updateUI(clockedIn: Bool){
        if clockedIn{
          //UI for clocked in
            topLbl.setHidden(false)
            Btn.setTitle("Clocked-Out")
            Btn.setBackgroundColor(UIColor.red)
            middleLbl.setText("5m 44s")
        }else{
          //UI for clocked out
          topLbl.setHidden(true)
          Btn.setTitle("Clocked-In")
          Btn.setBackgroundColor(UIColor.green)
          middleLbl.setText("Today\n 3h 44m")
        }
    }
    
}

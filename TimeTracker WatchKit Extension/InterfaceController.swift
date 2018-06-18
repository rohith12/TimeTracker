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
            clockOut()
        }else{
            clockIn()
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
    
    
    func clockIn(){
        clockedIn = true
        UserDefaults.standard.set(Date(), forKey: "clockedIn")
        UserDefaults.standard.synchronize()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date{
               let timeInterval = Int(Date().timeIntervalSince(clockedInDate))
                
               let hrs = timeInterval / 3600
               let mins = (timeInterval % 3600) / 60
               let secs = timeInterval % 60
               
                self.middleLbl.setText("\(hrs)h \(mins)m \(secs)s")
                
            }
        }
    }
    
    func clockOut(){
        clockedIn = false
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date{
            // Adding clock in time to an clock in array
            if var clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date]{
                clockIns.insert(clockedInDate, at: 0)
                UserDefaults.standard.set(clockIns, forKey: "clockIns")
                print(clockIns)
            }else{
                UserDefaults.standard.set([clockedInDate], forKey: "clockIns")
            }
            
            // Adding clock out time to clock out array
            if var clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date]{
                clockOuts.insert(Date(), at: 0)
                UserDefaults.standard.set(clockOuts, forKey: "clockOuts")
                print(clockOuts)
            }else{
                UserDefaults.standard.set([Date()], forKey: "clockOuts")
                
            }
            
            //To check if user lost power to watch or loses network after clocking in
            UserDefaults.standard.set(nil, forKey: "clockedIn")
            
            
        }
        
        UserDefaults.standard.synchronize()
        
    }
    
    
}

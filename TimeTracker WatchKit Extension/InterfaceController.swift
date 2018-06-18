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
    var timer: Timer? = nil
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        
        if UserDefaults.standard.value(forKey: "clockedIn") != nil{
            if timer == nil{
                startTimer()
            }
            clockedIn = true
            updateUI(clockedIn: true)
        }else{
            clockedIn = false
            updateUI(clockedIn: false)
        }
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
            topLbl.setText("Today: \(self.totalTimeWorkedAsString())")
            Btn.setTitle("Clocked-Out")
            Btn.setBackgroundColor(UIColor.red)
            middleLbl.setText("0s")
        }else{
            //UI for clocked out
            topLbl.setHidden(true)
            Btn.setTitle("Clocked-In")
            Btn.setBackgroundColor(UIColor.green)
            middleLbl.setText("Today:\n \(totalTimeWorkedAsString())")
        }
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date{
                
                let timeInterval = Int(Date().timeIntervalSince(clockedInDate))
                let hrs = timeInterval / 3600
                let mins = (timeInterval % 3600) / 60
                let secs = timeInterval % 60
                
                var currentTimeStr = ""
                if hrs != 0{
                    currentTimeStr += "\(hrs)h"
                }
                if mins != 0 || hrs != 0{
                    currentTimeStr += "\(mins)m"
                }
                
                currentTimeStr += "\(secs)s"
                
                
                self.middleLbl.setText(currentTimeStr)
                
                
                self.topLbl.setText("Today: \(self.totalTimeWorkedAsString())")
                
            }
        }
    }
    
    
    func clockIn(){
        clockedIn = true
        UserDefaults.standard.set(Date(), forKey: "clockedIn")
        UserDefaults.standard.synchronize()
        startTimer()
      
    }
    
    func clockOut(){
        
        clockedIn = false
        timer?.invalidate()
        timer = nil
        
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date{
            // Adding clock in time to an clock in array
            
            if var clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date]{
                clockIns.insert(clockedInDate, at: 0)
                UserDefaults.standard.set(clockIns, forKey: "clockIns")
            }else{
                UserDefaults.standard.set([clockedInDate], forKey: "clockIns")
            }
            
            // Adding clock out time to clock out array
            if var clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date]{
                clockOuts.insert(Date(), at: 0)
                UserDefaults.standard.set(clockOuts, forKey: "clockOuts")
            }else{
                UserDefaults.standard.set([Date()], forKey: "clockOuts")
                
            }
            
            //To check if user lost power to watch or loses network after clocking in
            UserDefaults.standard.set(nil, forKey: "clockedIn")
            
            
        }
        
        UserDefaults.standard.synchronize()
        
    }
    
    
    
    func totalClockedTime() -> Int{
        
        if var clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date]{
            if var clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date]{
                var seconds = 0
                for i in 0..<clockIns.count{
                    
                    let currentSeconds = Int(clockOuts[i].timeIntervalSince(clockIns[i]))
                    seconds += currentSeconds
                    
                }
                return seconds
                
            }
            
        }
        
        return 0
    }
    
    func totalTimeWorkedAsString() -> String{
        
        
        var currentClockedInSec = 0
        
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date{
            currentClockedInSec = Int(Date().timeIntervalSince(clockedInDate))
        }
        
        let totalTimeInterval = currentClockedInSec + self.totalClockedTime()
        
        let totalHrs = totalTimeInterval / 3600
        let totalMins = (totalTimeInterval % 3600) / 60
        
        return "\(totalHrs)h \(totalMins)m"
    }
    
    @IBAction func historyAction() {
        pushController(withName: "timeTable", context: nil)
    }
    
    @IBAction func resetAll() {
        
        UserDefaults.standard.set(nil, forKey: "clockOuts")
        UserDefaults.standard.set(nil, forKey: "clockIns")
        UserDefaults.standard.set(nil, forKey: "clockedIn")
        UserDefaults.standard.synchronize()
        updateUI(clockedIn: false)
    }
}

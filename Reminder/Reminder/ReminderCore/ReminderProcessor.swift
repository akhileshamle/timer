//
//  ReminderProcessor.swift
//  Reminder
//
//  Created by Akhilesh Amle on 02/05/21.
//

import UIKit

class ReminderProcessor: NSObject {

    private var shortTimer: Timer?
    private var longTimer: Timer?
    typealias CompletionHandler = (String?) -> ()
    var completionHandler : CompletionHandler?
    private(set) var startTime: Date?
    private(set) var stopTime: Date?
    private(set) var shortMinute : TimeInterval?
    private(set) var longMinute : TimeInterval?
    
    func start(shortMinute: TimeInterval, longMinute: TimeInterval,_ completionHandler: @escaping CompletionHandler) {
        self.completionHandler = completionHandler
        self.shortMinute = shortMinute
        self.longMinute = longMinute
        shortTimer = Timer.scheduledTimer(timeInterval: getMinutes(shortMinute), target: self, selector: #selector(shortTimerEnded), userInfo: nil, repeats: false)
        longTimer = Timer.scheduledTimer(timeInterval: getMinutes(longMinute), target: self, selector: #selector(longTimerEnded), userInfo: nil, repeats: true)
        startTime = Date()
        stopTime = nil
    }
    
    func stop() {
        if stopTime == nil {
            stopTime = Date()
        }
        shortTimer?.invalidate()
        longTimer?.invalidate()
        shortTimer = nil
        longTimer = nil
        completionHandler = nil
    }
    
    func getTimeDifference() -> String? {
        guard let startTime = startTime else { return nil }
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: startTime, to: self.stopTime != nil ? stopTime! : Date())
        var differenceString : String = ""
        if let hour = dateComponents.hour, hour > 0 {
            differenceString += "\(hour)h"
        }
        
        if let minutes = dateComponents.minute, minutes > 0 {
            if differenceString.count > 0 {
                differenceString += ":\(minutes)m"
            } else {
                differenceString += "\(minutes)m"
            }
        }
        if let seconds = dateComponents.second, seconds > 0 {
            if differenceString.count > 0 {
                differenceString += ":\(seconds)s"
            } else {
                differenceString += "\(seconds)s"
            }
        }
        return differenceString
    }
    
    func getStartTime() -> String? {
        guard let startTime = self.startTime else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        return dateFormatter.string(from: startTime)
    }
    
    func getStopTime() -> String? {
        guard let stopTime = self.stopTime else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        return dateFormatter.string(from: stopTime)
    }
    
    func datesForNotifications(numberOfNotifications: Int) -> [Date] {
        var dates : [Date] = []
        guard let startTime = self.startTime else { return [] }
        guard let shortMinute = self.shortMinute else { return [] }
        guard let longMinute = self.longMinute else { return [] }
        dates.append(startTime.addingTimeInterval(60 * shortMinute)) // short minute
        
        for i in 1...numberOfNotifications {
            dates.append(startTime.addingTimeInterval((60 * longMinute) * TimeInterval(i)))
        }
        
        return dates
    }
    
    private func getMinutes(_ unit: TimeInterval) -> TimeInterval {
        return unit * 60
    }
    
    
    @objc private func shortTimerEnded() {
        self.shortTimer?.invalidate()
        self.shortTimer = nil
        self.notifyCompletion(self.getTimeDifference())
    }
    
    @objc private func longTimerEnded() {
        self.notifyCompletion(self.getTimeDifference())
    }
    
    private func notifyCompletion(_ message: String?) {
        self.completionHandler?(message)
    }
}

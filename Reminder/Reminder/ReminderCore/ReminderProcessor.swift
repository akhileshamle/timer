//
//  ReminderProcessor.swift
//  Reminder
//
//  Created by Akhilesh Amle on 02/05/21.
//

import UIKit

class ReminderProcessor: NSObject {

    private var timer: Timer?
    typealias CompletionHandler = (String?) -> ()
    var completionHandler : CompletionHandler?
    private(set) var startTime: Date?
    private(set) var stopTime: Date?
    
    func start(_ completionHandler: @escaping CompletionHandler) {
        self.completionHandler = completionHandler
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerEnded), userInfo: nil, repeats: true)
        startTime = Date()
        stopTime = nil
    }
    
    func stop() {
        if stopTime == nil {
            stopTime = Date()
        }
        timer?.invalidate()
        timer = nil
        completionHandler = nil
    }
    
    func getTimeDifference() -> String? {
        guard let startTime = startTime else { return nil }
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: startTime, to: self.stopTime != nil ? stopTime! : Date())
        var differenceString : String = ""
        if let hour = dateComponents.hour, let minutes = dateComponents.minute, let seconds = dateComponents.second {
            differenceString = "\(String(format: "%02d", hour)):\(String(format: "%02d", minutes)).\(String(format: "%02d", seconds))"
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
        /*
        var dates : [Date] = []
        guard let startTime = self.startTime else { return [] }
        
        guard let longMinute = self.longMinute else { return [] }
        dates.append(startTime.addingTimeInterval(60 * shortMinute)) // short minute
        
        for i in 1...numberOfNotifications {
            dates.append(startTime.addingTimeInterval((60 * longMinute) * TimeInterval(i)))
        }
        
        return dates
         */
        return []
    }
    
    private func getMinutes(_ unit: TimeInterval) -> TimeInterval {
        return unit * 60
    }
    
    @objc private func timerEnded() {
        self.notifyCompletion(self.getTimeDifference())
    }
    
    private func notifyCompletion(_ message: String?) {
        self.completionHandler?(message)
    }
}

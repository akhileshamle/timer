//
//  ReminderViewController.swift
//  Reminder
//
//  Created by Akhilesh Amle on 01/05/21.
//

import UIKit

class ReminderViewController: ReminderBaseViewController {
    
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblStopTime: UILabel!
    @IBOutlet weak var lblLog: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var breatingView: BreathingView!
    @IBOutlet weak var stackView: UIStackView!
    
    var isLoading : Bool = false {
        didSet {
            if self.isLoading {
                self.activityView.isHidden = !self.isLoading
                self.activityView.alpha = 0
                UIView.animate(withDuration: 0.5) {
                    self.activityView.alpha = 1
                }
                self.activity.startAnimating()
                self.breatingView.start()
            } else {
                self.activityView.alpha = 1
                UIView.animate(withDuration: 0.5) {
                    self.activityView.alpha = 0
                } completion: { (true) in
                    if true {
                        self.activityView.isHidden = !self.isLoading
                        self.activity.stopAnimating()
                        self.breatingView.stop()
                    }
                }
            }
        }
    }
    let shortTime : TimeInterval = 1
    let longTime : TimeInterval = 9
    
    var reminder : ReminderProcessor?
    var player : ReminderPlayer?
    
    var queue = DispatchQueue.init(label: "local-notifications-queue", attributes: .concurrent)

    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading = false
        self.btnStart.isHidden = false
        self.btnStop.isHidden = true
        updateStartTimeOnUI(nil)
        updateStopTimeOnUI(nil)
        updateLogOnUI(nil)
        reminder = ReminderProcessor()
        player = ReminderPlayer()
        
        // TODO: test
        /*
        let notificationDate = Date().addingTimeInterval(10)
        NotificationProcessor.shared.scheduleNotification(min: 1, date: notificationDate) { (error) in
            if let error = error {
                print("\(error)")
            } else {
                print("ok")
            }
        }
         */
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            self.stackView.axis = .horizontal
        } else if UIDevice.current.orientation.isPortrait {
            self.stackView.axis = .vertical
        }
    }
    private func fadeInAndOut(currentView: UIView) {
        currentView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            currentView.alpha = 1
        }
    }
    
    private func updateStartTimeOnUI(_ text: String?) {
        if let text = text {
            lblStartTime.alpha = 0
            self.fadeInAndOut(currentView: self.lblStartTime)
            lblStartTime.text = "\(text)"
        } else {
            self.fadeInAndOut(currentView: self.lblStartTime)
            lblStartTime.text = "-"
        }
    }
    
    private func updateStopTimeOnUI(_ text: String?) {
        if let text = text {
            lblStopTime.alpha = 0
            self.fadeInAndOut(currentView: self.lblStopTime)
            lblStopTime.text = "\(text)"
        } else {
            self.fadeInAndOut(currentView: self.lblStopTime)
            lblStopTime.text = "-"
        }
    }
    
    private func updateLogOnUI(_ text: String?, append: Bool = false) {
        if append, let currentText = self.lblLog.text, let text = text {
            self.fadeInAndOut(currentView: self.lblLog)
            self.lblLog.text = "\(currentText), \(text)"
            return
        }
        if let text = text {
            self.fadeInAndOut(currentView: self.lblLog)
            lblLog.text = text
        } else {
            self.fadeInAndOut(currentView: self.lblLog)
            lblLog.text = "-"
        }
    }
    
    @IBAction func didSelectStart(_ sender: Any?) {
        self.btnStart.isHidden = true
        self.btnStop.isHidden = false
        self.isLoading = true
        reminder?.start(shortMinute: shortTime, longMinute: longTime, { message in
            if let message = message {
                self.updateLogOnUI(message)
                self.player?.play()
            }
        })
        
        if let startTime = reminder?.getStartTime() {
            self.updateStartTimeOnUI("\(startTime)")
        }
        
        if let dates = reminder?.datesForNotifications(numberOfNotifications: 3) {
            for date in dates {
                NotificationProcessor.shared.scheduleNotification(min: 9, date: date) { (error) in
                    self.queue.async {
                        if let error = error {
                            print("ui :: error :: \(error)")
                        } else {
                            print("ui :: error :: ok")
                        }
                    }
                }
            }
        }
        
        self.updateStopTimeOnUI(nil)
        self.updateLogOnUI(nil)
    }
    
    @IBAction func didSelectStop(_ sender: Any?) {
        self.btnStart.isHidden = false
        self.btnStop.isHidden = true
        self.isLoading = false
        reminder?.stop()
        NotificationProcessor.shared.removeAllDelivered()
        NotificationProcessor.shared.removeAllPending()
        if let diff = self.reminder?.getTimeDifference() {
            self.updateLogOnUI("\(diff)")
        }
        if let stopTime = reminder?.getStopTime() {
            self.updateStopTimeOnUI("\(stopTime)")
            self.updateLogOnUI("stopped", append: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? InfoViewController {
            controller.shortTime = self.shortTime
            controller.longTime = self.longTime
        }
    }
}

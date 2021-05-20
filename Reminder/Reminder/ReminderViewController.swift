//
//  ReminderViewController.swift
//  Reminder
//
//  Created by Akhilesh Amle on 01/05/21.
//

import UIKit

class ReminderViewController: ReminderBaseViewController {
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    
    var reminder : ReminderProcessor?
    
    var queue = DispatchQueue.init(label: "local-notifications-queue", attributes: .concurrent)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnStart.isHidden = false
        self.btnStop.isHidden = true
        reminder = ReminderProcessor()
    }
    
    private func fadeInAndOut(currentView: UIView) {
        UIView.animate(withDuration: 0.5) {
            currentView.alpha = 0
        } completion: { (completed) in
            if completed {
                UIView.animate(withDuration: 0.5) {
                    currentView.alpha = 1
                }
            }
        }
    }
    
    private func updateTimerOnUI(_ text: String?, fade: Bool = true) {
        if !fade {
            if let text = text {
                lblTimer.text = "\(text)"
            } else {
                lblTimer.text = ""
            }
            return
        }
        
        if let text = text {
            self.fadeInAndOut(currentView: self.lblTimer)
            lblTimer.text = "\(text)"
        } else {
            self.fadeInAndOut(currentView: self.lblTimer)
            lblTimer.text = "-"
        }
    }
    
    @IBAction func didSelectStart(_ sender: Any?) {
        self.btnStart.isHidden = true
        self.btnStop.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fadeInAndOut(currentView: self.lblTimer)
        }
        reminder?.start({ message in
            if let message = message {
                self.updateTimerOnUI(message, fade: false)
            }
        })
                
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
    }
    
    @IBAction func didSelectStop(_ sender: Any?) {
        self.btnStart.isHidden = false
        self.btnStop.isHidden = true
        reminder?.stop()
        NotificationProcessor.shared.removeAllDelivered()
        NotificationProcessor.shared.removeAllPending()
    }
}

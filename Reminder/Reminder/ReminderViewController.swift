//
//  ReminderViewController.swift
//  Reminder
//
//  Created by Akhilesh Amle on 01/05/21.
//

import UIKit

class ReminderViewController: ReminderBaseViewController {
    
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
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
            } else {
                self.activityView.alpha = 1
                UIView.animate(withDuration: 0.5) {
                    self.activityView.alpha = 0
                } completion: { (true) in
                    if true {
                        self.activityView.isHidden = !self.isLoading
                        self.activity.stopAnimating()
                    }
                }
            }
        }
    }
    
    var reminder : ReminderProcessor?
    
    var queue = DispatchQueue.init(label: "local-notifications-queue", attributes: .concurrent)

    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading = false
        self.btnStart.isHidden = false
        self.btnStop.isHidden = true
        updateStartTimeOnUI(nil)
        reminder = ReminderProcessor()
        self.onOrientationDidChange()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.onOrientationDidChange()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.onOrientationDidChange()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.onOrientationDidChange()
    }
    
    private func onOrientationDidChange() {
        if UIDevice.current.orientation.isLandscape {
            self.stackView.axis = .horizontal
        } else if UIDevice.current.orientation.isPortrait {
            self.stackView.axis = .vertical
        }
        self.view.layoutIfNeeded()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.onOrientationDidChange()
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
            lblTimer.alpha = 0
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
        self.isLoading = true
        reminder?.start({ message in
            if let message = message {
                self.updateTimerOnUI(message, fade: false)
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
    }
    
    @IBAction func didSelectStop(_ sender: Any?) {
        self.btnStart.isHidden = false
        self.btnStop.isHidden = true
        self.isLoading = false
        reminder?.stop()
        NotificationProcessor.shared.removeAllDelivered()
        NotificationProcessor.shared.removeAllPending()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

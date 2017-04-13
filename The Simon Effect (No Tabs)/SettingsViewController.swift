//
//  SettingsViewController.swift
//  The Simon Effect (No Tabs)
//
//  Created by Avery Vine on 2016-04-22.
//  Copyright © 2016 Avery Vine. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, UIAlertViewDelegate, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAppearingAttributes()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--- UI Elements ---//
    @IBOutlet var returnButton: UIButton!
    @IBOutlet var eraseStatisticsButton: UIButton!
    @IBOutlet var buttonSelector: UISegmentedControl!
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    @IBOutlet var colorSquare: UIButton!
    @IBOutlet var resetColorsButton: UIButton!
    @IBOutlet var feedbackButton: UIButton!
    @IBOutlet var lightbulbButton: UIButton!
    
    //--- Other Elements ---//
    var selectedButton: Int = 0
    var email: MFMailComposeViewController!
    
    
    //--- UI Functions ---//
    @IBAction func returnButtonPressed() {
        self.presentingViewController!.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func resetColorsButtonPressed() {
        data.setDefaultColors()
        setSliderAttributes()
        setSquareAttributes()
    }
    
    @IBAction func toggleAdsButtonPressed() {
        // Start Code for implementing ads (future release)
        /*
        if !data.adsAreOff {
            let alert = UIAlertController(title: "Turn Off Ads", message: data.adMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Remove Ads", style: .default, handler: { action in
                if action.style == .default {
                    self.toggleAds()
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            toggleAds()
        }
         */
        // End Code for implementing ads (future release)
    }
    
    @IBAction func feedbackButtonPressed() {
        if MFMailComposeViewController.canSendMail() {
            email.mailComposeDelegate = self
            email.setToRecipients([data.emailAddress])
            email.setSubject("Feedback - \(data.gameName)")
            email.setMessageBody("Replace this text with your feedback!", isHTML: false)
            present(email, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Couldn't Open Feedback Editor", message: "Make sure your device is configured properly to send emails. This may include adding an email address in the Settings app, or ensuring that the Mail app is installed (iOS 10 only).", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func segmentedControlAction(_ sender: AnyObject) {
        selectedButton = buttonSelector.selectedSegmentIndex
        setSliderAttributes()
        setSquareAttributes()
    }
    
    @IBAction func redSliderChanged(_ sender: UISlider) {
        if selectedButton == 0 {
            data.buttonOneRed = Int(sender.value)
        }
        else {
            data.buttonTwoRed = Int(sender.value)
        }
        setSquareAttributes()
    }
    
    @IBAction func greenSliderChanged(_ sender: UISlider) {
        if selectedButton == 0 {
            data.buttonOneGreen = Int(sender.value)
        }
        else {
            data.buttonTwoGreen = Int(sender.value)
        }
        setSquareAttributes()
    }
    
    @IBAction func blueSliderChanged(_ sender: UISlider) {
        if selectedButton == 0 {
            data.buttonOneBlue = Int(sender.value)
        }
        else {
            data.buttonTwoBlue = Int(sender.value)
        }
        setSquareAttributes()
    }
    
    @IBAction func alertUserOfErase() {
        let alert = UIAlertController(title: "Erase Statistics", message: "Are you sure you want to erase all of your statistics? This cannot be undone.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Erase", style: .default, handler: { action in
            if action.style == .default {
                self.eraseStatistics()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func lightbulbButtonPressed() {
        let alert = UIAlertController(title: "Credits - \(data.gameName)", message: data.credits, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //--- Other Functions ---//
    func setAttributes() {
        view.backgroundColor = UIColor(red: 0xff/255, green: 0xff/255, blue: 0xcc/255, alpha: 1.0)
    }
    
    func setAppearingAttributes() {
        setSliderAttributes()
        setSquareAttributes()
        setButtonAttributes()
        setEmailAttributes()
    }
    
    func setSliderAttributes() {
        if selectedButton == 0 {
            redSlider.value = Float(data.buttonOneRed)
            greenSlider.value = Float(data.buttonOneGreen)
            blueSlider.value = Float(data.buttonOneBlue)
        }
        else {
            redSlider.value = Float(data.buttonTwoRed)
            greenSlider.value = Float(data.buttonTwoGreen)
            blueSlider.value = Float(data.buttonTwoBlue)
        }
    }
    
    func setButtonAttributes() {
        
        lightbulbButton.setImage(UIImage(named: "Lightbulb.png"), for: UIControlState())
        lightbulbButton.layer.cornerRadius = 10
        lightbulbButton.layer.borderWidth = 1
    }
    
    func setSquareAttributes() {
        colorSquare.layer.borderWidth = 1
        colorSquare.setTitle("", for: UIControlState())
        if selectedButton == 0 {
            colorSquare.backgroundColor = UIColor(red: data.buttonOneRed, green: data.buttonOneGreen, blue: data.buttonOneBlue)
        }
        else {
            colorSquare.backgroundColor = UIColor(red: data.buttonTwoRed, green: data.buttonTwoGreen, blue: data.buttonTwoBlue)
        }
    }
    
    func setEmailAttributes() {
        email = MFMailComposeViewController()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: {
            switch result {
            case MFMailComposeResult.sent:
                let alert = UIAlertController(title: "Feedback Email Sent", message: "Thanks for your input!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case MFMailComposeResult.saved:
                let alert = UIAlertController(title: "Feedback Email Saved", message: "Your feedback email was saved for later.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case MFMailComposeResult.cancelled:
                let alert = UIAlertController(title: "Feedback Email Cancelled", message: "Please don't hesitate to give feedback later on!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            default:
                let alert = UIAlertController(title: "Feedback Email Failed to Send", message: "Uh oh! Something went wrong! Check your email settings.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func eraseStatistics() {
        data.averageCorrectResponseTime = 0.0
        data.averageCongruentResponseTime = 0.0
        data.averageIncongruentResponseTime = 0.0
        data.lowestCorrectResponseTime = 0.0
        data.saveData()
    }
}

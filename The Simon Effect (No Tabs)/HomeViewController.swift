//
//  ViewController.swift
//  The Simon Effect (No Tabs)
//
//  Created by Avery Vine on 2016-04-22.
//  Copyright © 2016 Avery Vine. All rights reserved.
//

import UIKit
import GameKit

class HomeViewController: UIViewController, GKGameCenterControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer()
        setAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAppearingAttributes()
        if data.lastSegue == "StatisticsToInGame" || data.lastSegue == "InGameToHome" {
            startButtonPressed()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //--- UI Elements ---//
    @IBOutlet var startButton: UIButton!
    @IBOutlet var statisticsButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var instructionsButton: UIButton!
    @IBOutlet var lightbulbButton: UIButton!
    
    //--- Other Elements ---//
    var timer: Timer! = nil
    var countdown: Int = 0
    static var gcEnabled = Bool() // Stores if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Stores the default leaderboardID
    
    //--- UI Functions ---//
    @IBAction func startButtonPressed() {
        hideButtons();
        countdown = 3
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(HomeViewController.updateCounter), userInfo: nil, repeats: true)
        timerLabel.text! = "\(countdown)"
    }
    
    @IBAction func statisticsButtonPressed() {
        data.lastSegue = "HomeToStatistics"
        performSegue(withIdentifier: data.lastSegue, sender: self)
    }
    
    @IBAction func settingsButtonPressed() {
        data.lastSegue = "HomeToSettings"
        performSegue(withIdentifier: data.lastSegue, sender: self)
    }
    
    @IBAction func instructionsButtonPressed() {
        let alert = UIAlertController(title: "Instructions - \(data.gameName)", message: data.instructions, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Let's Go!", style: .default, handler: nil))
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
        setButtonAttributes()
        setLabelAttributes()
    }
    
    func setAppearingAttributes() {
        startButton.isHidden = false
        statisticsButton.isHidden = false
        settingsButton.isHidden = false
        instructionsButton.isHidden = false
        lightbulbButton.isHidden = false
        timerLabel.text! = ""
    }
    
    func setButtonAttributes() {
        startButton.layer.cornerRadius = 10
        startButton.layer.borderWidth = 1
        startButton.setTitle(" START ", for: UIControlState())
        startButton.backgroundColor = UIColor.gray
        startButton.setTitleColor(UIColor.white, for: UIControlState())
        startButton.titleLabel!.font = UIFont(name: "Verdana", size: 18)
        startButton.titleLabel!.font = startButton.titleLabel!.font.withSize(28)
        lightbulbButton.setImage(UIImage(named: "Lightbulb.png"), for: UIControlState())
        lightbulbButton.layer.cornerRadius = 10
        lightbulbButton.layer.borderWidth = 1
    }
    
    func setLabelAttributes() {
        timerLabel.text! = ""
        timerLabel.font = UIFont(name: "Verdana", size: 28)
    }
    
    func hideButtons() {
        startButton.isHidden = true
        statisticsButton.isHidden = true
        settingsButton.isHidden = true
        instructionsButton.isHidden = true
        lightbulbButton.isHidden = true
    }
    
    func updateCounter() {
        countdown -= 1
        if countdown == 0 {
            timer!.invalidate()
            timer = nil
            data.lastSegue = "HomeToInGame"
            performSegue(withIdentifier: data.lastSegue, sender: self)
        }
        timerLabel.text! = "\(countdown)"
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                HomeViewController.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if error != nil {
                        print(error!)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                    } as? (String?, Error?) -> Void)
                
                
            } else {
                // 3 Game center is not enabled on the users device
                HomeViewController.gcEnabled = false
                print("Local player could not be authenticated, disabling game center")
                print(error!)
            }
            
        }
        
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

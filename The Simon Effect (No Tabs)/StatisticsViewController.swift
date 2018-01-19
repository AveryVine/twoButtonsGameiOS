//
//  StatisticsViewController.swift
//  The Simon Effect (No Tabs)
//
//  Created by Avery Vine on 2016-04-22.
//  Copyright © 2016 Avery Vine. All rights reserved.
//

import UIKit
import GameKit

class StatisticsViewController: UIViewController, GKGameCenterControllerDelegate {

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
    @IBOutlet var retryButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var statsExplanationButton: UIButton!
    @IBOutlet var correctScore: UILabel!
    @IBOutlet var incorrectScore: UILabel!
    @IBOutlet var correctResponseTimeLabel: UILabel!
    @IBOutlet var overallResponseTimeLabel: UILabel!
    @IBOutlet var averageCorrectResponseTimeLabel: UILabel!
    @IBOutlet var averageCongruentResponseTimeLabel: UILabel!
    @IBOutlet var averageIncongruentResponseTimeLabel: UILabel!
    @IBOutlet var lowestCorrectResponseTimeLabel: UILabel!
    @IBOutlet var lightbulbButton: UIButton!
    @IBOutlet var leaderboardButton: UIButton!
    
    //--- Other Elements --///
    var responseTime: Double = 0.0
    var congruentCount: Int = 0
    
    //--- UI Functions ---//
    @IBAction func retryButtonPressed() {
        if data.lastSegue == "InGameToStatistics" {
            data.lastSegue = "StatisticsToInGame"
            self.presentingViewController!.presentingViewController!.dismiss(animated: false, completion: nil)
        }
        else {
            data.lastSegue = "StatisticsToInGame"
            self.presentingViewController!.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func backButtonPressed() {
        if data.lastSegue == "HomeToStatistics" {
            data.lastSegue = "StatisticsToHome"
            self.presentingViewController!.dismiss(animated: false, completion: nil)
        }
        else {
            data.lastSegue = "StatisticsToHome"
            self.presentingViewController!.presentingViewController!.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func statsExplanationButtonPressed() {
        let alert = UIAlertController(title: "Statistics - Explanation", message: data.statsExplanation, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
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
        setLabelAttributes()
    }
    
    func setAppearingAttributes() {
        responseTime = 0.0
        congruentCount = 0
        setButtonAttributes()
    }
    
    func setButtonAttributes() {
        if data.lastSegue != "InGameToStatistics" {
            retryButton.setTitle("START", for: UIControlState.normal)
        }
        lightbulbButton.setImage(UIImage(named: "Lightbulb.png"), for: UIControlState())
        lightbulbButton.layer.cornerRadius = 10
        lightbulbButton.layer.borderWidth = 1
    }
    
    func setLabelAttributes() {
        if data.lastSegue == "InGameToStatistics" {
            correctScore.text! = "Correct: \(data.correctScore)"
            incorrectScore.text! = "Incorrect: \(data.incorrectScore)"
            if data.correctScore == 0 {
                correctResponseTimeLabel.text! = "Average Correct Response Time: N/A"
            } else {
                for i in 0 ..< data.responseTimes.count {
                    if data.responseWasCorrect[i] {
                        responseTime += data.responseTimes[i]
                        if data.correctScore == 10 {
                            if data.lowestCorrectResponseTime == 0 {
                                data.lowestCorrectResponseTime = data.responseTimes[i]
                            } else if data.responseTimes[i] < data.lowestCorrectResponseTime {
                                data.lowestCorrectResponseTime = data.responseTimes[i]
                            }
                        }
                    }
                }
                if data.correctScore == 10 && HomeViewController.gcEnabled {
                    storeInGameCentre(score: (responseTime / Double(data.correctScore)), leaderboard: data.leaderboardFastestAverageTime)
                    storeInGameCentre(score: data.lowestCorrectResponseTime, leaderboard: data.leaderboardFastestSingleResponse)
                }
                correctResponseTimeLabel.text! = NSString(format: "Average Correct Response Time: %.2f Seconds", (responseTime / Double(data.correctScore))) as String
                responseTime = 0.0
                for time in data.responseTimes {
                    responseTime += time
                }
                overallResponseTimeLabel.text! = NSString(format: "Average Overall Response Time: %.2f Seconds", (responseTime / Double(data.correctScore + data.incorrectScore))) as String
                if data.correctScore == 10 {
                    if data.averageCorrectResponseTime == 0 {
                        data.averageCorrectResponseTime = responseTime / Double(data.correctScore)
                    } else {
                        data.averageCorrectResponseTime = (data.averageCorrectResponseTime + (responseTime / Double(data.correctScore))) / 2
                    }
                    
                    for i in 0 ..< data.responseTimes.count {
                        if data.responseWasCorrect[i] && data.responseWasCongruent[i] {
                            data.averageCongruentResponseTime += data.responseTimes[i]
                            congruentCount += 1
                        }
                    }
                    data.averageCongruentResponseTime /= Double(congruentCount)
                    congruentCount = 0
                    for i in 0 ..< data.responseTimes.count {
                        if data.responseWasCorrect[i] && !data.responseWasCongruent[i] {
                            data.averageIncongruentResponseTime += data.responseTimes[i]
                            congruentCount += 1
                        }
                    }
                    data.averageIncongruentResponseTime /= (Double)(congruentCount)
                }
            }
            
        }
        else {
            correctResponseTimeLabel.text! = "Average Correct Response Time: N/A"
            overallResponseTimeLabel.text! = "Average Overall Response Time: N/A"
            correctScore.text! = "Correct: N/A"
            incorrectScore.text! = "Incorrect: N/A"
        }
        if data.averageCorrectResponseTime != 0 {
            averageCorrectResponseTimeLabel.text! = NSString(format: "Average Correct Response Time: %.2f Seconds", data.averageCorrectResponseTime) as String
        } else {
            averageCorrectResponseTimeLabel.text! = "Average Correct Response Time: N/A"
        }
        if data.averageCongruentResponseTime != 0 {
            averageCongruentResponseTimeLabel.text! = NSString(format: "Average Congruent Response Time: %.2f Seconds", data.averageCongruentResponseTime) as String
        } else {
            averageCongruentResponseTimeLabel.text! = "Average Congruent Response Time: N/A"
        }
        if data.averageIncongruentResponseTime != 0 {
            averageIncongruentResponseTimeLabel.text! = NSString(format: "Average Incongruent Response Time: %.2f Seconds", data.averageIncongruentResponseTime) as String
        } else {
            averageIncongruentResponseTimeLabel.text! = "Average Incongruent Response Time: N/A"
        }
        if data.lowestCorrectResponseTime != 0 {
            lowestCorrectResponseTimeLabel.text! = NSString(format: "Lowest Correct Response Time: %.2f Seconds", data.lowestCorrectResponseTime) as String
        } else if data.averageCorrectResponseTime != 0 {
            lowestCorrectResponseTimeLabel.text! = "Lowest Correct Response Time: N/A (perfect runs only)"
        } else {
            lowestCorrectResponseTimeLabel.text! = "Lowest Correct Response Time: N/A"
        }
    }
    
    func storeInGameCentre(score: Double, leaderboard: String) {
        if score < 60 {
            print("Submitting score: \(score)")
            let sScore = GKScore(leaderboardIdentifier: leaderboard)
            sScore.value = Int64(Double(score * 100.0))
            GKScore.report([sScore], withCompletionHandler: {(error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                else {
                    print("Score submitted")
                }
            })
        }
        else {
            print("Score too large: \(score)")
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func showLeaderboard(sender: UIButton) {
        if HomeViewController.gcEnabled {
            let gcVC: GKGameCenterViewController = GKGameCenterViewController()
            gcVC.gameCenterDelegate = self
            gcVC.viewState = GKGameCenterViewControllerState.leaderboards
            gcVC.leaderboardIdentifier = HomeViewController.gcDefaultLeaderBoard
            self.present(gcVC, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Game Center Unavailable", message: data.gameCentreMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

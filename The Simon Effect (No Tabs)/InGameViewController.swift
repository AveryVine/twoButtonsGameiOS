//
//  InGameViewController.swift
//  The Simon Effect (No Tabs)
//
//  Created by Avery Vine on 2016-04-22.
//  Copyright © 2016 Avery Vine. All rights reserved.
//

import UIKit

class InGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if data.lastSegue == "StatisticsToHome" {
            setAttributes(false)
        }
        else {
            setAttributes(true)
            runGame()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //--- UI Elements ---//
    @IBOutlet var restartButton: UIButton!
    @IBOutlet var buttonOne: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    @IBOutlet var squareOne: UIButton!
    @IBOutlet var squareTwo: UIButton!
    @IBOutlet var numberCompleted: UILabel!
    
    //--- Other Elements ---//
    var squarePosition: Int = 0
    var squareColor: Int = 0
    var currentSquare: UIButton!
    var currentButton: UIButton!
    var startTime: TimeInterval!
    var endTime: TimeInterval!
    var redData: Int = 0
    var greenData: Int = 0
    var blueData: Int = 0
    var colorName: String = ""
    
    
    
    //--- UI Functions ---//
    @IBAction func restartButtonPressed() {
        data.lastSegue = "InGameToHome"
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func buttonOneClicked() {
        buttonClicked(buttonOne)
    }
    
    @IBAction func buttonTwoClicked() {
        buttonClicked(buttonTwo)
    }
    
    //--- Other Functions ---//
    func setAttributes(_ visible: Bool) {
        view.backgroundColor = UIColor(red: 0xff/255, green: 0xff/255, blue: 0xcc/255, alpha: 1.0)
        setButtonAttributes(visible)
        setGameAttributes(visible)
    }
    
    func setGameAttributes(_ visible: Bool) {
        if (visible) {
            data.correctScore = 0
            data.incorrectScore = 0
            data.responseTimes = [Double]()
            data.responseWasCongruent = [Bool]()
            data.responseWasCorrect = [Bool]()
            squarePosition = 0
            squareColor = 0
            numberCompleted.text! = "Completed: \(data.correctScore + data.incorrectScore)"
        }
        else {
            numberCompleted.text! = ""
        }
    }
    
    func setButtonAttributes(_ visible: Bool) {
        if (visible) {
            setButtonProperties(buttonOne)
            setButtonProperties(buttonTwo)
            squareOne.backgroundColor = UIColor.clear
            squareTwo.backgroundColor = UIColor.clear
        }
        else {
            buttonOne.isHidden = true
            buttonTwo.isHidden = true
            squareOne.isHidden = true
            squareTwo.isHidden = true
        }
    }
    
    func setButtonProperties(_ selectedButton: UIButton) {
        if selectedButton == buttonOne {
            redData = data.buttonOneRed
            greenData = data.buttonOneGreen
            blueData = data.buttonOneBlue
        } else {
            redData = data.buttonTwoRed
            greenData = data.buttonTwoGreen
            blueData = data.buttonTwoBlue
        }
        selectedButton.setTitleColor(getButtonTitleColor(), for: UIControlState())
        selectedButton.titleLabel!.font = UIFont(name: "Verdana", size: 26)
        selectedButton.setTitle("", for: UIControlState())
        selectedButton.backgroundColor = UIColor(red: redData, green: greenData, blue: blueData)
        selectedButton.layer.borderWidth = 1
        selectedButton.layer.cornerRadius = 5
        selectedButton.layer.shadowColor = UIColor.black.cgColor
        selectedButton.layer.shadowOpacity = 1.0;
        selectedButton.layer.shadowRadius = 2.0;
        selectedButton.layer.shadowOffset = CGSize(width: 0, height: 6);
    }
    
    func getButtonTitleColor() -> UIColor {
        if redData + greenData + blueData > 650 {
            return UIColor.black
        }
        return UIColor.white
    }
    
    func runGame() {
        if data.numberCompleted() < 10 {
            squarePosition = Int(arc4random_uniform(2))
            squareColor = Int(arc4random_uniform(2))
            if squarePosition == 0 {
                currentSquare = squareOne
            }
            else {
                currentSquare = squareTwo
            }
            squareColor = Int(arc4random_uniform(2))
            if squareColor == 0 {
                currentSquare.backgroundColor = buttonOne.backgroundColor
                currentButton = buttonOne
            }
            else {
                currentSquare.backgroundColor = buttonTwo.backgroundColor
                currentButton = buttonTwo
            }
            currentSquare.layer.borderColor = UIColor.black.cgColor
            if (data.correctScore + data.incorrectScore) % 2 == 0 {
                currentSquare.layer.borderWidth = 5
            } else {
                currentSquare.layer.borderWidth = 1
            }
            startTime = Date.timeIntervalSinceReferenceDate
        }
        else {
            finishProgram()
        }
    }
    
    func buttonClicked(_ button: UIButton) {
        analyzeData(button)
        currentSquare.backgroundColor = UIColor.clear
        currentSquare.layer.borderWidth = 0
        currentSquare.layer.borderColor = UIColor.clear.cgColor
        numberCompleted.text! = "Completed: \(data.correctScore + data.incorrectScore)"
        runGame()
    }
    
    func analyzeData(_ button: UIButton) {
        endTime = Date.timeIntervalSinceReferenceDate
        data.responseTimes.append(endTime - startTime)
        data.responseWasCongruent.append(squarePosition == squareColor)
        data.responseWasCorrect.append(button == currentButton)
        if button == currentButton {
            data.correctScore += 1
        } else {
            data.incorrectScore += 1
        }
    }
    
    func finishProgram() {
        data.lastSegue = "InGameToStatistics"
        performSegue(withIdentifier: data.lastSegue, sender: self)
    }

}

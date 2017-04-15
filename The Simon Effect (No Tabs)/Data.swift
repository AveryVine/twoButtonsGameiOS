//
//  Globals.swift
//  The Simon Effect (No Tabs)
//
//  Created by Avery Vine on 2016-04-22.
//  Copyright © 2016 Avery Vine. All rights reserved.
//

import Foundation

class Data {
    let userDefaults = UserDefaults.standard
    
    //--- Persistant Data ---//
    var buttonOneRed: Int = 255
    var buttonOneGreen: Int = 0
    var buttonOneBlue: Int = 0
    var buttonTwoRed: Int = 0
    var buttonTwoGreen: Int = 0
    var buttonTwoBlue: Int = 255
    var colorsModified: Bool = true
    var adsAreOff: Bool = false
    var averageCorrectResponseTime: Double = 0.0
    var averageCongruentResponseTime: Double = 0.0
    var averageIncongruentResponseTime: Double = 0.0
    var lowestCorrectResponseTime: Double = 0.0
    
    //--- Other Data ---//
    let gameName: String = "Two Buttons"
    let emailAddress: String = "twobuttonsdeveloper@icloud.com"
    var lastSegue: String = ""
    var correctScore: Int = 0
    var incorrectScore: Int = 0
    var responseTimes = [Double]()
    var responseWasCongruent = [Bool]()
    var responseWasCorrect = [Bool]()
    
    let instructions: String = "After pressing Start, two buttons will appear on the screen, each a different colour. A square will appear above one of the two buttons. Tap the button that matches the colour of the square that appears.\n\nExample: A RED square appears above the BLUE button -> tap the RED button.\n\nMatch the colours as quickly as you can! Good luck!"
    
    let statsExplanation: String = "Average Correct Response Time:\nAverage time it takes to correctly match colours\n\nAverage Congruent Response Time:\nAverage time it takes to correctly match colours when the correctly-coloured button is directly beneath the square\n\nAverage Incongruent Response Time:\nAverage time it takes to correctly match colours when the correctly-coloured button is on the opposite side as the square\n\nLowest Correct Response Time:\nLowest time recorded for correctly matching colours (only recorded for games with no mistakes to prevent cheating)"
    
    let credits: String = "Programmer: Avery Vine\n\nGame Concept: Clara Burgener\n\nApp Icon Design: Annika Vine\n\nSpecial Thanks To: Mitchell Grant, Clara Burgener, Toby Sutherland, Connor McCrindle, Shayne McCrindle\n\nBased on the Simon Effect"
    
    let gameCentreMessage: String = "You might not be signed into Game Center. To activate this feature, go to the \"Settings\" app, then scroll down to \"Game Center\" and sign in."
    
    //--- Persistant Data Functions ---//
    init() {
        colorsModified = userDefaults.bool(forKey: "DefaultColors")
        if !colorsModified {
            setDefaultColors()
            colorsModified = true
        }
        else {
            buttonOneRed = userDefaults.integer(forKey: "ButtonOneRed")
            buttonOneGreen = userDefaults.integer(forKey: "ButtonOneGreen")
            buttonOneBlue = userDefaults.integer(forKey: "ButtonOneBlue")
            buttonTwoRed = userDefaults.integer(forKey: "ButtonTwoRed")
            buttonTwoGreen = userDefaults.integer(forKey: "ButtonTwoGreen")
            buttonTwoBlue = userDefaults.integer(forKey: "ButtonTwoBlue")
        }
        adsAreOff = userDefaults.bool(forKey: "ToggleAds")
        averageCorrectResponseTime = userDefaults.double(forKey: "avgCorrect")
        averageCongruentResponseTime = userDefaults.double(forKey: "avgCongruent")
        averageIncongruentResponseTime = userDefaults.double(forKey: "avgIncongruent")
        lowestCorrectResponseTime = userDefaults.double(forKey: "lowestCorrect")
    }
    
    func saveData() {
        userDefaults.set(colorsModified, forKey: "DefaultColors")
        userDefaults.set(adsAreOff, forKey: "ToggleAds")
        userDefaults.set(buttonOneRed, forKey: "ButtonOneRed")
        userDefaults.set(buttonOneGreen, forKey: "ButtonOneGreen")
        userDefaults.set(buttonOneBlue, forKey: "ButtonOneBlue")
        userDefaults.set(buttonTwoRed, forKey: "ButtonTwoRed")
        userDefaults.set(buttonTwoGreen, forKey: "ButtonTwoGreen")
        userDefaults.set(buttonTwoBlue, forKey: "ButtonTwoBlue")
        userDefaults.set(averageCorrectResponseTime, forKey: "avgCorrect")
        userDefaults.set(averageCongruentResponseTime, forKey: "avgCongruent")
        userDefaults.set(averageIncongruentResponseTime, forKey: "avgIncongruent")
        userDefaults.set(lowestCorrectResponseTime, forKey: "lowestCorrect")
        userDefaults.synchronize()
    }
    
    //--- Other Functions ---//
    func numberCompleted() -> Int {
        return correctScore + incorrectScore
    }
    
    func setDefaultColors() {
        buttonOneRed = 255
        buttonOneGreen = 0
        buttonOneBlue = 0
        buttonTwoRed = 0
        buttonTwoGreen = 0
        buttonTwoBlue = 255
    }
}

var data = Data()

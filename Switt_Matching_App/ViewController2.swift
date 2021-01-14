//
//  ViewController2.swift
//  Switt_Matching_App
//
//  Created by Period Two on 2019-05-08.
//  Copyright © 2019 Period Two. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //shuffles array of images, disables the main title and new game button is hidden
        shuffle()
        mainTitle.isUserInteractionEnabled = false
        newGameAction.isHidden = true
        //if it's normal mode, only shows the score, everything else is hidden
        if self.navigationItem.title == "Normal Mode"{
            playerOneScore.isHidden = true
            playerTwoScore.isHidden = true
            playerOneOutlet.isHidden = true
            playerTwoOutlet.isHidden = true
            timeOutlet.isHidden = true
            timeRemaining.isHidden = true
            normalMode = true
            playerTurn.isHidden = true
        //if its timer mode, shows score and time left
        } else if self.navigationItem.title == "Timed Mode" {
            playerOneScore.isHidden = true
            playerTwoScore.isHidden = true
            playerOneOutlet.isHidden = true
            playerTwoOutlet.isHidden = true
            timedMode = true
            playerTurn.isHidden = true
        //if it's two player mode, shows each player's scores and who's turn it is
        } else {
            totalScore.isHidden = true
            scoreOutlet.isHidden = true
            timeOutlet.isHidden = true
            timeRemaining.isHidden = true
            playerOneOutlet.text = playerOneName
            playerTwoOutlet.text = playerTwoName
            playerTurn.text = "It's \(playerOneName)'s turn."
            twoPlayerMode = true
        }
    }
    
    //declaration of global variables as well as array of images
    var pictureArray: [UIImage] = [#imageLiteral(resourceName: "default"), #imageLiteral(resourceName: "default"), #imageLiteral(resourceName: "hamburger"), #imageLiteral(resourceName: "hamburger"), #imageLiteral(resourceName: "tomato"), #imageLiteral(resourceName: "tomato"), #imageLiteral(resourceName: "raider"), #imageLiteral(resourceName: "raider"), #imageLiteral(resourceName: "skulltrooper"), #imageLiteral(resourceName: "skulltrooper"), #imageLiteral(resourceName: "johnwick"), #imageLiteral(resourceName: "johnwick"), #imageLiteral(resourceName: "fish"), #imageLiteral(resourceName: "fish"), #imageLiteral(resourceName: "bunny"), #imageLiteral(resourceName: "bunny")]
    var shuffledArray: [UIImage] = []
    var maincard: UIImage = #imageLiteral(resourceName: "Dh_n9LtW4AEu8oZ copy copy.png")
    var normalMode = false
    var timedMode = false
    var twoPlayerMode = false
    var firstclicked = -1
    var secondclicked = -1
    var matchesInARow = 0
    var matchesRemaining = 8
    var correctMatch = false
    var playerScoreNormal = 0
    var index = 0
    var playerOneName = ""
    var playerTwoName = ""
    var startingTheTimer = 0
    var myTime = 60
    var myTimer = Timer()
    var player1Score = 0
    var player2Score = 0
    var player1or2Turn = 1
    
    //outlets for all labels and buttons
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var scoreOutlet: UILabel!
    @IBOutlet weak var giveUpOutlet: UIButton!
    @IBOutlet weak var newGameAction: UIButton!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var playerOneOutlet: UILabel!
    @IBOutlet weak var playerOneScore: UILabel!
    @IBOutlet weak var playerTwoOutlet: UILabel!
    @IBOutlet weak var playerTwoScore: UILabel!
    @IBOutlet weak var playerTurn: UILabel!
    @IBOutlet weak var mainTitle: UIButton!
    
    //shuffle function
    func shuffle() {
        shuffledArray = pictureArray.shuffled()
    }
    
    //disables all the buttons
    func disable() {
        for allButtons in buttons {
            allButtons.isUserInteractionEnabled = false
        }
    }
    
    //sets the image to a button in my button array based on the image array
    func flip(button:UIButton, image:UIImage) {
        button.setImage(image, for: .normal)
    }
    
    //my timer, begins the timer
    func timer(){
        myTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in self.timerFunction()})
    }
    
    func timerFunction() {
        //subtracts one second every second and displays it
        myTime -= 1
        timeRemaining.text = String(myTime)
        //if there is no time left, the timer stops, everything is disabled and an alert presents itself
        if myTime == 0 {
            myTimer.invalidate()
            disable()
            let timedAlert = UIAlertController(title: "Game Over", message: "You ran out of time. Your score was \(playerScoreNormal) points.", preferredStyle: .alert)
            timedAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.present(timedAlert, animated: true)
            }
        }
        //if there are no matches remaining, the timer stops, all the buttons are diabled, give up button dissappears and new game button appears along withan alert
        if matchesRemaining == 0 {
            myTimer.invalidate()
            disable()
            giveUpOutlet.isHidden = true
            newGameAction.isHidden = false
            let timedAlert = UIAlertController(title: "Game Over", message: "You win. You found all the pairs. Your score was \(playerScoreNormal) points.", preferredStyle: .alert)
            timedAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.present(timedAlert, animated: true)
            }
        }
        
    }
    
    //exponential socring for normal mode
    func scoreForNormal() {
        playerScoreNormal += Int(pow(2, Double(matchesInARow)))
        totalScore.text = String(playerScoreNormal)
    }
    
    //exponential scoring for two player mode, if a player gets a match, they get to go again
    func twoPlayerScoring() {
        if player1or2Turn % 2 != 0 && correctMatch == true {
            player1Score += Int(pow(2, Double(matchesInARow)))
            playerOneScore.text = String(player1Score)
        } else if player1or2Turn % 2 == 0 && correctMatch == true {
            player2Score += Int(pow(2, Double(matchesInARow)))
            playerTwoScore.text = String(player2Score)
        }
    }
    
    //score for timer mode, the quicker a match, the more points rewarded, done exponentially
    func scoreTimer () {
        if myTime >= 50 && buttons[firstclicked].currentImage == buttons[secondclicked].currentImage {
            playerScoreNormal += 64
            totalScore.text = String(playerScoreNormal)
    
        } else if myTime < 50 && myTime >= 40 && buttons[firstclicked].currentImage == buttons[secondclicked].currentImage {
            playerScoreNormal += 32
            totalScore.text = String(playerScoreNormal)
        } else if myTime < 40 && myTime >= 30 && buttons[firstclicked].currentImage == buttons[secondclicked].currentImage {
            playerScoreNormal += 16
            totalScore.text = String(playerScoreNormal)
        } else if myTime < 30 && myTime >= 20 && buttons[firstclicked].currentImage == buttons[secondclicked].currentImage {
            playerScoreNormal += 8
            totalScore.text = String(playerScoreNormal)
        } else if myTime < 20 && myTime >= 10 && buttons[firstclicked].currentImage == buttons[secondclicked].currentImage {
            playerScoreNormal += 4
            totalScore.text = String(playerScoreNormal)
        } else if myTime < 10 && myTime > 0 && buttons[firstclicked].currentImage == buttons[secondclicked].currentImage {
            playerScoreNormal += 2
            totalScore.text = String(playerScoreNormal)
        }
    }
    
    // displays the alert determining who is the winner
    func display_message(alert_winner: UIAlertController) {
        if matchesRemaining == 0 && twoPlayerMode == true {
            newGameAction.isHidden = false
            giveUpOutlet.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.present(alert_winner, animated: true)
            }
        }
    }
    
    func matching (buttonpressed : Int) {
        //begins the time when the first button is pressed
        if startingTheTimer == 1 {
            timer()
        }
        
        //if its normal mode or two player mode the timer is disabled
        if normalMode == true {
            myTimer.invalidate()
            
        }
        
        if twoPlayerMode == true {
            myTimer.invalidate()
        }
        
        //gives the first and second buttons pressed a value and disbales them temporarily
        if firstclicked == -1 {
            firstclicked = buttonpressed
            buttons[firstclicked].isUserInteractionEnabled = false
        } else if secondclicked == -1 {
            secondclicked = buttonpressed
            buttons[secondclicked].isUserInteractionEnabled = false
        }
        //compares the images
        if firstclicked != -1 && secondclicked != -1 {
            if buttons[firstclicked].currentImage == buttons[secondclicked].currentImage{
                //updates correct match
                correctMatch = true
                //updates matches in a row
                matchesInARow += 1
                //whatever mode it is, calls the scoring for that mode
                if twoPlayerMode == true {
                    twoPlayerScoring()
                }
                if normalMode == true {
                    scoreForNormal()
                }
                if timedMode == true {
                    scoreTimer()
                }
                //updates matches remaining
                matchesRemaining -= 1
                
                //alert declaration
                let normalAlert = UIAlertController(title: "GAME OVER", message: "Your score was \(playerScoreNormal).", preferredStyle: .alert)
                normalAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                //if its normal mode and all the matches have been found, hide give up, show new game and display the alert
                if normalMode == true && matchesRemaining == 0 {
                    newGameAction.isHidden = false
                    giveUpOutlet.isHidden = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        self.present(normalAlert, animated: true)
                    }
                }
                
                //if its two player mode and all the matches have been found, hide give up, show new game and display the alert
                if player1Score > player2Score {
                    let twoPlayerAlert = UIAlertController(title: "Game Over", message: "\(playerOneName) had \(player1Score) points and \(playerTwoName) had \(player2Score) points. \(playerOneName) wins!", preferredStyle: .alert)
                    twoPlayerAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    display_message(alert_winner: twoPlayerAlert)
                } else if player2Score > player1Score {
                    let twoPlayerAlert2 = UIAlertController(title: "Game Over", message: "\(playerOneName) had \(player1Score) points and \(playerTwoName) had \(player2Score) points. \(playerTwoName) wins!", preferredStyle: .alert)
                    twoPlayerAlert2.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    display_message(alert_winner: twoPlayerAlert2)
                } else {
                    let twoPlayerAlert3 = UIAlertController(title: "Game Over", message: "\(playerOneName) had \(player1Score) points and \(playerTwoName) had \(player2Score) points. It's a tie!", preferredStyle: .alert)
                    twoPlayerAlert3.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    display_message(alert_winner: twoPlayerAlert3)
                }
                
                //reset first and second image
                firstclicked = -1
                secondclicked = -1
            } else {
                //when they don't match, disables the view controller
               self.view.isUserInteractionEnabled = false
                //updates correct match
                correctMatch = false
                //determining who's turn it is
                if twoPlayerMode == true {
                    if player1or2Turn % 2 != 0 {
                        playerTurn.text = "It's \(playerTwoName)'s turn."
                    } else if player1or2Turn % 2 == 0 {
                        playerTurn.text = "It's \(playerOneName)'s turn."
                    }
                }
                //updates matches in a row
                matchesInARow = 0
                //delays the code so you can see the incorrect image
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    //transition
                    UIView.transition(with: self.buttons[self.firstclicked], duration: 0.5, options: .transitionFlipFromBottom, animations: nil, completion: nil)
                    UIView.transition(with: self.buttons[self.secondclicked], duration: 0.5, options: .transitionFlipFromBottom, animations: nil, completion: nil)
                    //resets the cards flipped images
                    self.buttons[self.firstclicked].setImage(self.maincard, for: .normal)
                    self.buttons[self.secondclicked].setImage(self.maincard, for: .normal)
                    //allows the buttons clicked to be clicked again
                    self.buttons[self.firstclicked].isUserInteractionEnabled = true
                    self.buttons[self.secondclicked].isUserInteractionEnabled = true
                    //counts who's turn
                    self.player1or2Turn += 1
                    //resets variables
                    self.firstclicked = -1
                    self.secondclicked = -1
                    //reenables the view
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    //gives all the buttons a value
    func setImages(){
        for index in 0...15{
            buttons[index].isUserInteractionEnabled = false
        }
    }
    
    //reveal all
    func revealAll() {
        //if the button image is the main card, disable the view, delay, reenable the view and then reveal all the cards that are not flipped, skip over cards that are flipped
        if buttons[index].currentImage == maincard {
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.view.isUserInteractionEnabled = true
                self.buttons[self.index].setImage(self.shuffledArray[self.index], for: .normal)
                UIView.transition(with: self.buttons[self.index], duration: 0.25, options: .transitionFlipFromBottom, animations: nil, completion: nil)
                self.index += 1
                if self.index == 16 {
                    return
                }
                self.revealAll()
            }
            
        } else {
            index += 1
            if index == 16 {
                return
            }
            revealAll()
        }
        
        
    }
    
    //new game
    func newGame() {
            //view is disabled, delay, then view is enabled and all the buttons are flipped to the main card image
            self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.view.isUserInteractionEnabled = true
                self.buttons[self.index].setImage(self.maincard, for: .normal)
                UIView.transition(with: self.buttons[self.index], duration: 0.25, options: .transitionFlipFromBottom, animations: nil, completion: nil)
                self.index += 1
                if self.index == 16 {
                    return
                }
                self.newGame()
            }
        }
    //when one of the main buttons are pressed
    @IBAction func allButtons(_ sender: UIButton) {
        var image: UIImage
        var buttonValue: Int
        //the timer begins
        startingTheTimer += 1
        //switch statement for the buttons pressed
        switch sender {
        //first button
        case buttons[0]:
            image = shuffledArray[0]
            buttonValue = 0
            UIView.transition(with: buttons[0], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //second button
        case buttons[1]:
            image = shuffledArray[1]
            buttonValue = 1
            UIView.transition(with: buttons[1], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //third button
        case buttons[2]:
            image = shuffledArray[2]
            buttonValue = 2
            UIView.transition(with: buttons[2], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //fourth button
        case buttons[3]:
            image = shuffledArray[3]
            buttonValue = 3
            UIView.transition(with: buttons[3], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //fifth button
        case buttons[4]:
            image = shuffledArray[4]
            buttonValue = 4
            UIView.transition(with: buttons[4], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //sixth button
        case buttons[5]:
            image = shuffledArray[5]
            buttonValue = 5
            UIView.transition(with: buttons[5], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //seventh button
        case buttons[6]:
            image = shuffledArray[6]
            buttonValue = 6
            UIView.transition(with: buttons[6], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //eighth button
        case buttons[7]:
            image = shuffledArray[7]
            buttonValue = 7
            UIView.transition(with: buttons[7], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //ninth button
        case buttons[8]:
            image = shuffledArray[8]
            buttonValue = 8
            UIView.transition(with: buttons[8], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //tenth button
        case buttons[9]:
            image = shuffledArray[9]
            buttonValue = 9
            UIView.transition(with: buttons[9], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //eleventh button
        case buttons[10]:
            image = shuffledArray[10]
            buttonValue = 10
            UIView.transition(with: buttons[10], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //twelfth button
        case buttons[11]:
            image = shuffledArray[11]
            buttonValue = 11
            UIView.transition(with: buttons[11], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //thirteenth button
        case buttons[12]:
            image = shuffledArray[12]
            buttonValue = 12
            UIView.transition(with: buttons[12], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //fourteenth button
        case buttons[13]:
            image = shuffledArray[13]
            buttonValue = 13
            UIView.transition(with: buttons[13], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //fifteenth button
        case buttons[14]:
            image = shuffledArray[14]
            buttonValue = 14
            UIView.transition(with: buttons[14], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        //sixteenth button
        default:
            image = shuffledArray[15]
            buttonValue = 15
            UIView.transition(with: buttons[15], duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        }
        
        //calls flip and matching function
        flip(button: sender, image: image)
        matching(buttonpressed: buttonValue)
        

    }
    
    //new game button
    @IBAction func newGame(_ sender: UIButton) {
        //sets all images back to original image and flips them with a delay and shuffles
        setImages()
        index = 0
        newGame()
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.25){
        }
        shuffle()
        //disables all buttons and resets all variables, labels and time
        for allButtons in buttons{
            allButtons.isUserInteractionEnabled = true
        }
        timeRemaining.text = "60"
        myTime = 60
        startingTheTimer = 0
        myTimer.invalidate()
        totalScore.text = "0"
        playerScoreNormal = 0
        player1Score = 0
        player2Score = 0
        playerOneScore.text = "0"
        playerTwoScore.text = "0"
        playerTurn.text = "It's \(playerOneName)'s turn."
        player1or2Turn = 1
        matchesInARow = 0
        matchesRemaining = 8
        correctMatch = false
        //hides new game button and shows give up button
        newGameAction.isHidden = true
        giveUpOutlet.isHidden = false
    }
    
    
    @IBAction func giveUpAction(_ sender: UIButton) {
        //sets all images back to original image and flips them with a delay
        index = 0
        setImages()
        revealAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.25){
        }
        //resets the variable that starts the timer, stops the timer, disables all the button, hides give up button and shows give up button
        startingTheTimer = 0
        myTimer.invalidate()
        newGameAction.isHidden = false
        giveUpOutlet.isHidden = true
        disable()
        
    }
    

}

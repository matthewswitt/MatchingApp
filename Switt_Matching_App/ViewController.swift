
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //disables title button
        mainTitle.isUserInteractionEnabled = false
        
    }

    //declaration of global variables
    var mode = 0
    var normalModePressed = false
    var timedMode = false
    var twoPlayerMode = false
    
    //outlets of button and two text fields
    @IBOutlet weak var mainTitle: UIButton!
    @IBOutlet weak var player1Name: UITextField!
    @IBOutlet weak var player2Name: UITextField!
    
    //when the normal mode button is clicked
    @IBAction func normalClicked(_ sender: UIButton) {
        mode = 1
        performSegue(withIdentifier: "segueToModes", sender: nil)
    }
    
    //when the timer mode button is clicked
    @IBAction func timedClicked(_ sender: UIButton) {
        mode = 2
        performSegue(withIdentifier: "segueToModes", sender: nil
        )
    }
    
    //when the two player mode is clicked
    @IBAction func twoPlayerClicked(_ sender: UIButton) {
        mode = 3
        if player1Name.text == "" || player2Name.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please make sure both player's names are filled out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        performSegue(withIdentifier: "segueToModes", sender: nil)
        
    }
    
    //when the rules button is clicked
    @IBAction func rulesClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToRules", sender: nil)
    }
    
    //prepares the title for the next view as well as if it is two player mode, transfers the naems from this view to the next one
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if mode == 1 {
            segue.destination.navigationItem.title = "Normal Mode"
        } else if mode == 2{
            segue.destination.navigationItem.title = "Timed Mode"
        } else if mode == 3 {
            segue.destination.navigationItem.title = "Two Player Mode"
            let names = segue.destination as! ViewController2
            names.playerOneName = player1Name.text!
            names.playerTwoName = player2Name.text!
        }
    }
    
    
    
    
    
}




import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var boardView: BoardView!
    
    @IBOutlet weak var seventhButton: UIButton!
    @IBOutlet weak var sixthButton: UIButton!
    
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var secondButton: UIButton!
    
    @IBOutlet weak var thirdButton: UIButton!
    
    @IBOutlet weak var fourthButton: UIButton!
    
    @IBOutlet weak var fifthButton: UIButton!
    
    @IBOutlet weak var eigthButton: UIButton!
    
    
    var buttons = [UIButton]()
    
    @IBAction func tileSelected(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let board = appDelegate.board
        let pos = board!.getRowAndColumn(forTile: Int(sender.titleLabel!.text!)!)
        let buttonBounds = sender.bounds
        var buttonCenter = sender.center
        var slide = true
     
        if board!.canSlideTileUp(atRow: pos!.row, Column: pos!.column, currentState: (board?.state)!) {
            buttonCenter.y -= buttonBounds.size.height
        } else if board!.canSlideTileDown(atRow: pos!.row, Column: pos!.column, currentState: (board?.state)!) {
            buttonCenter.y += buttonBounds.size.height
        } else if board!.canSlideTileLeft(atRow: pos!.row, Column: pos!.column, cunrrentState: (board?.state)!) {
            buttonCenter.x -= buttonBounds.size.width
        } else if board!.canSlideTileRight(atRow: pos!.row, Column: pos!.column, currentState: (board?.state)!) {
            buttonCenter.x += buttonBounds.size.width
        } else {
            
            slide = false
            
        }
        if slide {
            
            board!.slideTile(atRow: pos!.row, Column: pos!.column)
            
            // sender.center = buttonCenter // or animate the change
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {sender.center = buttonCenter})
            if (board!.isSolved()) {
                
                UIView.animate(withDuration: 0.5) { () -> Void in
                    self.view.window!.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }
                
                UIView.animate(withDuration: 0.5, delay: 0.45, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    self.view.window!.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
                }, completion: nil)
            }
            
        
        } // end if slide
    } // end tileSelected
    
    //@IBAction func shuffleTiles(_ sender: AnyObject) {
    @IBAction func shuffleTiles(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let board = appDelegate.board!
        board.scramble(numTimes: appDelegate.numShuffles)
        self.boardView.setNeedsLayout()
    
        
    }  // end shuffleTiles()
    
    @IBAction func switchView(_ sender: UIBarButtonItem) {
        let viewOff = (sender.tag == 20)
        
        if (viewOff) {
            sender.tag = 21
            sender.title = "Image"
            boardView.switchTileImages(false)
        } else {
            sender.tag = 20
            sender.title = "Numbers"
            boardView.switchTileImages(true)
        }
    }
    
  @objc func shuffleClicked(button: UIButton)
    {
        print("shuffle clicked")
    }
    
    @objc func hintClicked(_sender: UIBarButtonItem)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let board = appDelegate.board
        board?.initializeSolvingComponents()
    
        let hintString = board?.getSmartHint()
        
        let alert = UIAlertController(title: hintString, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            print("you have pressed the ok button")
        }))
        
        self.present(alert, animated: true, completion: nil)
    
        
    }
    
    func getButtonFromTitle(title: String) -> UIButton?
    {
        for button in buttons{
            
            if button.titleLabel?.text == title
            {
                
                return button
            }
            
        }
        
        return nil
        
    }
    
    
    @objc func solvePuzzleClicked(_sender: UIBarButtonItem)
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let board = appDelegate.board!
        board.resetBoard()
      
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.boardView.shuffleButton.addTarget(self, action: #selector(shuffleTiles(_:)), for: .touchUpInside)
        
        self.boardView.hintButton.addTarget(self, action: #selector(hintClicked(_sender:)), for: .touchUpInside)
        
        self.boardView.bottomButton.addTarget(self, action: #selector(solvePuzzleClicked(_sender:)), for: .touchUpInside)
        
        buttons.append(firstButton)
        buttons.append(secondButton)
        buttons.append(thirdButton)
        buttons.append(fourthButton)
        buttons.append(fifthButton)
        buttons.append(sixthButton)
        buttons.append(seventhButton)
        buttons.append(eigthButton)
        
        
    }
}


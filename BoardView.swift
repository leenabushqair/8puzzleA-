
import UIKit

class BoardView: UIView {


        var board: EightBoard?
    
        public var shuffleButton = UIButton()
        public var hintButton = UIButton()
        public var bottomButton = UIButton()
    
    func boardRect() -> CGRect { // get square for holding 4x4 tiles buttons
        let W = self.bounds.size.width
        let H = self.bounds.size.height
        let margin : CGFloat = 0
        let size = ((W <= H) ? W : H) - margin
        let boardSize : CGFloat = CGFloat((Int(size) + 7)/8)*8.0 // next multiple of 8
        let leftMargin = (W - boardSize)/2
        let topMargin = (H - boardSize)/2
        return CGRect(x: leftMargin, y: topMargin, width: boardSize, height: boardSize)
        
    }
    
    func initializeBoardDesign()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor).isActive = true
        self.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.heightAnchor.constraint(equalToConstant: 800).isActive = true
        
    }
    
    
    func initializeControlButtons()
    {
        
        self.addSubview(shuffleButton)
        shuffleButton.setTitle("Shuffle", for: .normal)
        
        shuffleButton.titleLabel?.textColor = UIColor.white
        shuffleButton.translatesAutoresizingMaskIntoConstraints = false
        shuffleButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        shuffleButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -125).isActive = true
        shuffleButton.layer.masksToBounds = true
        shuffleButton.layer.cornerRadius = 30
        shuffleButton.backgroundColor = UIColor.lightGray
        shuffleButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        shuffleButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        shuffleButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
    
        self.addSubview(hintButton)
        hintButton.setTitle("Hint", for: .normal)
        
        hintButton.titleLabel?.textColor = UIColor.white
        hintButton.translatesAutoresizingMaskIntoConstraints = false
        hintButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        hintButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -125).isActive = true
        hintButton.layer.masksToBounds = true
        hintButton.layer.cornerRadius = 30
        hintButton.backgroundColor = UIColor.lightGray
        hintButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        hintButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        hintButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        self.addSubview(bottomButton)
        bottomButton.setTitle("By Leen Abu Shqair & Radi Barq", for: .normal)
        bottomButton.titleLabel?.textColor = UIColor.white
        bottomButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        bottomButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        bottomButton.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: 0).isActive = true
        bottomButton.backgroundColor = UIColor.lightGray
        bottomButton.heightAnchor.constraint(equalToConstant: 70).isActive = true

    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews() // let autolayout engine finish first
        
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        board = appDelegate.board  // get model from app delegate
        initializeControlButtons()
        self.backgroundColor = UIColor.white
    

        initializeBoardDesign()
        let boardSquare = self.bounds
        
     //   let boardSquare = boardRect()  // determine region to hold tiles (see below)
        let tileSize = (boardSquare.width) / 3
        let tileBounds = CGRect(x: 0, y: 0, width: tileSize, height: tileSize)
        
        for r in 0 ..< 3 {      // manually set the bounds, and of each tile
            for c in 0 ..< 3 {
                let tile = board!.getTile(atRow: r, atColumn: c)
                if tile > 0 {
                    let button = self.viewWithTag(tile) as? UIButton
                    button!.bounds = tileBounds
                   
                    button?.titleLabel?.textAlignment = .center
                    button?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
                    button?.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                    button?.titleLabel?.font = UIFont.systemFont(ofSize: 40)
                    button!.center = CGPoint(x: boardSquare.origin.x + (CGFloat(c) + 0.5)*tileSize,
                                             y: boardSquare.origin.y + (CGFloat(r) + 0.5)*tileSize)
                }
            }
        }
    } // end layoutSubviews()
    
    func switchTileImages(_ imageOn : Bool) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let board = appDelegate.board  // get model from app delegate
        
        for r in 0..<3 {
            for c in 0..<3 {
                let tile = board!.getTile(atRow: r, atColumn: c)
                if tile > 0 {
                    let button = self.viewWithTag(tile) as! UIButton
                    if (imageOn) {
                        button.setTitle("", for: UIControlState.normal)
                        button.titleEdgeInsets = UIEdgeInsets.zero // no margins
                        button.imageEdgeInsets = UIEdgeInsets.zero
                        button.contentEdgeInsets = UIEdgeInsets.zero
                        //button.layoutMargins = UIEdgeInsets.zero
                        button.contentMode = .center
                        button.imageView?.contentMode = UIViewContentMode.scaleAspectFill
                        //button.imageView?.contentMode = .scaleAspectFit
                        let convert : UIImage? = UIImage(named: String(tile))
                        button.setImage(convert, for: .normal)
                    } else {
                        button.setTitle(String(tile), for: UIControlState.normal)
                        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
                        button.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                        button.setImage(nil, for: .normal)
                    }
                }
            }
        }
    }
    
    func switchTileOrder(_ shuffle : Bool) {
        
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let board = appDelegate.board  // get model from app delegate
        
        if (shuffle) {
            board?.scramble(numTimes: 150)
        } else {
            board?.resetBoard()
        }
    }

} // end BoardView()

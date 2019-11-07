


import Foundation

class EightBoard {
    
    var open = [[[Int]]]()
    var close = [[[Int]]]()
    var openHeuristicArray = [Int]()
    var closHeuristicArrray = [Int]()
    var bestMovmentCoordinates = [(Int, Int)]()
    var minIndex = 0
    var bestState = [[Int]]()
    var openDepths = [Int]()
    var initialiHeuristic = 0
    var bestMovmentString = String()
    var depth = 1
    var previousBestState = [[Int]]()
    var bestNextMove = [[Int]]()
    var currentOpenDepth = 0
    
    var state : [[Int]] =   [
        
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 0]
    ]
    
    
    func initializeSolvingComponents(){
        
         open = [[[Int]]]()
         close = [[[Int]]]()
         openHeuristicArray = [Int]()
         bestState = [[Int]]()
         closHeuristicArrray = [Int]()
         openDepths = [Int]()
         bestMovmentCoordinates = [(Int, Int)]()
         previousState = state
         minIndex = 0
         initialiHeuristic = 0
         depth = 1
         open.append(state)
         openDepths.append(0)
         initialiHeuristic = calculateTheHeuristic(child: state)
         openHeuristicArray.append(initialiHeuristic)
    }
    
    // hay kaman
    // hay bdlha sabteeeh ma btt8yar, kolshe tmam..okk
    var goalState: [[Int]] = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 0]
    ]
    
    var previousState = [[Int]]()
    
    
    //number of rows and cols constant ma btt8yro
    let rows = 3
    let cols = 3
    

    func random(_ n:Int) -> Int {
        
        return Int(arc4random_uniform(UInt32(n)))
        

    } // end random()
    

    func swapTile(fromRow r1: Int, Column c1: Int, toRow r2: Int, Column c2: Int, currentState: [[Int]]) {
        state[r2][c2] = state[r1][c1]
        state[r1][c1] = 0
    } // end swapTile()


    func scramble(numTimes n: Int) {
        resetBoard()
        
        for _ in 1...n {
            
            var movingTiles : [(atRow: Int, Column: Int)] = []
            var numMovingTiles : Int = 0
            for r in 0..<rows {
                for c in 0..<cols {
                    if canSlideTile(atRow: r, Column: c, currentState: state) {
                        
                        movingTiles.append((r, c))
                        numMovingTiles = numMovingTiles + 1
                    } // end if canSlideTile()
                } // end for c
            } // end for r
            
            let randomTile = random(numMovingTiles)
            var moveRow : Int, moveCol : Int
            (moveRow , moveCol) = movingTiles[randomTile]
            slideTile(atRow: moveRow, Column: moveCol)
            var value = calculateTheHeuristic(child: state)
            if (value == 7)
            {
                print(value)
                return
            }
            
        } // end for i
        
    } // end scamble()
    
    func getTile(atRow r: Int, atColumn c: Int) -> Int {
        return state[r][c]
    } // end getTile()
    
    func checkIfChildExist(open: [[[Int]]], possibleState: [[Int]]) -> Int?
    {
        var childIndex: Int? = nil
        var indexCounter = 0
        
        for i in open{
            
            if (i == possibleState){
                
                childIndex = indexCounter
                return childIndex
            }
        
          indexCounter = indexCounter + 1
            
        }
        
        return childIndex
    }
    
    func solveThePuzzle() -> (Int, Int, Bool)?
    {
        return nil
    }
    
    func getSmartHint()->String{
        
        while open.isEmpty == false {
            
        minIndex = findMinimum(array: openHeuristicArray)
        bestState = open[minIndex]
        currentOpenDepth = openDepths[minIndex]
        var bestMovmentCoordinate = (0, 0)
        
        if (depth != 1)
        {
            bestMovmentCoordinate = bestMovmentCoordinates[minIndex]
            bestMovmentCoordinates.remove(at: minIndex)
        }
            
        if (currentOpenDepth == 1 && bestState != previousBestState)
        {
            bestMovmentString = String(state[bestMovmentCoordinate.0][bestMovmentCoordinate.1])
            bestNextMove = state
        }
            
        var currentHeuristic = openHeuristicArray[minIndex]
        
        if (bestState == goalState)
        {
            previousBestState = bestNextMove
            return bestMovmentString
        }
        
        open.remove(at: minIndex)
        openDepths.remove(at: minIndex)
        openHeuristicArray.remove(at: minIndex)
        
        for i in 0..<rows{
            
            for j in 0..<cols
            {
                var possibleState = checkSlideTitle(atRow: i, Column: j, currentState: bestState)
                
                if possibleState != bestState //&& possibleState != previousState
                {
                    
                    var childHeuristic = calculateTheHeuristic(child: possibleState) +  currentOpenDepth + 1
    
                    
                    if let index = checkIfChildExist(open: close, possibleState: possibleState)
                    {
                        
                        if (closHeuristicArrray[index] > childHeuristic)
                        {
                            bestMovmentCoordinates.append((i, j))
                            open.append(possibleState)
                            openDepths.append(currentOpenDepth + 1)
                            openHeuristicArray.append(childHeuristic)
                            close.remove(at: index )
                            closHeuristicArrray.remove(at: index)
                        }
                    }
                        
                   else if let index = checkIfChildExist(open: open, possibleState: possibleState)
                    {
                        if (openHeuristicArray[index] > childHeuristic)
                        {
                            openHeuristicArray[index] = childHeuristic
                            openDepths[index] = currentOpenDepth + 1
                        }
                    }
 
                    else{
                        
                        bestMovmentCoordinates.append((i, j))
                        openDepths.append(currentOpenDepth + 1)
                        open.append(possibleState)
                        openHeuristicArray.append(childHeuristic)
                        
                    }
                }
            }
        }
        
        print(currentOpenDepth)
        depth = depth + 1
            
        close.append(bestState)
        closHeuristicArrray.append(currentHeuristic)
            
        //  var  bestTileMovmentString = String(previousState[bestMovmentCoordinate.0][bestMovmentCoordinate.1])
        //print(bestTileMovmentString)
        previousState = bestState
            
        }
        
        return "error in algorithm"

    }
    
    func getHint() -> String
    {
        
        var bestTileMovmentString = String()
        var open = [[[Int]]]()
        var close = [[[Int]]]()
     
        var heuristicArray = [Int]()
        var bestMovmentCoordinates = [(Int, Int)]()
        var minIndex = 0
        
            for i in 0..<rows
            {
                for j in 0..<cols
                {
                    
                    var possibleState = checkSlideTitle(atRow: i, Column: j,  currentState: self.state)
               
                    if possibleState != state && possibleState != previousState
                    {
                        
                        var childHeuristic = calculateTheHeuristic(child: possibleState)
                        bestMovmentCoordinates.append((i, j))
                        open.append(possibleState)
                        heuristicArray.append(childHeuristic)
                    }
                    
                }
            }
        
         minIndex = findMinimum(array: heuristicArray)
         var bestState = open[minIndex]
         previousState = state
        
        if (bestState == goalState)
        {
            print("solved")
            
        }
        
         var bestMovmentCoordinate = bestMovmentCoordinates[minIndex]
         bestTileMovmentString = String(state[bestMovmentCoordinate.0][bestMovmentCoordinate.1])

         return bestTileMovmentString
    }
    
    
    func findMinimum(array: [Int]) -> Int
    {
        
        var counter = 0
        var min = 10000
        var minIndex = 0
        for i in array
        {
            if (i < min)
            {
                minIndex = counter
                min = i
            }
            counter = counter + 1
        }
        
        return minIndex
    }
    func calculateTheHeuristic(child: [[Int]]) -> Int
    {
        var heuristic = 0
        
        for i in 0..<rows{
            
            for j in  0..<cols
            {
                if (child[i][j] == 0)
                {
                    continue
                }
 
                if child[i][j] != goalState[i][j]
                {
                    heuristic = heuristic + 1
                }
            }
        }
        
        return heuristic
    }
    
    func getRowAndColumn(forTile tile: Int) -> (row: Int, column: Int)? {
        if (tile > (rows*cols-1)) {
            
            return nil
            
        }
        for x in 0..<rows {
            for y in 0..<cols {
                if ((state[x][y]) == tile) {
                    return (row: x,column: y)
                }
            }
        }
        return nil
    } // end getRowAndColumn()

    func canSlideTileUp(atRow r : Int, Column c : Int, currentState: [[Int]]) -> Bool {
            return (r < 1) ? false : ( currentState[r-1][c] == 0 )
    } // end canSlideTileUp
    
    // Determine if the specified tile can be slid up into the empty space.
    func canSlideTileDown(atRow r :  Int, Column c :  Int, currentState:[[Int]]) -> Bool {
        return (r > (rows-2)) ? false : ( currentState[r+1][c] == 0 )
    } // end canSlideTileDown
    
    func canSlideTileLeft(atRow r :  Int, Column c :  Int, cunrrentState:[[Int]]) -> Bool {
            return (c < 1) ? false : ( cunrrentState[r][c-1] == 0 )
    } // end canSlideTileLeft
    
    func canSlideTileRight(atRow r :  Int, Column c :  Int, currentState:[[Int]]) -> Bool {
            return (c > (cols-2)) ? false : ( currentState[r][c+1] == 0 )
    } // end canSlideTileRight
    
    func canSlideTile(atRow r :  Int, Column c :  Int, currentState: [[Int]]) -> Bool {
        
        return  (canSlideTileRight(atRow: r, Column: c, currentState: currentState) ||
            canSlideTileLeft(atRow: r, Column: c, cunrrentState: currentState) ||
            canSlideTileDown(atRow: r, Column: c, currentState: currentState) ||
            canSlideTileUp(atRow: r, Column: c, currentState: currentState))
    } // canSlideTile()

    
    func checkSlideTitle(atRow r: Int, Column c: Int, currentState: [[Int]]) -> ([[Int]])
    {
        var possibleState = currentState
        
        if (r > rows || c > cols || r < 0 || c < 0) {
            
            return possibleState
        }
    
        if (canSlideTile(atRow: r, Column: c, currentState: currentState)) {
            if (canSlideTileUp(atRow: r, Column: c, currentState: currentState)) {
    
                possibleState[r - 1][c] = possibleState[r][c]
                possibleState[r][c] = 0
            }
            
            if (canSlideTileDown(atRow: r, Column: c, currentState: currentState)) {
                
                possibleState[r + 1][c] = possibleState[r][c]
                possibleState[r][c] = 0
            }
            if (canSlideTileLeft(atRow: r, Column: c, cunrrentState: currentState)) {
                
                possibleState[r][c - 1] = possibleState[r][c]
                possibleState[r][c] = 0
                
            }
            if (canSlideTileRight(atRow: r, Column: c, currentState: currentState)) {
               
                possibleState[r][c + 1] = possibleState[r][c]
                possibleState[r][c] = 0
            }
        }
        
        return possibleState
    }
    
    
    func slideTile(atRow r: Int, Column c: Int) {
        // basecase
        if (r > rows || c > cols || r < 0 || c < 0) {
            
            return
        }
        
        if (canSlideTile(atRow: r, Column: c, currentState: state)) {
            if (canSlideTileUp(atRow: r, Column: c, currentState: state)) {
                swapTile(fromRow: r, Column: c, toRow: r-1, Column: c, currentState: state)
            }
            if (canSlideTileDown(atRow: r, Column: c, currentState: state)) {
                swapTile(fromRow: r, Column: c, toRow: r+1, Column: c, currentState: state)
            }
            if (canSlideTileLeft(atRow: r, Column: c, cunrrentState: state)) {
                swapTile(fromRow: r, Column: c, toRow: r, Column: c-1, currentState: state)
            }
            if (canSlideTileRight(atRow: r, Column: c, currentState: state)) {
                swapTile(fromRow: r, Column: c, toRow: r, Column: c+1, currentState: state)
            }
        } // end if canSlideTile
        
    } // end slideTile()
    
    func isSolved() -> Bool {
        
        var comparison = 1
        for r in 0..<rows {
            for c in 0..<cols {
                if state[r][c] != comparison%9 {
                    return false
                } // end if
                comparison = comparison + 1
            }
        }
        return true
    }
    
    
    func resetBoard() {
        var set = 1
        for r in 0..<rows {
            for c in 0..<cols {
                state[r][c] = set%9
                set = set + 1
            }
        }
    }
}

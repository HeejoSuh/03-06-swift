//------------------------------------------------//
//  TicTacToe.swift
//
//  This program plays the Tic Tac Toe game using recursion
//
//
//  Created by Heejo Suh in May 2018
//  Copyright @ 2018 MTHS. All rights reserved.
//
//			swiftc TicTacToe.swift
//------------------------------------------------



//--------------------------------------------------------------------
public class TicTacToe {
	//plays the game of unbeatable tictactoe usingrecursion
	
	var board: [[Int]]
	
	var playerMark: Int
	var computerMark: Int
	
	var marksOnGrid: Int
	var computerNextPos: [Int]
	
	var userTurn: Bool
	
	
//----------------------------
	init() {
			//Default constructor
		board = [[0,0,0],[0,0,0],[0,0,0]]
		
		playerMark = 1
		computerMark = 5
		
		marksOnGrid =  0
		computerNextPos = [0,0]
		
		userTurn =  true
	}
	
	
//----------------------------
	func playGame() {
		//plays the game
		
		show()
		
		while marksOnGrid < 8  && !hasWon(markValue: computerMark) && !hasWon(markValue: playerMark) {
			
			//user turn
        	placeUserInput()
        	
        	//computer turn
        	let _ = minimax(nth: 0, computerTurn: true)
	        board[computerNextPos[0]][computerNextPos[1]] = computerMark
			marksOnGrid+=1
			show()
		}
		
		//shows who lost, won, or tied
		if hasWon(markValue: computerMark) && !hasWon(markValue: playerMark) {
            print("You lost!")
		} else if hasWon(markValue: playerMark) && !hasWon(markValue: computerMark) {
            print("You win!") //never happens
		} else {
            print("You tied!")
		}
	}
	
	
	
	//----------------------
	func show() {
		//shows the current grid

		print("\n ------------") //top
		
		for rows in 0..<board.count {
			//print spaces or o's or x's
			//-----
			var stringToPrint: String = ""
			for nth in 0..<board[rows].count {
				//check input and print
				stringToPrint += "| "
				if board[rows][nth] == playerMark {
					//user
					stringToPrint += "O "
				} else if board[rows][nth] == computerMark {
					//computer
					stringToPrint += "X "
				} else {
					//print space
					stringToPrint += "  "
				}
			}
			print("\(stringToPrint)|")
			//-----
			// draw new line
			print("------------")
		}
	}
	
	//----------------------
	func hasWon(markValue: Int) -> Bool {
		//checks for a winner and returns if player wins or not
		//Diagonally
		if (board[0][0] == board[1][1] && board[0][0] == board[2][2] && 
		board[0][0] == markValue) || (board[0][2] == board[1][1] && board[0][2] == board[2][0] && board[0][2] == markValue) {
			//System.out.println("X Diagonal Win")
			return true
		}
		//horizontally and vertically
		for nth in 0..<3 {
            if ((board[nth][0] == board[nth][1] && board[nth][0] == board[nth][2] && board[nth][0] == markValue)
            		|| (board[0][nth] == board[1][nth] && board[0][nth] == board[2][nth] && board[0][nth] == markValue)) {
            	return true
            }
        }
		//if reach here, has not won
        return false
	}
	
	//----------------------
	func placeUserInput() {
		//gets the input of where the user wants to place the O on the grid and returns it
		
		while true {
			let column = getIntInput(askFor: "which column do you choose?")
			let row = getIntInput(askFor: "which row do you choose?")

			if board[row][column]==0 {
				//if available
				board[row][column] = playerMark //add to array
				marksOnGrid+=1
				break
			} else {
				print("Unavailable!")
			}
		}
	}
	
	//----------------------
	func getIntInput(askFor: String) -> Int {
		//gets the input of where the user wants to place the O on the grid and returns it
		
		while true {

			//--------------
			print(askFor)

			let input = readLine(strippingNewline: true)
			//--------------
			//check response
			//if valid input 
			if let inputNumber = Int(input!) {
				//check if response is an integer
				if inputNumber > 0 && inputNumber <= board.count {
					//check if input is valid
					return inputNumber-1
				} else {
					print("Error: Invalid input!")
				}
			} else { 
				print("Insert an integer!")
			}
			//--------------
		}
	}
	
		
	//----------------------
	func availablePos() -> [[Int]] {
		//checks for empty positions and returns the list
		var availablePos = [[Int]]()
        for row in 0..<3 {
        	//for each row
            for column in 0..<3 {
            	//for each column
                if (board[row][column] == 0) {
                	//if position is empty, add the position to the list
                	let pos = [row, column]
                	availablePos.append(pos)
                }
            }
        }
        return availablePos
    }

	//----------------------
    func minimax(nth: Int, computerTurn: Bool) -> Int {
    	/* return a value if a terminal state is found (+10, 0, -10)
		1. Go through available spots on the board and
		call the minimax function on each (recursion)
		
		2. Evaluate returning values from function calls
		and return the best value
		
		"MinMax Algorithm", also known as MiniMax Algorithm, 
		is an recursive algorithm used in two players games 
		such as Tic Tac Toe, Chess etc to find the optimal moves. 
		It is used to minimize the worst case (Maximum Loss) scenario. 
		
	explanation for solution retrieved from
	http://www.letscodepro.com/tic-tac-toe-minmax-alpha-beta-pruning-python/
    	 */
    	
    	//Check if the users have win or lost
        if hasWon(markValue : computerMark) {
        	return +10 //return positive
        }
        if hasWon(markValue : playerMark) {
        	return -10 //return negative
        }
        
        //-------------------
        //Get a list of available positions
        var availablePositions = availablePos()
        
        if availablePositions.count == 0 {
            //check if all the places have been marked
        	return 0
        }
      
        //initially set min to 'max' and max to 'min'
        var minimum : Int = 9
        var maximum: Int = 1 

        //-------------------
        for index in 0..<availablePositions.count {
        	//for each available position
            let x : Int = availablePositions[index][0]
			let y : Int = availablePositions[index][1]
            
            //----------------
            if computerTurn {
                board[x][y] = computerMark
                let currentScore : Int = minimax(nth: nth + 1, computerTurn: false)
                //compare and sets the maximum to a larger value
                maximum = max(currentScore, maximum)
 
                if currentScore >= 0 { 
                	if(nth == 0) {
                		computerNextPos = availablePositions[index]
                	}
                }
                if currentScore == 1 {
                	board[x][y] = 0 
                	break
                }
                if index == availablePositions.count-1 && maximum < 0 {
                	if(nth == 0) {
                		computerNextPos = availablePositions[index]
            		}
            	}
            //----------------
            } else if  !computerTurn  {
                board[x][y] = playerMark
                let currentScore : Int = minimax(nth: nth + 1, computerTurn: true)
                //compare and sets the minimum to a lesser value
                minimum = min(currentScore, minimum)
                if minimum == -1 {
                	board[x][y] = 0
                	break
                }
            }
        board[x][y] = 0  //Reset this point
        }
        //If turn equals computer, return max else return min
        return computerTurn == true ? maximum : minimum ;
    }

}	
//----------------------------------------------




let game = TicTacToe()
//play game
game.playGame()
	
	
	
	

import Foundation
// CLI for playing tic tac toe
@main
struct SwiftTacToe {
    static func main() {
        printCentered("Swift Tac Toe", ANSIColor.magenta)
        gameLoop()
    }
}

enum ANSIColor: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case reset = "\u{001B}[0;0m"
}

typealias Board = [[String]]

enum Player: String {
    case player1 = "X"
    case player2 = "O"
}

func newBoard() -> Board {
    return [
        [" ", " ", " "],
        [" ", " ", " "],
        [" ", " ", " "],
    ]
}

func printBoard(board: Board) {
    print("\n-------")
    for row in board.reversed() {  // Iterate through board in reverse so 0,0 refers to bottom row
        print("|", terminator: "")
        for tile in row {
            print(tile, terminator: "|")
        }
        print("\n-------")
    }
}

func getMove(player: Player, board: Board) -> (x: Int, y: Int) {
    print("Enter the coordinates for your move (ex. 1,1)")
    while true {
        guard let playerInput = readLine() else {
            continue
        }
        
        let coords = playerInput.split(separator: ",")
        guard coords.count == 2 else {
            print("Coordinates must be separated by a single comma (ex. 3,1)")
            continue
        }
        
        guard let x = Int(coords[0]), let y = Int(coords[1]) else {
            print("Coordinates must be integers between 1 and 3 (ex. 3,1)")
            continue
        }
        
        guard x >= 1 && x <= 3 && y >= 1 && y <= 3 else {
            print("Coordinate values must be between 1 and 3 (ex. 1,3)")
            continue
        }

        guard board[y - 1][x - 1] == " " else {
            print("That spot is already taken!")
            continue
        }

        return (x - 1, y - 1) // subtract 1 from captured coordinates to make them zero indexed
    }
}

func makeMove(board: Board, p: Player, x: Int, y: Int) -> Board {
    var boardWithMove = board
    boardWithMove[y][x] = p.rawValue
    return boardWithMove
}

func determineWinner(board: Board) -> Player? {
    /// Converts tile to player
    func getPlayer(tile: String) -> Player? {
        switch tile {
            case "X":
                Player.player1
            case "O":
                Player.player2
            default:
                nil
        }
    }

    // Check horizontal
    for row in board {
        if row[0] != " " && row[0] == row[1] && row[1] == row[2] {
            return getPlayer(tile: row[0])
        }
    }

    //check vertical
    for col in 0...2 {
        if board[col][0] != " " && board[col][0] == board[col][1] && board[col][1] == board[col][2] {
            return getPlayer(tile: board[col][0])
        }
    }

    // check diagonal
    if board[0][0] != " " && board[0][0] == board[1][1] && board[1][1] == board[2][2] {
        return getPlayer(tile: board[0][0])
    } else if board[0][2] != " " && board[0][2] == board[1][1] && board[1][1] == board[2][0] {
        return getPlayer(tile: board[0][2])
    }

    return nil
}

func isDraw(board: Board) -> Bool {
    for row in board {
        for tile in row {
            if tile == " " {
                return false
            }
        }
    }
    return true
}

func nextPlayersTurn(currentPlayer: Player) -> Player {
    return Player.player2
}

func printCentered(_ text: String, _ color: ANSIColor? = nil) {
    // Get the terminal width
    var w = winsize()
    if ioctl(STDOUT_FILENO, TIOCGWINSZ, &w) == 0 {
        let terminalWidth = Int(w.ws_col)
        
        // Calculate padding
        let padding = max(0, (terminalWidth - text.count) / 2)
        
        // Create centered string
        var centeredText = String(repeating: " ", count: padding) + text
        
        // Apply color if specified
        if let color = color {
            centeredText = color.rawValue + centeredText + ANSIColor.reset.rawValue
        }
        
        // Print the centered text
        print(centeredText)
    } else {
        // Fallback if unable to get terminal width
        print(text)
    }
}

func clearTerminal() {
    print("\u{001B}[2J\u{001B}[H", terminator: "")
}


func gameLoop() {
    // Initial state of the game, player1 starts
    var board = newBoard()
    var player = Player.player1
    var winner: Player?
    var draw: Bool = false

    while winner == nil && !draw {
        print("Player \(player.rawValue)'s turn")
        printBoard(board: board)

        let (x, y) = getMove(player: player, board: board)
        board = makeMove(board: board, p: player, x: x, y: y)

        player = player == Player.player1 ? Player.player2 : Player.player1

        draw = isDraw(board: board)
        winner = determineWinner(board: board)
        clearTerminal()
    }
    
    if draw {
        printBoard(board: board)
        print("It's a draw!")
    } else {
        printBoard(board: board)
        print("\(winner?.rawValue ?? "nobody") wins!")
    }
}

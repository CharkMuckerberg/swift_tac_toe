// CLI for playing tic tac toe
@main
struct SwiftTacToe {
    static func main() {
        print("Swift Tac Toe")
        gameLoop()
    }
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
        return (x - 1, y - 1) // subtract 1 from captured coordinates to make them zero indexed
    }
}

func makeMove(board: Board, p: Player, x: Int, y: Int) -> Board {
    var boardWithMove = board
    boardWithMove[y][x] = p.rawValue
    return boardWithMove
}

func determineWinner(board: Board) -> Player? {
    return Player.player1
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

func gameLoop() {
    // Initial state of the game, player1 starts
    var board = newBoard()
    var player = Player.player1
    var winner: Player?
    var draw: Bool = false

    while winner == nil || !draw {
        print("Player \(player.rawValue)'s turn")
        printBoard(board: board)

        let (x, y) = getMove(player: player, board: board)
        board = makeMove(board: board, p: player, x: x, y: y)

        player = player == Player.player1 ? Player.player2 : Player.player1

        draw = isDraw(board: board)
        winner = determineWinner(board: board)
    }
    if draw {
        print("It's a draw!")
    } else {
        print("\(winner?.rawValue ?? "nobody") wins!")
    }
}

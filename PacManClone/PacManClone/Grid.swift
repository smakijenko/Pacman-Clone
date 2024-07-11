import SpriteKit

class Grid: SKNode {
// Variables
    var gridArray: [SKSpriteNode] = []
    
// Inits
    override init() {
        super.init()
        draw(grid)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// Methods
    func draw(_ grid: [[Int]]) {
        for row in 0 ..< grid.count {
            for col in 0 ..< grid[row].count {
                let square = SKSpriteNode()
                square.size = squareSize
                square.color = .blue
                square.position = CGPoint(
                    x: CGFloat(col) * squareSize.width + squareSize.width / 2,
                    y: screenSize.height - CGFloat(row) * squareSize.height - squareSize.height / 2
                )
                if grid[row][col] == 1 {
                    addChild(square)
                    gridArray.append(square)
                }
            }
        }
    }
}

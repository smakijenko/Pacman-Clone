import SpriteKit

class Food: SKNode {
// Variables
    var foodArray: [SKShapeNode] = []
    var energizerArray: [SKShapeNode] = []

    
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
                if grid[row][col] == 2 {
                    let food = SKShapeNode(circleOfRadius: squareSize.width / 10.666666)
                    food.fillColor = .white
                    food.position = CGPoint(
                        x: CGFloat(col) * squareSize.width + squareSize.width / 2,
                        y: screenSize.height - CGFloat(row) * squareSize.height - squareSize.height / 2
                    )
                    addChild(food)
                    foodArray.append(food)
                }
                else if grid[row][col] == 3{
                    let energizer = SKShapeNode(circleOfRadius: squareSize.width / 3.25)
                    energizer.fillColor = .white
                    energizer.position = CGPoint(
                        x: CGFloat(col) * squareSize.width + squareSize.width / 2,
                        y: screenSize.height - CGFloat(row) * squareSize.height - squareSize.height / 2
                    )
                    addChild(energizer)
                    energizerArray.append(energizer)
                }
            }
        }
    }
    
    func eating(pacman: PacMan){
        var index = 0
        for f in foodArray{
            if pacman.pacman.intersects(f){
                f.removeFromParent()
                foodArray.remove(at: index)
                score += 1
                break
            }
            index += 1
        }
    }
    
    func energizerEaten(pacman: PacMan) -> Bool{
        var index = 0
        for e in energizerArray{
            if pacman.pacman.intersects(e){
                e.removeFromParent()
                energizerArray.remove(at: index)
                score += 50
                return true
            }
            index += 1
        }
        return false
    }
}

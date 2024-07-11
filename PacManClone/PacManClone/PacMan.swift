import SpriteKit

class PacMan: SKNode{
    // Variables
    let pacman: SKShapeNode
    var pacmanPos = CGPoint(x: 10, y: 15)
    var possibleDirection = CGVector(dx: 0, dy: 1)
    
    // Inits
    override init() {
        pacman = SKShapeNode(circleOfRadius: screenWidth * 0.01959) // 7.7
        super.init()
        
        // Pacman Inits
        pacman.zPosition = 1
        pacman.fillColor = .yellow
        pacman.strokeColor = .clear
        pacman.position = CGPoint(
            x: pacmanPos.x * squareSize.width + squareSize.width / 2,
            y: screenSize.height - pacmanPos.y * squareSize.height - squareSize.height / 2
        )
        addChild(pacman)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Methods
    func update(direction: CGVector) {
        let newPos = CGPoint(x: pacmanPos.x + direction.dx, y: pacmanPos.y + direction.dy)
        
        // Teleport, moving handling
        if newPos == CGPoint(x: 0, y: 9){
            pacmanPos = CGPoint(x: 19, y: 9)
        }
        else if newPos == CGPoint(x: 20, y: 9){
            pacmanPos = CGPoint(x: 1, y: 9)
        }
        else if !isWall(pos: newPos, grid: grid){
            pacmanPos = newPos
        }
        
        // Changing position
        pacman.position = CGPoint(
            x: pacmanPos.x * squareSize.width + squareSize.width / 2,
            y: screenSize.height - pacmanPos.y * squareSize.height - squareSize.height / 2
        )
    }
    
    func ghostCollision(ghost: Ghost){
        if !ghost.isFrightened{
            if pacmanPos == ghost.ghostPos {lifes -= 1}
        }
        else{
            if pacmanPos == ghost.ghostPos {
                score += 100
                ghost.isFrightened = false
                ghost.ghostPos = ghost.startPos!
                ghost.isOut = false
            }
        }
    }
}

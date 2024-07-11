import SpriteKit

class ArrowKeyes: SKNode{
// Variables
    let buttonSize = CGSize(width: 0.178117 * screenWidth, height: 0.082159 * screenHeight) // 70/70
    var direction = CGVector(dx: 0, dy: 0)
    
    let arrowUp = SKSpriteNode(imageNamed: "arrowUp")
    let arrowDown = SKSpriteNode(imageNamed: "arrowDown")
    let arrowLeft = SKSpriteNode(imageNamed: "arrowLeft")
    let arrowRight = SKSpriteNode(imageNamed: "arrowRight")

// Inits
    init(pos: CGPoint) {
        super.init()
        // Arrow up Inits
        arrowUp.size = buttonSize
        arrowUp.position = CGPoint(x: pos.x, y: pos.y + buttonSize.height)
        addChild(arrowUp)

        // Arrow down Inits
        arrowDown.size = buttonSize
        arrowDown.position = CGPoint(x: pos.x, y: pos.y - buttonSize.height)
        addChild(arrowDown)

        // Arrow left Inits
        arrowLeft.size = buttonSize
        arrowLeft.position = CGPoint(x: pos.x - buttonSize.width, y: pos.y)
        addChild(arrowLeft)

        // Arrow right Inits
        arrowRight.size = buttonSize
        arrowRight.position = CGPoint(x: pos.x + buttonSize.width, y: pos.y)
        addChild(arrowRight)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SpriteKit

class Background: SKNode{  
// Variables
    let background: SKSpriteNode
    
// Inits
    override init(){
        background = SKSpriteNode(imageNamed: "background")
        super.init()
        
        // Background Inits
        background.size = screenSize
        background.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        background.zPosition = 0
        addChild(background)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

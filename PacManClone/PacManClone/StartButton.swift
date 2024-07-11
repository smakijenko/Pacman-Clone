import Foundation
import SpriteKit

class StartButton: SKNode{
// Variables
    let startButtonSize = CGSize(width: screenWidth * 0.3562, height: screenHeight * 0.08216) // 140/70
    let startButton: SKShapeNode
    let startButtonLabel: SKLabelNode
    
// Inits
    init(pos: CGPoint) {
        startButton = SKShapeNode(rectOf: startButtonSize, cornerRadius: 10)
        startButtonLabel = SKLabelNode(text: "START")
        super.init()
        
        // Start button Inits
        startButton.position = pos
        startButton.fillColor = .gray
        startButton.strokeColor = .black
        
        // StartButtonLabel Inits
        startButtonLabel.color = .white
        startButtonLabel.fontSize = 45
        startButtonLabel.position = CGPoint(x: pos.x, y: pos.y - screenHeight * 0.01761)
        
        addChild(startButton)
        addChild(startButtonLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

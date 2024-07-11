import Foundation
import SwiftUI
import SpriteKit
import AudioToolbox

// Sizes, positions, colors etc.
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let screenSize = UIScreen.main.bounds.size // 393/852
let squareSize = CGSize(width: 0.040712 * screenWidth, height: 0.018779 * screenHeight) // 16/16
let wallGridPosition = CGPoint(x: 0.035 * screenWidth, y: -0.0927 * screenHeight)
let pink = UIColor(red: 1, green: 0.7216, blue: 1, alpha: 1)

// Variables
var score = 0
var pastLifes = 3
var lifes = 3
var gameover = false
var waitingDirection: CGVector? // Handling moving
var timeCounting: Double = 0 // timer for changing game modes
var gamemode = "scatter" //chase, scatter, frightened or empty
var lastUpdateTime025: Double = 0 // updating pacman and timer
var lastUpdatetime030: Double = 0 // updating ghosts

class GameScene: SKScene, SKPhysicsContactDelegate{
// Objects
    let wallGrid = Grid()
    let background = Background()
    let pacman = PacMan()
    let arrowKeyes = ArrowKeyes(pos: CGPoint(x: 270, y: 250))
    let food = Food()
    let scoreLabel = SKLabelNode()
    let modeLabel = SKLabelNode()
    let lifesLabel = SKLabelNode()
    let redGhost = Ghost(color: .red, pos: CGPoint(x: 10, y: 7))
    let pinkGhost = Ghost(color: pink, pos: CGPoint(x: 10, y: 9))
    let blueGhost = Ghost(color: .cyan, pos: CGPoint(x: 9, y: 9))
    let orangeGhost = Ghost(color: .orange, pos: CGPoint(x: 11, y: 9))
    let starButton = StartButton(pos: CGPoint(x: screenWidth / 4, y: screenHeight / 6))
    
// Inits
    override init() {
        // Scene Inits
        super.init(size: UIScreen.main.bounds.size)
        self.scaleMode = .resizeFill
        self.backgroundColor = .black
        
        // WallGrid Inits
        wallGrid.position = wallGridPosition
        wallGrid.zPosition = -1
        wallGrid.xScale = 1.09
        
        // ArrowKeyes Inits
        arrowKeyes.isUserInteractionEnabled = false
        
        // ScoreLabel Inits
        scoreLabel.fontColor = .black
        scoreLabel.fontSize = 45
        scoreLabel.position = CGPoint(x: screenWidth / 5, y: screenHeight / 2.2)
        scoreLabel.text = String(score)
        
        // ModeLabel Inits
        modeLabel.fontColor = .black
        modeLabel.fontSize = 45
        modeLabel.position = CGPoint(x: screenWidth / 1.5, y: screenHeight / 2.2)
        modeLabel.text = gamemode.uppercased()
        
        // Lives Inits
        lifesLabel.fontColor = .black
        lifesLabel.fontSize = 45
        lifesLabel.position = CGPoint(x: screenWidth / 4, y: screenHeight / 2.5)
        lifesLabel.text = "Lifes: \(lifes)"
        
        // StartButton Inits
        starButton.alpha = 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        wallGrid.addChild(pacman)
        wallGrid.addChild(food)
        wallGrid.addChild(redGhost)
        wallGrid.addChild(blueGhost)
        wallGrid.addChild(pinkGhost)
        wallGrid.addChild(orangeGhost)
        addChild(wallGrid)
        addChild(background)
        addChild(arrowKeyes)
        addChild(scoreLabel)
        addChild(modeLabel)
        addChild(lifesLabel)
        addChild(starButton)
    }
    
// Updating the scene
    override func update(_ currentTime: TimeInterval) {
        if !gameover{
            if eventTriggered(interval: 0.25, lastUpdateTime: &lastUpdateTime025) {
                // Pacman movement
                pacman.update(direction: arrowKeyes.direction)
                if let waitingDir = waitingDirection {
                    if canMoveInDirection(direction: waitingDir, pacman: pacman) {
                        arrowKeyes.direction = waitingDir
                        waitingDirection = nil
                    }
                }
                // Timer
                timeCounting += 0.25
                if timeCounting >= 8 {
                    gamemode = "chase"
                    redGhost.isFrightened = false
                    pinkGhost.isFrightened = false
                    blueGhost.isFrightened = false
                    orangeGhost.isFrightened = false
                }
                if timeCounting == 16{
                    gamemode = "scatter"
                    timeCounting = 0
                }
            }
            
            // Ghosts handling
            if eventTriggered(interval: 0.3, lastUpdateTime: &lastUpdatetime030){
                // Ghosts gamemodes
                if gamemode == "chase"{
                    // Red ghost chase
                    redGhost.ghostFollowTarget(target: pacman.pacmanPos, gamemode: gamemode)
                    // Pink ghost chase
                    pinkGhost.ghostFollowTarget(target: CGPoint(x: pacman.pacmanPos.x + arrowKeyes.direction.dx * 4, y: pacman.pacmanPos.y + arrowKeyes.direction.dy * 4), gamemode: gamemode)
                    // Blue ghost chase
                    let vector = CGVector(dx: redGhost.ghostPos.x - pacman.pacmanPos.x + arrowKeyes.direction.dx, dy: redGhost.ghostPos.y - pacman.pacmanPos.y + arrowKeyes.direction.dy)
                    let vectorRotated = CGVector(dx: vector.dx * (-1), dy: vector.dy * (-1))
                    blueGhost.ghostFollowTarget(target: CGPoint(x: pacman.pacmanPos.x + arrowKeyes.direction.dx + vectorRotated.dx, y: pacman.pacmanPos.y + arrowKeyes.direction.dy + vectorRotated.dy), gamemode: gamemode)
                    // Orange ghost chase
                    if distanceBetweenPoints(pacman.pacmanPos, orangeGhost.ghostPos) > 8 {orangeGhost.ghostFollowTarget(target: pacman.pacmanPos, gamemode: gamemode)}
                    else {orangeGhost.ghostFollowTarget(target: CGPoint(x: 0, y: 20), gamemode: gamemode)}
                }
                else if gamemode == "scatter"{
                    // Red ghost scatter
                    redGhost.ghostFollowTarget(target: CGPoint(x: 20, y: 0), gamemode: gamemode)
                    // Blue ghost scatter
                    blueGhost.ghostFollowTarget(target: CGPoint(x: 20, y: 20), gamemode: gamemode)
                    // Pink ghost scatter
                    pinkGhost.ghostFollowTarget(target: CGPoint(x: 0, y: 0), gamemode: gamemode)
                    // Orange ghost scatter
                    orangeGhost.ghostFollowTarget(target: CGPoint(x: 0, y: 20), gamemode: gamemode)
                }
                else if gamemode == "frightened"{
                    // Red ghost frightened
                    redGhost.ghostFollowTarget(target: getRandomTarget(), gamemode: gamemode)
                    // Blue ghost frightened
                    blueGhost.ghostFollowTarget(target: getRandomTarget(), gamemode: gamemode)
                    // Pink ghost frightened
                    pinkGhost.ghostFollowTarget(target: getRandomTarget(), gamemode: gamemode)
                    // Orange ghost frightened
                    orangeGhost.ghostFollowTarget(target: getRandomTarget(), gamemode: gamemode)
                }
            }
            
            // Gameover handling
            if lifes == 0{
                lifesLabel.fontSize = 35
                lifesLabel.text = "GAME OVER"
                gameover = true
                starButton.alpha = 1
            }
            
            // Ghosts/Pacman collision handling
            pacman.ghostCollision(ghost: redGhost)
            pacman.ghostCollision(ghost: pinkGhost)
            pacman.ghostCollision(ghost: blueGhost)
            pacman.ghostCollision(ghost: orangeGhost)
            if pastLifes != lifes{
                pastLifes = lifes
                redGhost.minusLife()
                pinkGhost.minusLife()
                blueGhost.minusLife()
                orangeGhost.minusLife()
                pacman.pacmanPos = CGPoint(x: 10, y: 15)
                arrowKeyes.direction = CGVector(dx: 0, dy: -1)
                timeCounting = 0
                gamemode = "scatter"
            }
            
            // Eating handling
            food.eating(pacman: pacman)
            if food.energizerEaten(pacman: pacman){
                timeCounting = 0
                gamemode = "frightened"
                redGhost.isFrightened = true
                pinkGhost.isFrightened = true
                blueGhost.isFrightened = true
                orangeGhost.isFrightened = true
            }
            
            // Labels handling
            scoreLabel.text = String(score)
            modeLabel.text = gamemode.uppercased()
            lifesLabel.text = "Lifes: \(lifes)"
        }
    }
    
    func eventTriggered(interval: TimeInterval, lastUpdateTime: inout Double) -> Bool {
        let currentTime = NSDate().timeIntervalSince1970
        if currentTime - lastUpdateTime >= interval {
            lastUpdateTime = currentTime
            return true
        }
        return false
    }
    
    func getRandomTarget() -> CGPoint{
        let x = Int.random(in: 0 ... 20)
        let y = Int.random(in: 0 ... 20)
        return CGPoint(x: x, y: y)
    }
    
// Steering buttons handling (arrows)
    let touchVibrates = UIImpactFeedbackGenerator(style: .light)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // Up
            if arrowKeyes.arrowUp.contains(location) {
                touchVibrates.impactOccurred()
                arrowKeyes.arrowUp.setScale(0.9)
                arrowKeyes.arrowUp.alpha = 0.7
                let newDirection = CGVector(dx: 0, dy: -1)
                if canMoveInDirection(direction: newDirection, pacman: pacman) {
                    arrowKeyes.direction = newDirection
                } else {
                    waitingDirection = newDirection
                }
            }
            
            // Down
            if arrowKeyes.arrowDown.contains(location) {
                touchVibrates.impactOccurred()
                arrowKeyes.arrowDown.setScale(0.9)
                arrowKeyes.arrowDown.alpha = 0.7
                let newDirection = CGVector(dx: 0, dy: 1)
                if canMoveInDirection(direction: newDirection, pacman: pacman) {
                    arrowKeyes.direction = newDirection
                } else {
                    waitingDirection = newDirection
                }
            }
            
            // Left
            if arrowKeyes.arrowLeft.contains(location) {
                touchVibrates.impactOccurred()
                arrowKeyes.arrowLeft.setScale(0.9)
                arrowKeyes.arrowLeft.alpha = 0.7
                let newDirection = CGVector(dx: -1, dy: 0)
                if canMoveInDirection(direction: newDirection, pacman: pacman) {
                    arrowKeyes.direction = newDirection
                } else {
                    waitingDirection = newDirection
                }
            }
            
            // Right
            if arrowKeyes.arrowRight.contains(location) {
                touchVibrates.impactOccurred()
                arrowKeyes.arrowRight.setScale(0.9)
                arrowKeyes.arrowRight.alpha = 0.7
                let newDirection = CGVector(dx: 1, dy: 0)
                if canMoveInDirection(direction: newDirection, pacman: pacman) {
                    arrowKeyes.direction = newDirection
                } else {
                    waitingDirection = newDirection
                }
            }
            
            // Start Button
            if starButton.contains(location){
                touchVibrates.impactOccurred()
                starButton.setScale(0.9)
                starButton.alpha = 0.7
                lifes = 3
                pastLifes = 3
                score = 0
                wallGrid.draw(grid)
                food.draw(grid)
                redGhost.minusLife()
                pinkGhost.minusLife()
                blueGhost.minusLife()
                orangeGhost.minusLife()
                pacman.pacmanPos = CGPoint(x: 10, y: 15)
                arrowKeyes.direction = CGVector(dx: 0, dy: -1)
                timeCounting = 0
                gameover = false
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            //Up
            if arrowKeyes.arrowUp.contains(location) {
                arrowKeyes.arrowUp.setScale(1)
                arrowKeyes.arrowUp.alpha = 1
            }
            
            // Down
            if arrowKeyes.arrowDown.contains(location) {
                arrowKeyes.arrowDown.setScale(1)
                arrowKeyes.arrowDown.alpha = 1
            }
            
            // Left
            if arrowKeyes.arrowLeft.contains(location) {
                arrowKeyes.arrowLeft.setScale(1)
                arrowKeyes.arrowLeft.alpha = 1
            }
            
            // Right
            if arrowKeyes.arrowRight.contains(location) {
                arrowKeyes.arrowRight.setScale(1)
                arrowKeyes.arrowRight.alpha = 1
            }
            
            // Start Button
            if starButton.contains(location){
                starButton.setScale(1)
                starButton.alpha = 0
            }
        }
    }
}

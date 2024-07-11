import SpriteKit

class Ghost: SKNode {
// Variables
    let ghost: SKShapeNode
    let ghostRect: SKShapeNode
    var ghostPos: CGPoint
    
    let upDirection = CGVector(dx: 0, dy: 1)
    let downDirection = CGVector(dx: 0, dy: -1)
    let leftDirection = CGVector(dx: -1, dy: 0)
    let rightDirection = CGVector(dx: 1, dy: 0)

    var pastPos = CGPoint(x: 10, y: 8)
    
    var isOut = false
    var normalColor: UIColor?
    var startPos: CGPoint?
    var isFrightened = false
    
// Inits
    init(color: UIColor, pos: CGPoint) {
        ghost = SKShapeNode(circleOfRadius: squareSize.width / 2.666666)
        ghostRect = SKShapeNode(rectOf: CGSize(width: squareSize.width / 1.333333, height: squareSize.height / 2))
        ghostPos = pos
        normalColor = color
        startPos = pos
        super.init()
        
        //Ghost Inits
        ghost.zPosition = 1
        ghost.fillColor = color
        ghost.strokeColor = .clear
        ghost.position = CGPoint(
            x: ghostPos.x * squareSize.width + squareSize.width / 2,
            y: screenSize.height - ghostPos.y * squareSize.height - squareSize.height / 2
        )
        
        //GhostRect Inits
        ghostRect.zPosition = -1
        ghostRect.fillColor = color
        ghostRect.strokeColor = .clear
        ghostRect.position = CGPoint(x: 0, y: -squareSize.height / 4)
        
        ghost.addChild(ghostRect)
        addChild(ghost)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// Methods
    func ghostFollowTarget(target: CGPoint, gamemode: String){
        // Variables
        var copyTarget = CGPoint(x: 10, y: 7)
        
        let newUpPos = CGPoint(x: ghostPos.x + upDirection.dx, y: ghostPos.y + upDirection.dy)
        let newDownPos = CGPoint(x: ghostPos.x + downDirection.dx, y: ghostPos.y + downDirection.dy)
        let newLeftPos = CGPoint(x: ghostPos.x + leftDirection.dx, y: ghostPos.y + leftDirection.dy)
        let newRightPos = CGPoint(x: ghostPos.x + rightDirection.dx, y: ghostPos.y + rightDirection.dy)
        
        if ghostPos == CGPoint(x: 10, y: 7) {isOut = true}
        if isOut {copyTarget = target}
        
        let distanceFromUp = distanceBetweenPoints(newUpPos, copyTarget)
        let distanceFromDown = distanceBetweenPoints(newDownPos, copyTarget)
        let distanceFromLeft = distanceBetweenPoints(newLeftPos, copyTarget)
        let distanceFromRight = distanceBetweenPoints(newRightPos, copyTarget)
        
        let directions = [
        (newUpPos, distanceFromUp),
        (newLeftPos, distanceFromLeft),
        (newDownPos, distanceFromDown),
        (newRightPos, distanceFromRight)
        ]
        
        // Filtering best direction
        var filteredDirections = directions.filter {!isWall(pos: $0.0, grid: grid) && $0.0 != pastPos} .sorted {$0.1 < $1.1}
        if filteredDirections.count == 0{
            filteredDirections = directions.filter {!isWall(pos: $0.0, grid: grid)} .sorted {$0.1 < $1.1}
        }
        let nextPos = filteredDirections.first!.0
        
        // Teleport, moving handling
        if nextPos == CGPoint(x: 0, y: 9){
            ghostPos = CGPoint(x: 19, y: 9)
            pastPos = CGPoint(x: 20, y: 9)
        }
        else if nextPos == CGPoint(x: 20, y: 9){
            ghostPos = CGPoint(x: 1, y: 9)
            pastPos = CGPoint(x: 0, y: 9)
        }
        else{
            pastPos = ghostPos
            ghostPos = nextPos
        }
        
        // Changing position
        ghost.position = CGPoint(
            x: ghostPos.x * squareSize.width + squareSize.width / 2,
            y: screenSize.height - ghostPos.y * squareSize.height - squareSize.height / 2
        )
        if gamemode == "frightened" && isFrightened{
            ghost.fillColor = .blue
            ghostRect.fillColor = .blue
        }
        else{
            ghost.fillColor = normalColor!
            ghostRect.fillColor = normalColor!
        }
    }
    
    func minusLife(){
        ghostPos = startPos!
        isOut = false
    }
}

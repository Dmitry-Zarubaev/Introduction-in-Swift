//
//  GameScene.swift
//  snake8lessons
//
//  Created by MICHAIL SHAKHVOROSTOV on 07.02.2022.
//

import SpriteKit
import GameplayKit


struct CollisionCategories {
    static let Snake: UInt32 = 0x1 << 0 // 0001 1
    static let SnakeHead: UInt32 = 0x1 << 1 // 0010 2
    static let Apple: UInt32 = 0x1 << 2 //0100 4
    static let StageEdge: UInt32 = 0x1 << 3 //1000 8
}

class GameScene: SKScene {
    
    var snake: Snake?
    
    private func makeButton(name: String, position: CGPoint) -> SKShapeNode {
        let button = SKShapeNode()
        button.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        button.position = position
        button.fillColor = .gray
        button.strokeColor = .gray
        button.lineWidth = 10
        button.name = name
        return button
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.allowsRotation = false
        view.showsPhysics = true
        
        
        let counterClockWiseButton = makeButton(name: "counterClockWiseButton", position: CGPoint(x: view.scene!.frame.minX + 30, y: view.scene!.frame.minY + 30))
        self.addChild(counterClockWiseButton)
        
        let clockwiseButton = makeButton(name: "clockwiseButton", position: CGPoint(x: view.scene!.frame.maxX - 80, y: view.scene!.frame.minY + 30))
        self.addChild(clockwiseButton)
        
        createApple()
        
        snake = Snake(atPoint: CGPoint(x: view.scene!.frame.midX, y: view.scene!.frame.midY), stage: size)
        self.addChild(snake!)
        
        
        self.physicsWorld.contactDelegate = self
        
        
        self.physicsBody?.categoryBitMask = CollisionCategories.StageEdge
        self.physicsBody?.collisionBitMask = CollisionCategories.Snake | CollisionCategories.SnakeHead
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode,
                  touchNode.name == "counterClockWiseButton" || touchNode.name == "clockwiseButton" else {
                      return
                  }
            
            touchNode.fillColor = .green
            
            if touchNode.name == "clockwiseButton" {
                snake!.moveClockwise()
            } else if touchNode.name == "counterClockWiseButton" {
                snake!.moveCounterClockwise()
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchLocation = touch.location(in: self)
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode,
                  touchNode.name == "counterClockWiseButton" || touchNode.name == "clockwiseButton" else {
                      return
                  }
            
            touchNode.fillColor = .gray
            
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
     
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        snake!.move()
    }
    
    private func makePoint() -> CGPoint {
        let randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 5)))
        let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 5)))
        
        return CGPoint(x: randX, y: randY)
    }
    
    func createApple() {
        let apple = Apple(position: makePoint())
        self.addChild(apple)
    }
}


extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodies = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask //6
        let collisonOBject = bodies - CollisionCategories.SnakeHead //6 - 2 = 4
        print("Collision between: \(contact.bodyA.node?.name ?? "unknown") and \(contact.bodyB.node?.name ?? "unknown")")
        
        switch collisonOBject {
            case CollisionCategories.Apple:
                let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
                snake?.addBodyPart()
                apple?.removeFromParent()
                createApple()
            default:
                break
                
        }
        
        if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node {
            if (nodeA.name == SnakePart.SnakeHead.rawValue && nodeB.name == SnakePart.SnakeTail.rawValue) {
                print("SNAKE IS DEAD!!!")
                snake?.die()
            }
        }
        
    }
}

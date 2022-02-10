//
//  SnakeBodyPart.swift
//  snake8lessons
//
//  Created by MICHAIL SHAKHVOROSTOV on 07.02.2022.
//

import UIKit
import SpriteKit

enum SnakePart: String {
    case SnakeHead = "head"
    case SnakeNeck = "neck"
    case SnakeTail = "tail"
}

class SnakeBodyPart: SKShapeNode {
    let ownWidth: Int = 10
    let ownHeight: Int = 10
    // trick to specify the point where a part should be beyond the stage edges
    var collisionPoint: CGPoint?
    
    init(atPoint point: CGPoint, index i: Int) {
        super.init()
        
        
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: ownWidth, height: ownHeight)).cgPath
        
        fillColor = .green
        strokeColor = .green
        lineWidth = 5
        name = (i == 1) ? SnakePart.SnakeNeck.rawValue : SnakePart.SnakeTail.rawValue
        
        self.position = point
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(6), center: CGPoint(x: 5, y: 5))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = CollisionCategories.Snake
        self.physicsBody?.contactTestBitMask = CollisionCategories.StageEdge | CollisionCategories.Apple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

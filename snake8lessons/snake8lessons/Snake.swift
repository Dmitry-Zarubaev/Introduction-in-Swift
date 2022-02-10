//
//  Snake.swift
//  snake8lessons
//
//  Created by MICHAIL SHAKHVOROSTOV on 07.02.2022.
//

import UIKit
import SpriteKit

class Snake: SKShapeNode {
    
    struct Vector {
        let dx: CGFloat
        let dy: CGFloat
        
        init(_ x: CGFloat, _ y: CGFloat) {
            dx = x
            dy = y
        }
    }
    
    enum Direction {
        case Left
        case Right
        case Top
        case Bottom
        
        mutating func clockwise() {
            switch self {
                case .Top:
                    self = .Right
                case .Right:
                    self = .Bottom
                case .Bottom:
                    self = .Left
                case .Left:
                    self = .Top
            }
        }
        
        mutating func conterClockwise() {
            switch self {
                case .Top:
                    self = .Left
                case .Left:
                    self = .Bottom
                case .Bottom:
                    self = .Right
                case .Right:
                    self = .Top
            }
        }
        
        mutating func getDirection() -> String {
            switch self {
                case .Left:
                    return "Left"
                case .Right:
                    return "Right"
                case .Top:
                    return "Top"
                case .Bottom:
                    return "Bottom"
            }
        }
    }

    let moveSpeed: CGFloat = 100.0
    
    var body = [SnakeBodyPart]()
    var direction: Direction = .Top
    
    private(set) var isAlive: Bool = true
    private(set) var stageSize: CGSize
    
    
    init(atPoint point: CGPoint, stage: CGSize) {
        stageSize = stage
        super.init()
        
        let head = SnakeHead(atPoint: point, index: 0)
        body.append(head)
        addChild(head)
        addBodyPart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func die() {
        isAlive = false
        for i in (0..<body.count) {
            let part = body[i]
            part.removeAllActions()
            part.strokeColor = .red
        }
    }
    
    func addBodyPart() {
        guard !body.isEmpty else {return}
        
        let newBodyPart = SnakeBodyPart(atPoint: CGPoint(x: body.last!.position.x, y: body.last!.position.y), index: body.count)
        body.append(newBodyPart)
        addChild(newBodyPart)
    }
    
    func move() {
        if isAlive {
            guard !body.isEmpty else {return}
            
            var destination: CGPoint = moveHead(body[0])
            
            for index in (1..<body.count) {
                destination = moveBodyPart(part: body[index], to: destination)
            }
        }
    }
    
    func getVector() -> Vector {
        switch direction {
            case .Left:
                return Vector(-moveSpeed, 0.0)
            case .Right:
                return Vector(moveSpeed, 0.0)
            case .Top:
                return Vector(0.0, moveSpeed)
            case .Bottom:
                return Vector(0.0, -moveSpeed)
        }
    }
    
    func isEdgeCollision(in point: CGPoint) -> Direction? {
        if point.x >= stageSize.width {
            return .Right
        } else if point.x <= 0.0 {
            return .Left
        } else if point.y >= stageSize.height {
            return .Top
        } else if point.y <= 0.0 {
            return .Bottom
        } else {
            return nil
        }
    }
    
    func getShiftPoint(part: SnakeBodyPart, edge: Direction, at collision: CGPoint) -> CGPoint {
        switch edge {
            case .Left:
                return CGPoint(x: stageSize.width - CGFloat(part.ownWidth), y: collision.y)
            case .Right:
                return CGPoint(x: 0.0, y: collision.y)
            case .Top:
                return CGPoint(x: collision.x, y: 0.0)
            case .Bottom:
                return CGPoint(x: collision.x, y: stageSize.height - CGFloat(part.ownHeight))
        }
    }
    
    func moveHead(_ head: SnakeBodyPart) -> CGPoint {
        let vector = getVector()
        let oldPosition = head.position
        
        var isShifted = false
        let newX = head.position.x + vector.dx
        let newY = head.position.y + vector.dy
        var nextPosition = CGPoint(x: newX, y: newY)
        
        if let edgeCollision = isEdgeCollision(in: oldPosition) {
            isShifted = true
            nextPosition = getShiftPoint(part: head, edge: edgeCollision, at: nextPosition)
        }
        
        if isShifted {
            let moveAction = SKAction.move(to: nextPosition, duration: 0.0)
            head.removeAllActions()
            head.run(moveAction)
        } else {
            let moveAction = SKAction.move(to: nextPosition, duration: 1.0)
            head.run(moveAction)
        }
        
        return oldPosition
    }
    
    func moveBodyPart(part: SnakeBodyPart, to destination: CGPoint) -> CGPoint {
        let commonInterval: TimeInterval = 0.125
        let oldPosition = part.position

        if let mustCollide = part.collisionPoint {
            // should follow to the edge collision
            if let collided = isEdgeCollision(in: oldPosition) {
                // beyond edge
                let shiftPoint = getShiftPoint(part: part, edge: collided, at: mustCollide)
                let moveAction = SKAction.move(to: shiftPoint, duration: 0.0)
                
                part.collisionPoint = nil
                part.removeAllActions()
                part.run(moveAction)
            } else {
                // on the way to the edge
                let moveAction = SKAction.move(to: mustCollide, duration: commonInterval)
                part.run(moveAction)
            }
        } else if let _ = isEdgeCollision(in: destination) {
            // detect a point beyond the edge
            let moveAction = SKAction.move(to: destination, duration: commonInterval)
            part.collisionPoint = destination
            part.run(moveAction)
        } else {
            let moveAction = SKAction.move(to: destination, duration: commonInterval)
            part.run(moveAction)
        }
        
        return oldPosition
    }
    
    func moveClockwise() {
        direction.clockwise()
    }
    
    func moveCounterClockwise() {
        direction.conterClockwise()
    }
    
}

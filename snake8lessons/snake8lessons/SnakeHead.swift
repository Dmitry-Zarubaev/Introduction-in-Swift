//
//  File.swift
//  snake8lessons
//
//  Created by MICHAIL SHAKHVOROSTOV on 07.02.2022.
//

import UIKit

class SnakeHead: SnakeBodyPart {
    override init(atPoint point: CGPoint, index _: Int) {
        super.init(atPoint: point, index: 0)
        
        strokeColor = .blue
        name = SnakePart.SnakeHead.rawValue
        
        self.physicsBody?.categoryBitMask = CollisionCategories.SnakeHead
        self.physicsBody?.contactTestBitMask = CollisionCategories.StageEdge | CollisionCategories.Snake | CollisionCategories.Apple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



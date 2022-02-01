//
//  Lesson_6.swift
//  Introduction in Swift
//
//  Created by Дмитрий Зарубаев on 31.01.2022.
//

import Foundation

class Queue<Entity>: CustomStringConvertible {
    private var entities: [Entity]
    
    private func isInBounds(i index: Int) -> Bool {
        return index >= 0 && index < entities.count
    }
    
    var description: String {
        var result = ""
        for (index, entity) in entities.enumerated() {
            result += "\(entity)"
            result += entities.count - 1 == index ? "" : ", "
        }
        return "<\(result)>"
    }
    
    var length: Int {
        return entities.count
    }
    
    
    
    init() {
        self.entities = []
    }
    
    init(_ entity: Entity) {
        self.entities = [entity]
    }
    
    init(_ entities: [Entity]) {
        self.entities = entities
    }
    
    
    public func enqueue(_ entity: Entity) -> Void {
        entities.append(entity)
    }
    
    public func dequeue() -> Entity? {
        return entities.isEmpty ? nil : entities.removeFirst()
    }
    
    public func map<T>(_ fn: (Entity) -> T) -> Queue<T> {
        return Queue<T>(entities.map(fn))
    }
    
    public func forEach(_ fn: (Entity) -> Void) -> Void {
        entities.forEach(fn)
    }
    
    public func sort(by fn: (Entity, Entity) -> Bool) -> Void {
        entities.sort(by: fn)
    }
    
    
    
    subscript(index: Int) -> Entity? {
        get {
            return isInBounds(i: index) ? entities[index] : nil
        }
        
        set {
            if let value = newValue, isInBounds(i: index) {
                entities[index] = value
            }
        }
    }
}

func handleWithQueue() -> Void {
    print("We are going to handling with custom implementation of the Queue data type")
    
    let queue: Queue<String> = Queue()
    
    let actions: Array<(description: String, task: () -> Void)> = [
        ("1. Enqueue a value", {queue.enqueue(getStringFromUser(message: "Please, enter a value"))}),
        ("2. Dequeue a value", {print(queue.dequeue() ?? "The queue is empty")}),
        ("3. Get the queue length", {print("The length is \(queue.length)")}),
        ("4. Get a value at the index", {print(queue[getIntFromUser(message: "Please, enter the index")] ?? "The index is not existed")}),
        ("5. Get the queue contains", {print(queue)})
    ]
    
    actionsPresentation(welcome: "Please, pick one the following actions below:", stopIs: "stop", actions: actions)
}

let lesson6: Array<(String, () -> Void)> = [
    ("1. All in one (again)", handleWithQueue)
]

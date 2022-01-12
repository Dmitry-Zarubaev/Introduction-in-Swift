//
//  tools.swift
//  Introduction in Swift (Lesson 2)
//
//  Created by Дмитрий Зарубаев on 12.01.2022.
//

import Foundation

func getIntFromUserIf(message: String, condition: (Int) -> Bool) -> Int {
    var number: Int?
    
    repeat {
        print(message)
        if let input = readLine() {
            
            if let inputNumber = Int(input) {
                if condition(inputNumber) {
                    number = inputNumber
                } else {
                    print("This number isn't satisfy the condition!")
                }
            } else {
                print("Not a number!")
            }
        }
    } while (number == nil)
    
    return number!
}

func getIntFromUser(message: String) -> Int {
    getIntFromUserIf(message: message, condition: ({_ in true}))
}

func getDoubleFromUserIf(message: String, condition: (Double) -> Bool) -> Double {
    var number: Double?
    
    repeat {
        print(message)
        if let input = readLine() {
            
            if let inputNumber = Double(input) {
                if condition(inputNumber) {
                    number = inputNumber
                } else {
                    print("This number isn't satisfy the condition!")
                }
            } else {
                print("Not a number!")
            }
        }
    } while (number == nil)
    
    return number!
}

func getDoubleFromUser(message: String) -> Double {
    getDoubleFromUserIf(message: message, condition: ({_ in true}))
}

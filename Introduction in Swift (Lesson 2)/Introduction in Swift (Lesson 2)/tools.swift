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

func homeworkPresentation(message: String, homework: Array<(description: String, task: () -> Void)>) -> Void {
    let stopWord: String = "exit"
    let postfix: String = "Type '\(stopWord)' for exit."
    
    var isContinue: Bool = true
    var fullMessage: String = "\n" + message + "\n"
    
    for work in homework {
        fullMessage += "\t" + work.description + "\n"
    }
    
    fullMessage += postfix + "\n"
    
    repeat {
        print(fullMessage)

        let rawInput: String? = readLine()

        if let input = rawInput {
            if input == stopWord {
                isContinue = false
            } else {
                if let index = Int(input) {
                    if index >= 1 && index <= homework.count {
                        let task = homework[index - 1].task
                        task()
                    } else {
                        print("Wrong task index!")
                    }
                } else {
                    print("Unsupported input")
                }
            }
        } else {
            print("Unsupported input")
        }

    } while isContinue
}

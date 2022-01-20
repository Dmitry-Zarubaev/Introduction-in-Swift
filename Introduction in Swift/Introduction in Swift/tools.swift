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

func getStringFromUserIf(message: String, where condition: (String) -> Bool) -> String {
    var string: String?
    
    repeat {
        print(message)
        
        if let input = readLine() {
            if condition(input) {
                string = input
            } else {
                print("This input isn't satisfy the condition!")
            }
        } else {
            print("Incorrect input!")
        }
    } while (string == nil)
    
    return string!
}

func getOrdinal(number: Int) -> String {
    switch number {
        case 0:
            return "zero"
        case 1:
            return "first"
        case 2:
            return "second"
        case 3:
            return "third"
        case 4:
            return "fourth"
        case 5:
            return "fifth"
        case 6:
            return "sixth"
        case 7:
            return "seventh"
        case 8:
            return "eighth"
        case 9:
            return "ninth"
        case 10:
            return "tenth"
        case 11:
            return "eleventh"
        case 12:
            return "twelfth"
        default:
            return "manyth"
    }
}

func homeworkPresentation(for lesson: Int, homework: Array<(description: String, task: () -> Void)>) -> Void {
    let stopWord: String = "exit"
    let postfix: String = "Type '\(stopWord)' for exit."
    let welcomeMessage: String = "This is the homework program for the \(getOrdinal(number: lesson)) lesson of the course. Please, choose the index of one of the following sub program:"
    
    var isContinue: Bool = true
    var fullMessage: String = "\n" + welcomeMessage + "\n"
    
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

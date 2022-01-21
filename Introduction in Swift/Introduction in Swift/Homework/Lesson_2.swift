//
//  Lesson_2.swift
//  Introduction in Swift
//
//  Created by Дмитрий Зарубаев on 12.01.2022.
//

import Foundation

func isItEvenNumber() -> Void {
    print("We're going to find out whether entered number even or not")
    let number: Int = getIntFromUser(message: "Please, enter a number:")
    
    if number == 0 {
        print("Zero is zero. What did you expect?!")
    } else if number % 2 == 0 {
        print("\(number) is even")
    } else {
        print("\(number) is odd")
    }
}


func isNumberDivideByThree() -> Void {
    print("We're going to find out whether entered number is divided by 3 without a remainder")
    
    let number: Int = getIntFromUser(message: "Please, enter a number:")
    let remainder: Int = number % 3
    
    if number == 0 {
        print("Zero is zero. What did you expect?!")
    } else if remainder == 0 {
        print("\(number) is divided by 3 without remainder")
    } else {
        print("\(number) is divided by 3 with remainder of \(remainder)")
    }
}

func cleanArrayFromEvenNumbers() -> Void {
    print("We're going to create an array of numbers and remove every even number from it")

    let maxLength: Int = 100
    let length: Int = getIntFromUserIf(message: "Please, enter the array length (not bigger than \(maxLength)):", condition: {len in len > 0 && len <= maxLength})

    var array: Array<Int> = []
    for number in 1..<length + 1 {
        array.append(number)
    }
    print("Here is the created array [yes, it starts with 1]:\n\(array)")
    
    array.removeAll(where: {element in element % 2 == 0})
    print("Here is the array without even numbers:\n\(array)")
}

func makeFibonacciSequence() -> Void {
    print("We're going to create an array the Fibonacci sequence of the defined length")
    
    let maxLength: Int = 50
    // starts with 3 because of https://en.wikipedia.org/wiki/Fibonacci_number#Definition |  the recurrence ... is valid for n > 2
    let length: Int = getIntFromUserIf(message: "Please, enter the length of sequence (between 3 and \(maxLength):", condition: {i in i > 2 && i <= maxLength})
    
    if length > 46 {
        // Possibly to prevent Int overflow for 32-bit systems
        var fibonacci: Array<Int64> = [0, 1, 1]
        for index in fibonacci.count..<length + 1 {
            let newNumber: Int64 = fibonacci[index - 1] + fibonacci[index - 2]
            fibonacci.append(newNumber)
        }
        
        print("Here is the Fibonacci sequence up to the defined element[\(length)]:\n\(fibonacci)")
    } else {
        var fibonacci: Array<Int> = [0, 1, 1]
        for index in fibonacci.count..<length + 1 {
            let newNumber: Int = fibonacci[index - 1] + fibonacci[index - 2]
            fibonacci.append(newNumber)
        }
        
        print("Here is the Fibonacci sequence up to the defined element[\(length)]:\n\(fibonacci)")
    }

}

func findPrimeNumbers() -> Void {
    print("We're going to find prime numbers in a sequence of numbers up to the specified number")

    let supremeMaxLength: Int = 1000
    let maxLength: Int = getIntFromUserIf(message: "Please, enter the max number in the sequence (between 2 and \(supremeMaxLength)):", condition: {limit in limit > 2 && limit <= supremeMaxLength})

    let initPrime: Int = 2
    var sequence: Array<Int> = []

    for number in 3..<maxLength + 1 {
        sequence.append(number)
    }

    var isExistsBiggerPrime = true
    var p: Int = initPrime

    while isExistsBiggerPrime {
        for number in stride(from: 2 * p, to: maxLength + 1, by: p) {
            if let index = sequence.firstIndex(of: number) {
                sequence.remove(at: index)
            }
        }

        if let biggerPrime = sequence.firstIndex(where: {$0 > p}) {
            p = sequence[biggerPrime]
        } else {
            isExistsBiggerPrime = false
        }
    }
    
    print("Here is the list of prime numbers [\(sequence.count)] in the given sequence:\n\(sequence)")
}

let lesson2: Array<(String, () -> Void)> = [
    ("1. Check is number even", isItEvenNumber),
    ("2. Check is number is divided by 3", isNumberDivideByThree),
    ("3. Create an array of numbers and clean it from even numbers", cleanArrayFromEvenNumbers),
    ("4. The same as 3", cleanArrayFromEvenNumbers),
    ("5. Make Fibonacci sequence up to the given n", makeFibonacciSequence),
    ("6. Find prime numbers in the set of numbers from 2 to up to the given n", findPrimeNumbers),
]

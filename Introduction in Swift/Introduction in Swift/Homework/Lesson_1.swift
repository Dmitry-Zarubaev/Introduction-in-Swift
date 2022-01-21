//
//  Lesson_1.swift
//  Introduction in Swift
//
//  Created by Дмитрий Зарубаев on 11.01.2022.
//

import Foundation

func solveQuadrationEquation() -> Void {
    print("We're going to solve the quadratic equation of form 'Ax^2 + Bx + C = 0' using the Discriminant")
    
    func makeMessage(_ index: String) -> String {
        return "Please, enter the \(index) number:"
    }
    
    let A: Double = getDoubleFromUserIf(message: "Please, enter the A number which shouldn't be equal to zero:", condition: ({i in i != 0.0}))
    let B: Double = getDoubleFromUser(message: makeMessage("B"))
    let C: Double = getDoubleFromUser(message: makeMessage("C"))
    
    let discriminant = pow(B, 2.0) - 4 * A * C
    print("The Discriminant has value of \(discriminant), [A:\(A), B:\(B), C:\(C)]")
    
    switch discriminant {
        case let d where d > 0:
            let x1: Double = (-B + sqrt(discriminant)) / 2 * A
            let x2: Double = (-B - sqrt(discriminant)) / 2 * A
            print("The equation has the two solution: x1 = \(x1) and x2 = \(x2)")
        case let d where d == 0:
            let x: Double = -B / 2 * A
            print("The equation has the one solution: x = \(x)")
        case let d where d < 0:
            print("The equation hasn't any solution")
        default:
            print("Something went wrong, please, reach the developer")
    }
}

func findRightTriangleParameters() -> (area: Double, perimeter: Double, hypotenuse: Double) {
    let a: Double = getDoubleFromUserIf(message: "Please, enter the a side length (bigger than zero):", condition: ({input in input > 0.0}))
    let b: Double = getDoubleFromUserIf(message: "Please, enter the b side length (bigger than zero):", condition: ({input in input > 0.0}))
    
    let area: Double = (a * b) / 2
    let hypotenuse: Double = sqrt(pow(a, 2.0) + pow(b, 2.0))
    let perimeter: Double = a + b + hypotenuse
    
    return (area, perimeter, hypotenuse)
}

func printRightTriangleParameters() -> Void {
    print("We're going to find out parameters of a right triangle")
    let (area, perimeter, hypotenuse) = findRightTriangleParameters()
    print("The right triangle has the following parameters: [area: \(area), perimeter: \(perimeter), hypotenuse: \(hypotenuse)")
}

func calculateBankAccountProfit() -> Void {
    // https://ru.wikipedia.org/wiki/Банковский_вклад | Вклад с капитализацией процентов
    print("We're going to find out the value of a bank deposit for five years with the given percentage and initial value")
    
    let monthsInYear: Double = 12
    let depositeLifeInYears: Double = 5.0
    
    let initDeposit: Int = getIntFromUserIf(message: "Please, enter the initial deposit value (bigger than zero):", condition: ({value in value > 0}))
    let yearPercentage: Double = getDoubleFromUserIf(message: "Please, enter the year percentage (between zero and one hundred):", condition: ({perc in perc > 0.0 && perc < 100.0}))
    let decimalPercentage: Double = yearPercentage / 100.0
    
    let finalDeposit: Double = Double(initDeposit) * pow(1.0 + decimalPercentage / monthsInYear, monthsInYear * depositeLifeInYears)
    
    print("The things are going in the following way: final deposit is \(finalDeposit) [init: \(initDeposit), percentage: \(yearPercentage)]")
}

let lesson1: Array<(String, () -> Void)> = [
    ("1. Solve a quadratic equation", solveQuadrationEquation),
    ("2. Find out parameters of a right triangle", printRightTriangleParameters),
    ("3. Calculate a bank account profit", calculateBankAccountProfit)
]


//
//  Model.swift
//  Calculator
//
//  Created by Mateusz Sarnowski on 13/05/2020.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import Foundation
 
struct CalculatorLogic {
    
    private var number: Double?
    private var intermediateCalculation: (n1: Double, calcMethod: String)?
    
    mutating func setNumber(_ number: Double ) {
        self.number = number
    }
    
    private func performTwoNumberCalculation(n2: Double) -> Double? {
        if let n1 = intermediateCalculation?.n1, let calcMethod = intermediateCalculation?.calcMethod {
            switch calcMethod {
            case "+":
                return n1 + n2
            case "-":
                return n1 - n2
            case "×":
                return n1 * n2
            case "÷":
                return n1 / n2
            default:
                fatalError("The operation passsed in does not match any of the cases.")
            }
        }
        //in case where for example user pressed "=" before anything else
        return nil
    }
    
    mutating func calculate(symbol: String) -> Double? {
        if let safeNumber = number {
            switch symbol {
            case "AC":
                return 0
            case "+/-":
                return safeNumber * -1
            case "%":
                return safeNumber * 0.01
            case "=":
                return performTwoNumberCalculation(n2: safeNumber)
            default:
                intermediateCalculation = (n1: safeNumber, calcMethod: symbol)
                print("intermediateCalculation done")
            }
        }
        print("returned nil")
        return nil
    }
}

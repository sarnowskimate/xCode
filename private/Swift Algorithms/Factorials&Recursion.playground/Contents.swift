import Cocoa

func factorialOfValue(value: UInt) -> UInt {
    var product: UInt = 1
    
    if value == 0 {
        return 1
    }
    
    for i in 1...value {
        product *= i
    }
    return product
}

factorialOfValue(value: 5)

func recursionOfValue(value: UInt) -> UInt {
    if value == 0 {
        return 1
    }

    return value * recursionOfValue(value: value - 1)
}

recursionOfValue(value: 5)

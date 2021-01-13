import UIKit

func fibForNumSteps(numSteps: Int) -> [Int] {
    if numSteps == 1 {
        return [0]
    }
    
    var sequence = [0, 1]
    
    if numSteps == 2 {
        return sequence
    }
    
    for i in 3...numSteps {
        sequence.append(sequence[i-3] + sequence[i-2])
    }
    
    return sequence
}

fibForNumSteps(numSteps: 5)

func fibRecursionForNumSteps(numSteps: Int, first: Int, second: Int) -> [Int] {
    if numSteps == 0 {
        return []
    }
    
    return [first + second] + fibRecursionForNumSteps(numSteps: numSteps - 1, first: second, second: first + second)
}

[0, 1] + fibRecursionForNumSteps(numSteps: 3, first: 0, second: 1)



import UIKit

let numbers = [1, 2, 3, 4, 3, 3]

//Filter into [3, 3, 3], then filter into [2, 4] - even numbers
var filteredNumbers = [Int]()

for n in numbers {
    if n == 3 {
        filteredNumbers.append(n)
    }
}

filteredNumbers

let filteredNumbers2 = numbers.filter {$0 == 3}
filteredNumbers2


//Transform [1, 2, 3, 4] -> [2, 4, 6, 8]

let numbersArray = [1, 2, 3, 4]
var newArray = [Int]()

for n in numbersArray {
    newArray.append(n * 2)
}

newArray

let transformedArray = [1, 2, 3, 4].map({$0 * 2})

//Sum all elements of an array

let arrayToSum = [1, 2, 3, 4, 5]
var sum = 0

for n in arrayToSum {
    sum += n
}


let sum2 = arrayToSum.reduce(0, {sum2, number in sum2 + number})


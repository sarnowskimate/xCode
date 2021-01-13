import Cocoa

var thousandNumbers = [Int]()

for i in 1...1000 {
    thousandNumbers.append(i)
}

//it's a "n" function
func linearSearchForSearchValue(searchValue: Int, array: [Int]) -> Bool {
    for n in array {
        if n == searchValue {
            return true
        }
    }

    return false
}

linearSearchForSearchValue(searchValue: 33, array: thousandNumbers)

//it's a "log(n)" function
func binarySearchForSearchValue(searchValue: Int, array: [Int]) -> Bool {
    var leftIndex = 0
    var rightIndex = array.count - 1
    
    while leftIndex <= rightIndex {
        let middleIndex = (leftIndex + rightIndex) / 2
        let middleValue = array[middleIndex]
        
        if searchValue == middleValue {
            return true
        }
        
        if searchValue < middleValue {
            rightIndex = middleIndex - 1
        } else {
            leftIndex = middleIndex + 1
        }
    }
    return false
}

binarySearchForSearchValue(searchValue: 7, array: thousandNumbers)

import Cocoa

var oneThousandNumbers = [Int]()

for i in 1...1000 {
    oneThousandNumbers.append(i)
}

for n in oneThousandNumbers {
    if n % 15 == 0 {
        print("\(n) FizzBuzz")
    } else if n % 5 == 0 {
        print("\(n) Buzz")
    } else if n % 3 == 0 {
        print("\(n) Fizz")
    } else {
        print(n)
    }
}


import Cocoa

//if there are the same amount of different names, the function return 1st name of that names
let nameArray = ["Mateusz", "Monika", "Błażej", "Kasia", "Jerzy", "Mateusz", "Błażej"]

func mostCommonNameinArray(array: [String]) -> String {
    var nameCountDictionary = [String: Int]()
    
    for name in array {
        if let count = nameCountDictionary[name] {
            nameCountDictionary[name] = count + 1
        } else {
            nameCountDictionary[name] = 1
        }
    }
    
    var mostCommonName = ""
    
    for key in nameCountDictionary.keys {
        if mostCommonName == "" {
            mostCommonName = key
        } else {
            if let count = nameCountDictionary[key], let currentMaxCount = nameCountDictionary[mostCommonName] {
                if count > currentMaxCount  {
                    mostCommonName = key
                }
            }
        }
    }
    
    return mostCommonName
}

mostCommonNameinArray(array: nameArray)

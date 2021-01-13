 import Cocoa

 var sampleSentence = "This is a sample sentence"
 
 func reverseEveryOtherWordInSentence(sentence: String) -> String {
    let allWords = sentence.components(separatedBy: " ")
    reversedWord
    
    var newSentence = ""
    
    for word in allWords {
        if newSentence != "" {
            newSentence += " "
        }
        let reversedWord = word.map(<#T##transform: (Character) throws -> T##(Character) throws -> T#>)
        map { String($0.reversed()) }
        
        newSentence += reversedWord
    }
    return newSentence
 }
 
 reverseEveryOtherWordInSentence(sentence: sampleSentence)

 

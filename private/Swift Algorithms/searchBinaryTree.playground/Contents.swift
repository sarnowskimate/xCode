import UIKit

//1.
//
//       10
//      /  \
//     5    14
//    /    /  \
//   1    11   20

//2.
class Node {
    let value: Int
    let leftChildren: Node?
    let rightChildren: Node?
    
    init(value: Int, leftChildren: Node?, rightChildren: Node?) {
        self.value = value
        self.leftChildren = leftChildren
        self.rightChildren = rightChildren
    }
}

let oneNode = Node(value: 1, leftChildren: nil, rightChildren: nil)
let elevenNode = Node(value: 11, leftChildren: nil, rightChildren: nil)
let twentyNode = Node(value: 20, leftChildren: nil, rightChildren: nil)

let fiveNode = Node(value: 5, leftChildren: oneNode, rightChildren: nil)
let fourteenNode = Node(value: 14, leftChildren: elevenNode, rightChildren: twentyNode)

let rootTenNode = Node(value: 10, leftChildren: fiveNode, rightChildren: fourteenNode)



//3. Interviewer's question: Implement a search algorithm that searches through this tree for a particular value
func search(node: Node?, searchValue: Int) -> Bool {
    if node == nil {
        return false
    }
    
    if node?.value == searchValue {
        return true
        
    } else {
        return search(node: node?.leftChildren, searchValue: searchValue) || search(node: node?.rightChildren, searchValue: searchValue)
    }
}

search(node: rootTenNode, searchValue: 10)


//4. What is the point of all this?

let list = [1, 5, 10, 11, 14, 20]
let index = list.firstIndex(where: {$0 == 5})

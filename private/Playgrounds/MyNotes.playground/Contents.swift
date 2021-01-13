import UIKit
import ARKit

var str = "My notes"

//MARK: - Defaults - to finish

let defaults = UserDefaults.standard
var itemArray = ["an item", "another item", "and so on"]

override func viewDidLoad() {
    super.viewDidLoad()
    
    if let items = defaults.array(forKey: "NameOfAnArraOfItems") as? [String] {
        itemArray = items
    }
}

let alert = UIAlertController(title: "Title", message: "", preferredStyle: .alert)

let action = UIAlertAction(title: "Add item", style: .default) { (action) in
    //adding item from textField
    self.itemArray.append(textField.text!)
    self.defaults.set(self.itemArray, forKey: "TodoListArray")
    
    //reloads data
    self.tableView.reloadData()
    
}

alert.addAction(action)

//MARK: - Another chapter


//MARK: - in override func viewDidLoad() {
//import ARKit

//Options for drawing overlay content to aid debugging of AR tracking in a SceneKit view -> Display a point cloud showing intermediate results of the scene analysis that ARKit uses to track device position.
sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

//utworzenie prostopadłościanu z opcją zaokrąglenia rogów (j. [m])
let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)



//MARK: - Float

// pi number
Float.pi


//MARK: - Graphic knowledge

// .png lets the graphic being transparent, e.g. a horizontal grid as a material of a plane


//MARK: - Array

// checking if an array is empty
.isEmpty

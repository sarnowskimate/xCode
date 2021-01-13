import UIKit

var width: Float = 1.5
var height: Float = 2.3
var oneBucketOfPaint: Float = 1.5

var bucketOfPaint: Int {
    get {
        return Int(ceilf(width * height / oneBucketOfPaint))
    }
    set {
        let area = Float(newValue) * oneBucketOfPaint
        print(area)
    }
}



bucketOfPaint = 5

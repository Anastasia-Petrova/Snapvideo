import Foundation
import XCTest


func assertEqual(_ image1: UIImage, _ image2: UIImage, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(image1.pngData(), image2.pngData(), file: file, line: line)
}

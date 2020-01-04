import Foundation
import CoreImage

protocol Filter {
    var name: String { get }
    func apply(image: CIImage) -> CIImage
}

import Foundation
import CoreImage

struct PassthroughFilter: Filter {
    let name: String = "Original"
    
    func apply(image: CIImage) -> CIImage {
        return image
    }
}

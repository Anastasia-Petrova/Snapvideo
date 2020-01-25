import Foundation
import CoreImage

struct HalfToneFilter: Filter {
    let name: String = "HalfTone"
    
    func apply(image: CIImage) -> CIImage {
        let optionalFilter = CIFilter(name: "CICMYKHalftone")
        guard let filter = optionalFilter else {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(25, forKey: kCIInputWidthKey)
        return filter.outputImage ?? image
    }
}

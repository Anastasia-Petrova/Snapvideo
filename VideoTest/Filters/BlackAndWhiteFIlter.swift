import Foundation
import CoreImage

struct BlackAndWhiteFilter: Filter {
    let name: String = "BlackAndWhite"
    
    func apply(image: CIImage) -> CIImage {
        let optionalFilter = CIFilter(name: "CIColorMonochrome")
        guard let filter = optionalFilter else {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        filter.setValue(1.0, forKey: "inputIntensity")
        return filter.outputImage ?? image
    }
}

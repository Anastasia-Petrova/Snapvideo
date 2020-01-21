import Foundation
import CoreImage

struct ColorInvertFilter: Filter {
    let name: String = "ColorInvert"
    
    func apply(image: CIImage) -> CIImage {
        let optionalFilter = CIFilter(name: "CIColorInvert")
        guard let filter = optionalFilter else {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
//        filter.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
//        filter.setValue(1.0, forKey: "inputIntensity")
        return filter.outputImage ?? image
    }
}

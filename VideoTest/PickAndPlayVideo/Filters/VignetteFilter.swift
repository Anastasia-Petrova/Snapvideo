import Foundation
import CoreImage

struct VignetteFilter: Filter {
    let name: String = "Vignette"
    
    func apply(image: CIImage) -> CIImage {
        let optionalFilter = CIFilter(name: "CIVignette",
                                      parameters: [
                                        "inputImage":  image,
                                        "inputRadius" : 0.5,
                                        "inputIntensity" : 2.0
        ])
        guard let filter = optionalFilter else {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        
        return filter.outputImage ?? image
    }
}

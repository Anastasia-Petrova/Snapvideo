import Foundation
import CoreImage

struct BlurFilter: Filter {
    let name: String = "Blur"
    
    let blurRadius: Double
    
    init(blurRadius: Double) {
        self.blurRadius = blurRadius
    }
    
    func apply(image: CIImage) -> CIImage {
        return image.clampedToExtent().applyingGaussianBlur(sigma: blurRadius).cropped(to: image.extent)
    }
}

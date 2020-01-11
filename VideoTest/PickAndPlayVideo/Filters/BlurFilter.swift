import Foundation
import CoreImage

struct BlurFilter: Filter {
    let name: String = "Blur"
    let blurRadius: Double
    
    func apply(image: CIImage) -> CIImage {
        return image.clampedToExtent().applyingGaussianBlur(sigma: blurRadius).cropped(to: image.extent)
    }
}

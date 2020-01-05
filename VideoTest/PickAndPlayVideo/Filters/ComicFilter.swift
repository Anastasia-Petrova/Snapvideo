import Foundation
import CoreImage


struct ComicFilter: Filter {
    let name: String = "ComicFilter"
    
    func apply(image: CIImage) -> CIImage {
        let optionalFilter = CIFilter(name: "CIComicEffect")
        guard let filter = optionalFilter else {
            return image
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        return filter.outputImage ?? image
    }
}

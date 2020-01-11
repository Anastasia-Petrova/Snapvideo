import Foundation
import CoreImage

struct OldFilmFilter: Filter {
    let name: String = "OldFilm"
    
    func apply(image: CIImage) -> CIImage {
        return creareOldMovieFilter(image: image)
    }
    
    func creareOldMovieFilter(image: CIImage) -> CIImage {
        let sepiaFilter = CIFilter(
            name:"CISepiaTone",
            parameters: [
                kCIInputImageKey: image,
                kCIInputIntensityKey: 1.0
            ]
        )
        guard let filter = sepiaFilter,
            let sepiaCIImage = filter.outputImage else {
            return image
        }
        guard
            let coloredNoise = CIFilter(name:"CIRandomGenerator"),
            let noiseImage = coloredNoise.outputImage
            else {
                return image
        }
        let whitenVector = CIVector(x: 0, y: 1, z: 0, w: 0)
        let fineGrain = CIVector(x:0, y:0.005, z:0, w:0)
        let zeroVector = CIVector(x: 0, y: 0, z: 0, w: 0)
        guard
            let whiteningFilter = CIFilter(name:"CIColorMatrix",
                                           parameters:
            [
                kCIInputImageKey: noiseImage,
                "inputRVector": whitenVector,
                "inputGVector": whitenVector,
                "inputBVector": whitenVector,
                "inputAVector": fineGrain,
                "inputBiasVector": zeroVector
            ]),
            let whiteSpecks = whiteningFilter.outputImage
            else {
                return image
        }
        
        guard
            let speckCompositor = CIFilter(name:"CISourceOverCompositing",
                                           parameters:
            [
                kCIInputImageKey: whiteSpecks,
                kCIInputBackgroundImageKey: sepiaCIImage
            ]),
            let speckledImage = speckCompositor.outputImage
            else {
                return image
        }
        
        let verticalScale = CGAffineTransform(scaleX: 1.5, y: 25)
        let transformedNoise = noiseImage.transformed(by: verticalScale)
        let darkenVector = CIVector(x: 4, y: 0, z: 0, w: 0)
        let darkenBias = CIVector(x: 0, y: 1, z: 1, w: 1)
                
        guard
            let darkeningFilter = CIFilter(name:"CIColorMatrix",
                                           parameters:
            [
                kCIInputImageKey: transformedNoise,
                "inputRVector": darkenVector,
                "inputGVector": zeroVector,
                "inputBVector": zeroVector,
                "inputAVector": zeroVector,
                "inputBiasVector": darkenBias
            ]),
            let randomScratches = darkeningFilter.outputImage
            else {
                return image
        }
        
        guard
            let grayscaleFilter = CIFilter(name:"CIMinimumComponent",
                                           parameters:
            [
                kCIInputImageKey: randomScratches
            ]),
            let darkScratches = grayscaleFilter.outputImage
            else {
                return image
        }
        guard
            let oldFilmCompositor = CIFilter(name:"CIMultiplyCompositing",
                                             parameters:
            [
                kCIInputImageKey: darkScratches,
                kCIInputBackgroundImageKey: speckledImage
            ]),
            let oldFilmImage = oldFilmCompositor.outputImage
            else {
                return image
        }
        
        let finalImage = oldFilmImage.cropped(to: image.extent)
        return finalImage
    }
}


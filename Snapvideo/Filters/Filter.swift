import Foundation
import CoreImage

protocol Filter: Equatable {
    var name: String { get }
    
    func apply(image: CIImage) -> CIImage
}

struct AnyFilter: Equatable {
    let apply: (CIImage) -> CIImage
    let name: String
    
    init<F: Filter>(_ filter: F) {
        apply = filter.apply
        name = filter.name
    }
    
    static func == (lhs: AnyFilter, rhs: AnyFilter) -> Bool {
        lhs.name == rhs.name
    }
}

struct CompositeFilter: Filter {
    var name: String {
        filter1.name + " + " + filter2.name
    }
    let filter1: AnyFilter
    let filter2: AnyFilter
    
    init(filter1: AnyFilter, filter2: AnyFilter) {
        self.filter1 = filter1
        self.filter2 = filter2
    }
    
    func apply(image: CIImage) -> CIImage {
        let filteredImage = filter1.apply(image)
        return filter2.apply(filteredImage)
    }
}

func + (filter1: AnyFilter, filter2: AnyFilter) -> AnyFilter {
    AnyFilter(CompositeFilter(filter1: filter1, filter2: filter2))
}

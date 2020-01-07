import Foundation

struct App {
    let filters: [Filter]
    
    public static let shared = `default`
}

extension App {
    private static let `default` = App(
        filters: [
            PassthroughFilter(),
            ComicFilter(),
            BlurFilter(blurRadius: 50),
            OldFilmFilter(),
            SharpAndWarmFilter(inputSharpness: 0.7),
            VignetteFilter()
        ]
    )
    
    private static let variant1 = App(
        filters: [
            PassthroughFilter(),
            BlurFilter(blurRadius: 20)
        ]
    )
    
    private static let variant2 = App(
        filters: [
            PassthroughFilter(),
            ComicFilter()
        ]
    )
}

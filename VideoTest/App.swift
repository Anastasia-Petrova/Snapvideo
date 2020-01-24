import Foundation

struct App {
    let filters: [AnyFilter]
    
    public static let shared = `default`
}

extension App {
    private static let `default` = App(
        filters: [
            AnyFilter(PassthroughFilter()),
            AnyFilter(SharpAndWarmFilter(inputSharpness: 0.7)),
            AnyFilter(VignetteFilter()),
            AnyFilter(SepiaFilter()),
            AnyFilter(VintageFilter()),
            AnyFilter(ClampFilter()),
            AnyFilter(RetroFilter()),
            AnyFilter(ProcessFilter()),
            AnyFilter(ComicFilter()),
            AnyFilter(ColorInvertFilter()),
            AnyFilter(HalfToneFilter()),
            AnyFilter(BlurFilter(blurRadius: 30)),
            AnyFilter(TonalFilter()),
            AnyFilter(MonoFilter()),
            AnyFilter(MonochromeFilter()),
            AnyFilter(NoirFilter())
        ]
    )
    
    private static let many = App(
        filters: [
            AnyFilter(PassthroughFilter()),
            AnyFilter(ComicFilter()),
            AnyFilter(BlurFilter(blurRadius: 50)),
            AnyFilter(OldFilmFilter()),
            AnyFilter(SharpAndWarmFilter(inputSharpness: 0.7)),
            AnyFilter(VignetteFilter()),
            AnyFilter(ComicFilter()),
            AnyFilter(BlurFilter(blurRadius: 50)),
            AnyFilter(OldFilmFilter()),
            AnyFilter(SharpAndWarmFilter(inputSharpness: 0.7)),
            AnyFilter(VignetteFilter()),
            AnyFilter(ComicFilter()),
            AnyFilter(BlurFilter(blurRadius: 50)),
            AnyFilter(OldFilmFilter()),
            AnyFilter(SharpAndWarmFilter(inputSharpness: 0.7)),
            AnyFilter(VignetteFilter()),
            AnyFilter(ComicFilter()),
            AnyFilter(BlurFilter(blurRadius: 50)),
            AnyFilter(OldFilmFilter()),
            AnyFilter(SharpAndWarmFilter(inputSharpness: 0.7)),
            AnyFilter(VignetteFilter()),
            AnyFilter(ClampFilter())
        ]
    )
    
    private static let variant2 = App(
        filters: [
            AnyFilter(PassthroughFilter()),
            AnyFilter(ComicFilter())
        ]
    )
    
    private static let composite = App(
        filters: [
            AnyFilter(PassthroughFilter()),
            AnyFilter(OldFilmFilter()) + AnyFilter(VignetteFilter()),
            AnyFilter(BlurFilter(blurRadius: 20)) + AnyFilter(SharpAndWarmFilter(inputSharpness: 0.7)),
            AnyFilter(ClampFilter()) + AnyFilter(VignetteFilter()),
            AnyFilter(ComicFilter()) + AnyFilter(VignetteFilter()),
        ]
    )
    
    private static let slowFilter = App(
        filters: [
            AnyFilter(PassthroughFilter()),
            AnyFilter(ClampFilter()) +
            AnyFilter(VignetteFilter()) +
            AnyFilter(SharpAndWarmFilter(inputSharpness: 0.7)) +
            AnyFilter(ClampFilter()) +
            AnyFilter(VignetteFilter()) +
            AnyFilter(SharpAndWarmFilter(inputSharpness: 0.7)) +
            AnyFilter(ClampFilter()) +
            AnyFilter(VignetteFilter()) +
            AnyFilter(SharpAndWarmFilter(inputSharpness: 0.7)) +
            AnyFilter(ClampFilter()) +
            AnyFilter(VignetteFilter()) +
            AnyFilter(SharpAndWarmFilter(inputSharpness: 0.7))
        ]
    )
     
}

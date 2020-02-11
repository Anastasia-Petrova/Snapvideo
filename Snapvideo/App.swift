//
//  App.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation

struct App {
    let filters: [AnyFilter]
    let tools: [AnyTool]
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
        ],
        tools: [
            AnyTool(FadeTool()),
            AnyTool(BrightTool()),
            AnyTool(SpeedUpTool()),
            AnyTool(CutTool()),
            AnyTool(SlowDownTool()),
            AnyTool(CropTool()),
            AnyTool(TuneColorTool()),
            AnyTool(VignetteTool()),
            AnyTool(SaturationTool()),
            AnyTool(ShadowsTool()),
            AnyTool(ContrastTool()),
            AnyTool(HighlightsTool()),
            AnyTool(SharpenTool()),
            AnyTool(TiltShiftTool()),
            AnyTool(WarmthTool())
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
        ],
        tools: [AnyTool(BrightTool())]
    )
    
    private static let variant2 = App(
        filters: [
            AnyFilter(PassthroughFilter()),
            AnyFilter(ComicFilter())
        ],
        tools: [AnyTool(BrightTool())]
    )
    
    private static let composite = App(
        filters: [
            AnyFilter(PassthroughFilter()),
            AnyFilter(OldFilmFilter()) + AnyFilter(VignetteFilter()),
            AnyFilter(BlurFilter(blurRadius: 20)) + AnyFilter(SharpAndWarmFilter(inputSharpness: 0.7)),
            AnyFilter(ClampFilter()) + AnyFilter(VignetteFilter()),
            AnyFilter(ComicFilter()) + AnyFilter(VignetteFilter()),
        ],
        tools: [AnyTool(BrightTool())]
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
        ],
        tools: [AnyTool(BrightTool())]
    )
}

extension App {
    static let snapshotTests = App(
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
        ],
        tools: [AnyTool(BrightTool())]
    )
    
    static let unitTests = App(
        filters: [
            AnyFilter(PassthroughFilter()),
            AnyFilter(SharpAndWarmFilter(inputSharpness: 0.7)),
            AnyFilter(VignetteFilter()),
        ],
        tools: [AnyTool(BrightTool())]
    )
}


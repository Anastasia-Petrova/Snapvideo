//
//  App.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 02/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation

struct App {
    let filters: [Filter]
    let tools: Array<ToolEnum>
    public static let shared = `default`
}

extension App {
    private static let `default` = App(
        filters: [
            PassthroughFilter(),
            SharpAndWarmFilter(inputSharpness: 0.7),
            VignetteFilter(),
            SepiaFilter(),
            VintageFilter(),
            ClampFilter(),
            RetroFilter(),
            ProcessFilter(),
            ComicFilter(),
            ColorInvertFilter(),
            HalfToneFilter(),
            BlurFilter(blurRadius: 30),
            TonalFilter(),
            MonoFilter(),
            MonochromeFilter(),
            NoirFilter()
        ],
      tools: [
        .vignette(tool: VignetteTool()),
        .colourCorrection(tool: ColourCorrectionTool()),
        .sharpenTool(tool: SharpenTool()),
        .exposureTool(tool: ExposureTool())
      ]
    )
    
    private static let many = App(
        filters: [
            PassthroughFilter(),
            ComicFilter(),
            BlurFilter(blurRadius: 50),
            OldFilmFilter(),
            SharpAndWarmFilter(inputSharpness: 0.7),
            VignetteFilter(),
            ComicFilter(),
            BlurFilter(blurRadius: 50),
            OldFilmFilter(),
            SharpAndWarmFilter(inputSharpness: 0.7),
            VignetteFilter(),
            ComicFilter(),
            BlurFilter(blurRadius: 50),
            OldFilmFilter(),
            SharpAndWarmFilter(inputSharpness: 0.7),
            VignetteFilter(),
            ComicFilter(),
            BlurFilter(blurRadius: 50),
            OldFilmFilter(),
            SharpAndWarmFilter(inputSharpness: 0.7),
            VignetteFilter(),
            ClampFilter()
        ],
        tools: [.vignette(tool: VignetteTool())]
    )
    
    private static let variant2 = App(
        filters: [
            PassthroughFilter(),
            ComicFilter()
        ],
        tools: [.vignette(tool: VignetteTool())]
    )
    
    private static let composite = App(
        filters: [
            PassthroughFilter(),
            OldFilmFilter() + VignetteFilter(),
            BlurFilter(blurRadius: 20) + SharpAndWarmFilter(inputSharpness: 0.7),
            ClampFilter() + VignetteFilter(),
            ComicFilter() + VignetteFilter()
        ],
        tools: [.vignette(tool: VignetteTool())]
    )
    
    private static let slowFilter = App(
        filters: [
            PassthroughFilter(),
            ClampFilter() +
            VignetteFilter() +
            SharpAndWarmFilter(inputSharpness: 0.7) +
            ClampFilter() +
            VignetteFilter() +
            SharpAndWarmFilter(inputSharpness: 0.7) +
            ClampFilter() +
            VignetteFilter() +
            SharpAndWarmFilter(inputSharpness: 0.7) +
            ClampFilter() +
            VignetteFilter() +
            SharpAndWarmFilter(inputSharpness: 0.7)
        ],
        tools: [.vignette(tool: VignetteTool())]
    )
}

extension App {
    static let snapshotTests = App(
        filters: [
            PassthroughFilter(),
            SharpAndWarmFilter(inputSharpness: 0.7),
            VignetteFilter(),
            SepiaFilter(),
            VintageFilter(),
            ClampFilter(),
            RetroFilter(),
            ProcessFilter(),
            ComicFilter(),
            ColorInvertFilter(),
            HalfToneFilter(),
            BlurFilter(blurRadius: 30),
            TonalFilter(),
            MonoFilter(),
            MonochromeFilter(),
            NoirFilter()
        ],
        tools: [.vignette(tool: VignetteTool())]
    )
    
    static let unitTests = App(
        filters: [
            PassthroughFilter(),
            SharpAndWarmFilter(inputSharpness: 0.7),
            VignetteFilter()
        ],
        tools: [.vignette(tool: VignetteTool())]
    )
}


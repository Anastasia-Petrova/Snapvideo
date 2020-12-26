//
//  Parameterized.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 12/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import Foundation

protocol Parameterized {
    associatedtype Parameter: CustomStringConvertible
    associatedtype Value: CustomStringConvertible
    
    var allParameters: [Parameter] { get }
    
    func value(for parameter: Parameter) -> Value
    
    func minValue(for parameter: Parameter) -> Value
    
    func maxValue(for parameter: Parameter) -> Value
    
    mutating func setValue(value: Value, for parameter: Parameter)
}

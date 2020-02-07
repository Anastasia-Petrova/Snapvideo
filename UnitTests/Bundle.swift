import Foundation

extension Bundle {
    static let unitTests = Bundle(for: Fake.self)
}

private class Fake {}

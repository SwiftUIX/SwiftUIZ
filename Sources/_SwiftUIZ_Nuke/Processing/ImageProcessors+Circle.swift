// The MIT License (MIT)
//
// Copyright (c) 2015-2024 Alexander Grebenyuk (github.com/kean).

import Foundation

#if !os(macOS)
import UIKit
#else
import AppKit
#endif

extension ImageProcessors {

    /// Rounds the corners of an image into a circle. If the image is not a square,
    /// crops it to a square first.
    public struct Circle: ImageProcessing, Hashable, CustomStringConvertible {
        private let border: ImageProcessingOptions.Border?

        /// - parameter border: `nil` by default.
        public init(border: ImageProcessingOptions.Border? = nil) {
            self.border = border
        }

        public func process(_ image: PlatformImage) -> PlatformImage? {
            image.processed.byDrawingInCircle(border: border)
        }

        public var identifier: String {
            let suffix = border.map { "?border=\($0)" }
            return "com.github.kean/nuke/circle" + (suffix ?? "")
        }

        public var description: String {
            "Circle(border: \(border?.description ?? "nil"))"
        }
    }
}

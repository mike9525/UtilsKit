//
//  ImageProtocol.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 05/07/2025.
//

public protocol ImageProtocol: Sendable { }

#if canImport(Foundation)
import Foundation
extension URL: ImageProtocol { }
extension String: ImageProtocol { }
extension Data: ImageProtocol { }
#endif

#if canImport(SwiftUI)
import SwiftUI
extension Image: ImageProtocol { }

@available(iOS 17.0, watchOS 10.0, *)
extension ImageResource: ImageProtocol { }
#endif

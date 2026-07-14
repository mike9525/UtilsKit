//
//  URL+Image.swift
//  Trivel
//
//  Created by Michael Coqueret on 04/02/2025.
//  Copyright © 2025 Trivel. All rights reserved.
//

#if canImport(UIKit)
import Foundation
import UIKit

@available(watchOS, unavailable)
extension URL {
	
	/// Asynchronously downloads the image at this URL, optionally resizes it to fit within a maximum dimension,
	/// and returns JPEG-encoded data with the specified compression quality.
	///
	/// The download bypasses URL cache (using `.reloadIgnoringLocalCacheData`). If the image cannot be fetched
	/// or decoded, the function returns `nil`.
	///
	/// - Parameters:
	///   - compressionQuality: The JPEG compression quality in the range `0.0...1.0` where `1.0` produces the
	///     highest quality and largest file size. Default is `1`.
	///   - maxDimension: An optional maximum dimension (in points) for the longest image side. If provided and the
	///     image exceeds this size, it will be proportionally downscaled so that its longest side equals `maxDimension`.
	///     Pass `nil` to skip resizing. Default is `nil`.
	/// - Returns: JPEG-encoded image data, or `nil` if the image could not be downloaded or decoded.
	/// - Note: This method is `async` and `nonisolated`. It performs network I/O using `URLSession` and image processing
	///   off the main actor.
	nonisolated public func getImage(compressionQuality: CGFloat = 1, maxDimension: CGFloat? = nil) async -> Data? {
		await withCheckedContinuation { (continuation: CheckedContinuation<Data?, Never>) in
			Task {
				guard var image = try? await self.toImage() else {
					return continuation.resume(returning: nil)
				}
				
				if let maxDimension {
					image = image.resized(maxDimension: maxDimension)
				}
				let imageData = image.jpegData(compressionQuality: compressionQuality)
				continuation.resume(returning: imageData)
			}
		}
	}
	
	nonisolated private func toImage() async throws -> UIImage? {
		var request = URLRequest(url: self)
		request.cachePolicy = .reloadIgnoringLocalCacheData
		let (data, _) = try await URLSession.shared.data(for: request)
		return UIImage(data: data)
	}
}

@available(watchOS, unavailable)
private extension UIImage {
	
	func resized(maxDimension: CGFloat) -> UIImage {
		let width = self.size.width
		let height = self.size.height
		let maxSide = max(width, height)
		
		guard maxSide > maxDimension else { return self }
		let scale = maxDimension / maxSide
		let newSize = CGSize(width: width * scale, height: height * scale)
		
		let format = UIGraphicsImageRendererFormat.default()
		format.scale = 1
		
		let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
		
		return renderer.image { _ in
			self.draw(in: CGRect(origin: .zero, size: newSize))
		}
	}
}

#endif

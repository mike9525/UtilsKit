//
//  Date+Add.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 26/06/2026.
//

import Foundation

extension Date {
	
	/// Returns a new `Date` by adding the specified calendar component value to the current date.
	///
	/// Uses `Calendar.current` to perform the calculation. Falls back to the original date
	/// if the resulting date cannot be computed.
	///
	/// - Parameters:
	///   - component: The calendar component to add (e.g. `.day`, `.month`, `.year`, `.hour`).
	///   - value: The amount to add to the specified component. Use a negative value to subtract.
	/// - Returns: A new `Date` offset by the given component and value, or `self` if the operation fails.
	///
	/// - Example:
	/// ```swift
	/// let tomorrow = Date().adding(.day, value: 1)
	/// let lastMonth = Date().adding(.month, value: -1)
	/// ```
	public func adding(_ component: Calendar.Component, value: Int) -> Date {
		Calendar.current.date(byAdding: component, value: value, to: self) ?? self
	}
}

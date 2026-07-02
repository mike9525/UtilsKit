//
//  Date+Tomorrow.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 05/07/2025.
//

import Foundation

extension Date {
	
	// Static property to get the start of tomorrow's day
	public static var tomorrow: Date {
		Self.now.adding(.day, value: 1).getStartOfDay()
	}
	
	// Method to check if the provided date is tomorrow
	public func isTomorrow(date: Date) -> Bool {
		self.isSame(date: date.adding(.day, value: 1), components: [.day, .month, .year])
	}
}

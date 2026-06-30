//
//  Sequence+RemoveDuplicates.swift
//  
//
//  Created by Michael Coqueret on 03/01/2020.
//

import Foundation

public extension Sequence where Element: Hashable {
	
	/// Return array without duplicate
	func removeDuplicates() -> [Element] {
		var set = Set<Element>()
		return self.filter { set.insert($0).inserted }
	}
}

public extension Sequence {
	
	/// Retourne les éléments de la séquence en supprimant les doublons selon une clé.
	///
	/// Seule la première occurrence de chaque clé est conservée ; l'ordre d'apparition
	/// d'origine est préservé. Le filtrage utilise un `Set`, soit une complexité en O(n).
	///
	/// ```swift
	/// let unique = clients.removeDuplicates(by: \.id)
	/// ```
	///
	/// - Parameter keyPath: Le `KeyPath` vers la propriété `Hashable` servant à
	///   identifier les doublons.
	/// - Returns: Un tableau ne contenant que la première occurrence de chaque clé.
	func removeDuplicates<Key: Hashable>(by keyPath: KeyPath<Element, Key>) -> [Element] {
		var seen = Set<Key>()
		var results: [Element] = []
		
		for item in self where seen.insert(item[keyPath: keyPath]).inserted {
			results.append(item)
		}
		
		return results
	}
}

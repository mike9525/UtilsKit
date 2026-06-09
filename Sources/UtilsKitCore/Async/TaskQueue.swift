//
//  TaskQueue.swift
//  UtilsKit
//
//  Created by Michael Coqueret on 06/07/2025.
//

public actor TaskQueue {
	
	private var task: Task<Void, any Error>?
	
	public init() { }
	
	/// Cancel task
	public func cancel() {
		self.task?.cancel()
	}
	
	/// Wait for the current task to complete, if any
	public func wait() async {
		guard let task, !task.isCancelled else { return }
		_ = try? await task.value
	}
	
	/// Execute the given block as a new task, if any
	public func fire(_ block: @Sendable @escaping () async throws -> Void) async throws {
		if let task, !task.isCancelled {
			try await task.value
		} else {
			let currentTask = Task {
				try await block()
			}
			
			self.task = currentTask
			
			do {
				try await _ = currentTask.value
				currentTask.cancel()
			} catch {
				currentTask.cancel()
				throw error
			}
		}
	}
	
	/// Wait for the current task to complete and then execute the given block as a new task
	public func waitAndFire(_ block: @Sendable @escaping () async throws -> Void) async throws {
		if let task, !task.isCancelled {
			let currentTask = Task {
				try? await task.value
				try await block()
			}
			
			self.task = currentTask
			do {
				try await _ = currentTask.value
				currentTask.cancel()
			} catch {
				currentTask.cancel()
				throw error
			}
		} else {
			try await self.fire(block)
		}
	}
}

//
//  Reachability.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 11/08/24.
//

import Network
import UIKit

class ReachabilityManager {
    static let shared = ReachabilityManager()

    private let monitor = NWPathMonitor()
    private var isMonitoring = false

    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    func startMonitoring() {
        guard !isMonitoring else { return }

        monitor.start(queue: DispatchQueue.global(qos: .background))
        isMonitoring = true

        monitor.pathUpdateHandler = { [weak self] path in
            // We can write our logic to update add/remove error view dynamically
        }
    }

    func stopMonitoring() {
        guard isMonitoring else { return }

        monitor.cancel()
        isMonitoring = false
    }

    deinit {
        stopMonitoring()
    }
}

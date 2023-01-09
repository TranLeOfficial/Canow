//
//  ConnectionManager.swift
//  Canow
//
//  Created by TuanBM6 on 10/15/21.
//

import Foundation
import Reachability

class ConnectionManager: NSObject {
    
    // Create a singleton instance
    static let shared = ConnectionManager()
    
    private var reachability: Reachability!
    var connectInternet: () -> Void = { }
    var disconnectInternet: () -> Void = { }
    private (set) var isConnect: Bool = true {
        didSet {
            if !self.isConnect {
                CommonManager.hideLoading()
                CommonManager.showNoNetworkToast()
            }
        }
    }
    
    override init() {
        super.init()
        // Initialise reachability
        do {
            self.reachability = try Reachability()
        } catch {
            return
        }
        
        self.configNetwork()
        
        do {
            // Start the network status notifier
            try self.reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    private func configNetwork() {
        self.reachability.whenReachable = { _ in
            self.isConnect = true
            self.connectInternet()
        }
        
        self.reachability.whenUnreachable = { _ in
            self.isConnect = false
            self.disconnectInternet()
        }
    }
    
}

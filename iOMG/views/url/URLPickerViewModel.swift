//
//  URLPickerViewModel.swift
//  iOMG
//
//  Created by Tacenda on 5/26/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import SwiftUI

class URLPickerViewModel {
    var customURL: String = ""
    let reload: (() -> Void)?
    let reloadExplorer: (() -> Void)?
    
    init(reload: (() -> Void)?, reloadExplorer: (() -> Void)?) {
        self.reload = reload
        self.reloadExplorer = reloadExplorer
    }
    
    func switchToMainNet() {
        switch URLService.currentEnv() {
        case .mainNet: break
        default:
            URLService.save(env: .mainNet)
            PersistentContainer.clear()
            updateApp()
        }
    }
    
    func switchToTestNet() {
        switch URLService.currentEnv() {
        case .testNet: break
        default:
            URLService.save(env: .testNet)
            PersistentContainer.clear()
            updateApp()
        }
    }
    
    func saveCustomURL() {
        
    }
    
    private func updateApp() {
        reload?()
        reloadExplorer?()
    }
}

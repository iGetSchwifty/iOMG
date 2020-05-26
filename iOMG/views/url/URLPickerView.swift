//
//  URLPickerView.swift
//  iOMG
//
//  Created by Tacenda on 5/24/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import SwiftUI

struct URLPickerView: View {
    let viewModel: URLPickerViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        // TODO: use for custom URL textField
//        let binding = Binding<String>(get: {
//            self.viewModel.customURL
//        }, set: {
//            self.viewModel.customURL = $0
//        })
        return VStack(spacing: 50) {
            Text("Current Network: \(currentNet())").font(.title)
            Text("***NOTE***").font(.title)
            Text("This removes the local DB and downloads all of the blocks again. Switch env as you need but dont switch just for fun or else its just unneeded band width getting wasted since this app pages the entire blockchain to store it locally").font(.system(size: 12)).padding()
            
            Button(action: {
                self.viewModel.switchToMainNet()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Mainnet")
            }
            
            Button(action: {
                self.viewModel.switchToTestNet()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Testnet")
            }

            //TODO: Fix custom
            Text("Custom URL coming soon")
//            HStack {
//                TextField("Custom URL", text: binding)
//                .padding()
//                .cornerRadius(10)
//                .border(Color.gray.opacity(0.5), width: 0.5)
//
//                Button(action: {
//                    self.viewModel.saveCustomURL()
//                }) {
//                    Text("Save")
//                }
//            }
        }
    }
    
    private func currentNet() -> String {
        switch URLService.currentEnv() {
        case .testNet:
            return "Testnet"
        case .mainNet:
            return "Mainnet"
        case .customURL(_):
            return "Unknown"
        }
    }
}

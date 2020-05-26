//
//  URLPickerView.swift
//  iOMG
//
//  Created by Tacenda on 5/24/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import SwiftUI

struct URLPickerView: View {
    let viewModel = URLPickerViewModel()
    
    var body: some View {
        VStack {
            Button(action: {
                self.viewModel.switchToMainNet()
            }) {
                Text("Mainnet")
            }
            
            Button(action: {
                self.viewModel.switchToTestNet()
            }) {
                Text("Testnet")
            }

            HStack {
                TextField("Custom URL", text: viewModel.$customURL)
                .padding()
                .cornerRadius(10)
                .border(Color.gray.opacity(0.5), width: 0.5)
                
                Button(action: {
                    self.viewModel.saveCustomURL()
                }) {
                    Text("Save")
                }
            }
        }
    }
}

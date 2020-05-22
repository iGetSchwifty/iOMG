//
//  PriceView.swift
//  iOMG
//
//  Created by Tacenda on 5/22/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import SwiftUI

struct PriceView: View {
    @ObservedObject var viewModel = PriceViewModel()
    @State var rotation = 0.0
    @State var isSpinning = false
    var body: some View {
        VStack {
            Image("omisego")
                .resizable()
                .scaledToFill()
                .frame(width: 144, height: 144)
                .padding()
                .rotationEffect(.degrees(rotation))
                .animation(.easeInOut)
                .onTapGesture {
                    self.viewModel.reloadPrice()
                    self.rotation = 180.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.rotation = 360.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.rotation = 0.0
                        }
                    }
                }
            
            Text(viewModel.omgPrice)
                .font(.system(size: 42))
            
            Spacer()
        }
    }
}

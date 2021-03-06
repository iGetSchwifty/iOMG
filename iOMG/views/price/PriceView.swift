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
            Text("OMG Network").font(.title).foregroundColor(.blue).multilineTextAlignment(.center)
            
            VStack {
                Text("Tap to reload price").font(.system(size: 10))
                
                Image("omisego")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 88, height: 88)
                    .rotationEffect(.degrees(rotation))
                    .animation(.easeInOut)
            }
            .onTapGesture {
                self.spinLogo()
            }
            
            Text(viewModel.omgPrice)
                .font(.system(size: 42))
        }.onAppear {
            self.spinLogo()
        }
    }
    
    private func spinLogo() {
        viewModel.reloadPrice()
        rotation = 180.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.rotation = 360.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.rotation = 0.0
            }
        }
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        PriceView()
    }
}

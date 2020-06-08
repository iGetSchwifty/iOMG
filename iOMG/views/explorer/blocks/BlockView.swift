//
//  BlockView.swift
//  iOMG
//
//  Created by Tacenda on 5/25/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import SwiftUI
import BigInt

struct BlockOverlay: View {

    let blknum: UInt64
    let ethHeight: BigUInt
    let txCount: UInt64
    
    /// body
    var body: some View {
        ZStack(alignment: .center) {
            
            Rectangle()
                .fill()
                .foregroundColor(Color.black)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 4)
                )
            
            VStack(alignment: .center) {
                Text("Block: \(blknum)")
                    .font(.headline).bold()
                
                Text("ETH Height: \(ethHeight.description)")
                    .font(.footnote).bold()

                Spacer()

                Text("TX Count: \(txCount)")
                    .font(.subheadline).bold()
            }.padding()
        }
        .foregroundColor(.white)
    }
}

struct BlockView: View {
    let viewModel: BlockViewModel
    var body: some View {
        Rectangle()
            .frame(height: 142)
            .border(Color.gray.opacity(0.5), width: 0.5)
            .cornerRadius(8)
            .overlay(BlockOverlay(blknum: viewModel.blknum,
                                  ethHeight: viewModel.ethHeight,
                                  txCount: viewModel.txCount))
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(viewModel: BlockViewModel(blknum: 42, ethHeight: 42, txCount: 42))
    }
}

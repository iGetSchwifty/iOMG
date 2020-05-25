//
//  BlockView.swift
//  iOMG
//
//  Created by Tacenda on 5/25/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import SwiftUI

struct BlockOverlay: View {

    let blknum: Int64
    let ethHeight: Int64
    let txCount: Int64
    
    /// body
    var body: some View {
        ZStack(alignment: .center) {
            
            Rectangle()
                .fill()
                .foregroundColor(Color.black)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 4)
                )
            
            VStack(alignment: .center) {
                Text("Block: \(blknum)")
                    .font(.headline).bold()
                
                Text("ETH Height: \(ethHeight)")
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
    let blknum: Int64
    let ethHeight: Int64
    let txCount: Int64

    var body: some View {
        
        Rectangle()
            .frame(height: 142)
            .border(Color.gray.opacity(0.5), width: 0.5)
            .cornerRadius(8)
            .overlay(BlockOverlay(blknum: blknum,
                                  ethHeight: ethHeight,
                                  txCount: txCount))
    }
}

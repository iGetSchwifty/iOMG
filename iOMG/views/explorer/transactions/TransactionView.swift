//
//  TransactionView.swift
//  iOMG
//
//  Created by Tacenda on 5/25/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import Combine
import SwiftUI

struct TransactionView: View {
    @ObservedObject var viewModel: TransactionViewModel
    
    var body: some View {
        VStack {
            if viewModel.transactions.count == 0 {
                Text("Loading transactions...")
            } else {
                List {
                    ForEach(viewModel.transactions, id: \.blknum){ tx in
//                        NavigationLink(destination: TransactionView(viewModel: TransactionViewModel(blknum: block.blknum, ethHeight: block.ethHeight, txCount: block.txCount))) {
//                            BlockView(viewModel: BlockViewModel(blknum: block.blknum,
//                                                                ethHeight: block.ethHeight,
//                                                                txCount: block.txCount))
//                        }
                        Text("HEff")
                    }
                }
            }
        }
        .navigationBarTitle("Block: \(viewModel.blknum)")
        .onAppear {
            self.viewModel.onAppear()
        }
    }
}

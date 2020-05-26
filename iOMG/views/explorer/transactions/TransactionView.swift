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
                    ForEach(viewModel.transactions, id: \.txhash){ (tx: TransactionData) in
//                        NavigationLink(destination: TransactionView(viewModel: TransactionViewModel(blknum: block.blknum, ethHeight: block.ethHeight, txCount: block.txCount))) {
//                            BlockView(viewModel: BlockViewModel(blknum: block.blknum,
//                                                                ethHeight: block.ethHeight,
//                                                                txCount: block.txCount))
//                        }
                        VStack {
                            Text(tx.txhash ?? "Error getting Tx Hash").font(.footnote).padding()
                            HStack {
                                Text("Inputs: \(tx.inputs?.count ?? 0)").font(.system(size: 10)).padding()
                                
                                Spacer()
                                
                                Text("Outputs: \(tx.outputs?.count ?? 0)").font(.system(size: 10)).padding()
                            }
                        }
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

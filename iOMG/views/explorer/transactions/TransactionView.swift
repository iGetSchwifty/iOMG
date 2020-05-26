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
                        // TODO: Since we saved Inputs & outputs in CoreData. We should make these clickable to show more details. However, going to stop it for now so I can get a testflight out asap
                        
                        VStack {
                            Text(tx.txhash ?? "Error getting Tx Hash").font(.footnote).padding()
                            HStack {
                                Text("Inputs: \(tx.inputs?.count ?? 0)").font(.system(size: 10)).padding()
                                if tx.inputs?.count == 0 {
                                    Text("FEE").bold().foregroundColor(.green)
                                } else {
                                    Spacer()
                                }
                                
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

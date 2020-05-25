//
//  TransactionView.swift
//  iOMG
//
//  Created by Tacenda on 5/25/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import SwiftUI

struct TransactionView: View {
    @State static var currentBlockToLookAt: Int64 = 0
    let viewModel: TransactionViewModel
    
    @FetchRequest(entity: TransactionData.entity(),
                  sortDescriptors: [NSSortDescriptor(key: #keyPath(TransactionData.txindex), ascending: false)],
                  predicate: NSPredicate(format: "%K = %ld", #keyPath(TransactionData.blknum), TransactionView.currentBlockToLookAt)
    )
    var blocks: FetchedResults<Block>
    var body: some View {
        VStack {
            Text("Hello from transaction view")
        }
        .navigationBarTitle("\(viewModel.blknum)")
        .onAppear {
            TransactionView.currentBlockToLookAt = self.viewModel.blknum
            self.viewModel.onAppear()
        }
    }
}

//
//  ExplorerView.swift
//  iOMG
//
//  Created by Tacenda on 5/22/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

// Look into creating this view with https://github.com/apptekstudios/ASCollectionView
//
//  Without putting too much effort into it I am unable to make a Horizontal scroll view.
//  everything I am finding on the internet uses a ScrollView with a HStack and a ForEach.. using Coredata
//  this loads painfully slow. However, It can be done with a List element and a ForEach very easily without
//  bogging down the UI. My guess is since the scroll view needs to calculate the scroll which means it needs
//  all the views rendered... not sure why it doesnt work horizontally but if someone can fix this I would
//  gladly love to scroll sideways for this screen. Or I could use that nifty ASCollectionView and see if it
//  gets around this problem while dealing with large datasets from CoreData
//
import SwiftUI

struct ExplorerView: View {
    
    @State private var searchText = ""

    //   TODO: SINCE I CHANGE to store the UInt as a string in coredata for simplicity. I messed up the sort order
    //  FIX IT HERE by creating a viewModel and doing all this stuff async to not block the view...
    @FetchRequest(entity: Block.entity(),
                  sortDescriptors: [NSSortDescriptor(key: #keyPath(Block.blknum), ascending: false)]
    )
    var blocks: FetchedResults<Block>
    
    var body: some View {
        VStack {
            if blocks.first != nil {
                TextField("Search by block number",text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                // Could throw up a loading indicator when searching.. Not sure how since we are doing a filter...
                
                List {
                    ForEach(blocks.filter{($0.blknum?.hasPrefix(searchText) ?? false) || searchText == ""}, id: \.blknum){ (entity: Block) in
                        NavigationLink(destination:
                            TransactionView(viewModel: TransactionViewModel(blknum: UInt64(entity.blknum ?? "") ?? 0,
                                                                            ethHeight: UInt64(entity.ethHeight ?? "") ?? 0,
                                                                            txCount: UInt64(entity.txCount ?? "") ?? 0))
                        ) {
                                                                                
                            BlockView(viewModel: BlockViewModel(blknum: UInt64(entity.blknum ?? "") ?? 0,
                                                                ethHeight: UInt64(entity.ethHeight ?? "") ?? 0,
                                                                txCount: UInt64(entity.txCount ?? "") ?? 0))
                        }
                    }
                }
            } else {
                Text("Loading blocks...")
            }
        }
        .resignKeyboardOnDragGesture()
        .navigationBarTitle("Explorer", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

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
import Combine
import BigInt

struct ExplorerView: View {
    @State var searchText = ""
    @State var showCancelButton: Bool = false
    @ObservedObject var viewModel = ExplorerViewModel()

    //   TODO: SINCE I CHANGE to store the UInt as a string in coredata for simplicity. I messed up the sort order
    //  FIX IT HERE by creating a viewModel and doing all this stuff async to not block the view...
//    @FetchRequest(entity: Block.entity(),
//                  sortDescriptors: [NSSortDescriptor(key: #keyPath(Block.blknum), ascending: false)]
//    )
//    var blocks: FetchedResults<Block>
    
    var body: some View {
        return VStack {
//            HStack {
//                TextField("Search by block number", text: $viewModel.searchText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//
//                Button(action: {
//                    self.viewModel.updateBlocks()
//                }) {
//                    Text("Search")
//                }
//            }
            if viewModel.blocks.first != nil {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")

                        TextField("search", text: $searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }).foregroundColor(.primary)

                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(self.searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)

                    if showCancelButton  {
                        Button("Cancel") {
                            UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                            self.searchText = ""
                            self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(self.showCancelButton)
                // Could throw up a loading indicator when searching.. Not sure how since we are doing a filter...
                List {
                    ForEach(viewModel.blocks.filter{($0.blknum?.hasPrefix(searchText) ?? false) || searchText == ""}, id: \.blknum) { (entity: Block) in
                        NavigationLink(destination:
                            TransactionView(viewModel: TransactionViewModel(blknum: UInt64(entity.blknum ?? "") ?? 0,
                                                                            ethHeight: BigUInt(entity.ethHeight ?? "") ?? 0,
                                                                            txCount: UInt64(entity.txCount ?? "") ?? 0))
                        ) {

                            BlockView(viewModel: BlockViewModel(blknum: UInt64(entity.blknum ?? "") ?? 0,
                                                                ethHeight: BigUInt(entity.ethHeight ?? "") ?? 0,
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

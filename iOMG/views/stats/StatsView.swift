//
//  NetworkStatsView.swift
//  iOMG
//
//  Created by Tacenda on 5/22/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: StatsViewModel
    
    var body: some View {
        VStack {
            if viewModel.currentStats == nil {
                Text("Loading network stats...")
                Spacer()
            } else {
                if viewModel.currentFeeInfo != nil {
                    if viewModel.currentFeeInfo != nil {
                        Text(viewModel.currentFeeInfo ?? "Unknown fee amount currently").font(.subheadline).padding()
                    }
                }
                VStack {
                    Text("Average Block Interval").font(.title)
                    HStack {
                        VStack {
                            Text("All Time").font(.headline)
                            Text("\(Int(viewModel.currentStats!.data.blockInterval.allTime ?? 0)) (s)")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("Last 24 Hours").font(.headline)
                            Text("\(Int(viewModel.currentStats!.data.blockInterval.lastTwentyFour ?? 0)) (s)")
                                .font(.subheadline)
                        }
                    }
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                VStack {
                    Text("Block Count").font(.title)
                    HStack {
                        VStack {
                            Text("All Time").font(.headline)
                            Text("\(Int(viewModel.currentStats!.data.blockCount.allTime ?? 0))")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("Last 24 Hours").font(.headline)
                            Text("\(Int(viewModel.currentStats!.data.blockCount.lastTwentyFour ?? 0))")
                                .font(.subheadline)
                        }
                    }
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                VStack {
                    Text("Transaction Count").font(.title)
                    HStack {
                        VStack {
                            Text("All Time").font(.headline)
                            Text("\(Int(viewModel.currentStats!.data.transactionCount.allTime ?? 0))")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("Last 24 Hours").font(.headline)
                            Text("\(Int(viewModel.currentStats!.data.transactionCount.lastTwentyFour ?? 0))")
                                .font(.subheadline)
                        }
                    }
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text("Version: \(viewModel.currentStats!.version)")
                        .font(.footnote)
                    
                    NavigationLink(destination: URLPickerView(viewModel: URLPickerViewModel(reload: self.viewModel.reload,
                                                                                            reloadExplorer: self.viewModel.reloadExplorer))) {
                        HStack {
                            Image(systemName: "square.stack.3d.down.dottedline")
                            Text("Change")
                        }
                    }
                }.padding()
            }
        }.onAppear {
            self.viewModel.reload()
        }
    }
}

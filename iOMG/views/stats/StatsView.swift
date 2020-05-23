//
//  NetworkStatsView.swift
//  iOMG
//
//  Created by Tacenda on 5/22/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel = StatsViewModel()
    var body: some View {
        VStack {
            if viewModel.currentStats == nil {
                Text("Loading network stats...")
                Spacer()
            } else {
                if viewModel.currentFeeInfo != nil {
                    if viewModel.currentFeeInfo!.amount != nil && viewModel.currentFeeInfo!.subunitValue != nil {
                        Text("Current ETH Fee: \(Double(viewModel.currentFeeInfo!.amount!) / Double(viewModel.currentFeeInfo!.subunitValue!))").font(.subheadline).padding()
                    }
                }
                VStack {
                    Text("Average Block Interval").font(.title)
                    HStack {
                        VStack {
                            Text("All Time").font(.headline)
                            Text("\(Int(viewModel.currentStats!.data.blockInterval.allTime)) (s)")
                                .font(.subheadline)
                        }.padding()
                        
                        Spacer()
                        
                        VStack {
                            Text("Last 24 Hours").font(.headline)
                            Text("\(Int(viewModel.currentStats!.data.blockInterval.lastTwentyFour)) (s)")
                                .font(.subheadline)
                        }.padding()
                    }
                }
                
                VStack {
                    Text("Block Count").font(.title)
                    HStack {
                        VStack {
                            Text("All Time").font(.headline)
                            Text("\(Int(viewModel.currentStats!.data.blockCount.allTime))")
                                .font(.subheadline)
                        }.padding()
                        
                        Spacer()
                        
                        VStack {
                            Text("Last 24 Hours").font(.headline)
                            Text("\(Int(viewModel.currentStats!.data.blockCount.lastTwentyFour))")
                                .font(.subheadline)
                        }.padding()
                    }
                }
                
                VStack {
                    Text("Transaction Count").font(.title)
                    HStack {
                        VStack {
                            Text("All Time").font(.headline)
                            Text("\(Int(viewModel.currentStats!.data.transactionCount.allTime))")
                                .font(.subheadline)
                        }.padding()
                        
                        Spacer()
                        
                        VStack {
                            Text("Last 24 Hours").font(.headline)
                            Text("\(Int(viewModel.currentStats!.data.transactionCount.lastTwentyFour))")
                                .font(.subheadline)
                        }.padding()
                    }
                }
                
                Spacer()
                
                Text("Version: \(viewModel.currentStats!.version)")
                    .font(.footnote)
                    .padding()
            }
        }.onAppear {
            self.viewModel.reload()
        }
    }
}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
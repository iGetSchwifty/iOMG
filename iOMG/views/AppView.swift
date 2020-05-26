//
//  ContentView.swift
//  iOMG
//
//  Created by Tacenda on 5/20/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    let reloadExplorer: (() -> Void)?
    var body: some View {
        ScrollView {
            VStack {
                PriceView()
                        
                Spacer()
                        
                StatsView(viewModel: StatsViewModel(reloadExplorer: reloadExplorer))
            }.frame(minWidth: 0, maxWidth: .infinity,
                    minHeight: 0, maxHeight: .infinity,
                    alignment: .center)
        }
        .navigationBarTitle("OMG Network", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct AppView: View {
    private let viewModel = AppViewModel()
    var body: some View {
        TabView() {
            NavigationView {
                HomeView(reloadExplorer: viewModel.reloadExplorer)
            }.tabItem {
                Image(systemName: "rhombus")
                Text("Home")
            }.tag(1)
                
            NavigationView {
                ExplorerView()
            }.tabItem {
                Image(systemName: "rectangle.expand.vertical")
                Text("Explorer")
            }.tag(2)
            
            //TODO:
//            AccountView()
//                .tabItem {
//                    Image(systemName: "person")
//                    Text("Account")
//                }.tag(3)
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}

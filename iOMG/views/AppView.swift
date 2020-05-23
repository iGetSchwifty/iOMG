//
//  ContentView.swift
//  iOMG
//
//  Created by Tacenda on 5/20/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView() {
            VStack {
                PriceView()
                
                Spacer()
                
                StatsView()
            }.tabItem {
                Image(systemName: "rhombus")
                Text("Home")
            }.tag(1)
            
            AccountView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }.tag(2)
            
            ExplorerView()
                .tabItem {
                    Image(systemName: "rectangle.expand.vertical")
                    Text("Explorer")
                }.tag(3)
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}

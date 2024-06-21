//
//  MainContentScreen.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import SwiftUI

struct MainContentScreen: View {
   
   @StateObject private var tabRouter = TabRouter()
   
   var body: some View {
      TabView(selection: $tabRouter.selectedRoute) {
         HomeView()
            .tabItem {
               Label(
                  title: { Text(TabRoute.home.title) },
                  icon: { Image(systemName: tabImage(for: .home)) }
               )
            }
            .tag(TabRoute.home)
         
         Text("Search")
            .tabItem {
               Label(
                  title: { Text(TabRoute.search.title) },
                  icon: { Image(systemName: tabImage(for: .search)) }
               )
            }
            .tag(TabRoute.search)
         
         Text("Account")
            .tabItem {
               Label(
                  title: { Text(TabRoute.account.title) },
                  icon: { Image(systemName: tabImage(for: .account)) }
               )
            }
            .tag(TabRoute.account)
      }
      .navigationBarBackButtonHidden()
   }
}

private extension MainContentScreen {
   
   func tabImage(for tab: TabRoute) -> String {
      tabRouter.selectedRoute == tab ? tab.selectedImageResource : tab.imageResource
   }
   
}

#Preview {
   MainContentScreen()
}

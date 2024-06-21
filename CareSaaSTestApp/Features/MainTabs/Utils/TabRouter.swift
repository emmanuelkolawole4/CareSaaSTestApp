//
//  TabRouter.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/17/24.
//

import Foundation

enum TabRoute: Int {
   
   case home, search, account
   
   var title: String {
      switch self {
      case .home:
         return "Home"
      case .search:
         return "Search"
      case .account:
         return "Account"
      }
   }
   
   var imageResource: String {
      switch self {
      case .home:
         return "house"
      case .search:
         return "magnifyingglass"
      case .account:
         return "person"
      }
   }
   
   var selectedImageResource: String {
      switch self {
      case .home:
         return "house.fill"
      case .search:
         return "magnifyingglass.circle.fill"
      case .account:
         return "person.fill"
      }
   }
   
}

final class TabRouter: ObservableObject {
   
   @Published var selectedRoute: TabRoute = .home
   
   func navigate(to route: TabRoute) { self.selectedRoute = route }
   
}

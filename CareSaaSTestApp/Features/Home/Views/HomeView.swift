//
//  HomeView.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/17/24.
//

import SwiftUI

struct HomeView: View {
   
   @Namespace var animation
   @StateObject private var viewModel: HomeViewViewModelImpl
   
   init() {
      let vm = HomeViewViewModelImpl(preferenceStore: PreferenceStore())
      _viewModel = StateObject(wrappedValue: vm)
   }
   
   var body: some View {
      VStack {
         topView
         actionButtonsView
         contentSwitcher
         content
         Spacer()
      }
      .padding()
      .task {
         viewModel.performGetServiceUserTasks()
      }
   }
   
}

private extension HomeView {
   
   var topView: some View {
      HStack {
         welcomeView
         Spacer()
         notificationView
      }
   }
   
   var welcomeView: some View {
      VStack(alignment: .leading) {
         HStack {
            Text("Hi George!")
               .font(.system(size: 18, weight: .semibold))
               .foregroundStyle(Color.primaryTextColor)

            Text("Clocked In")
               .font(.system(size: 13, weight: .semibold))
               .foregroundStyle(Color.accentColor)
               .visible(viewModel.clockedIn)
         }
         
         Text(viewModel.clockedIn ? "You can now begin your task" : "Clock-in to begin your task")
            .font(.system(size: 14, weight: .regular))
            .foregroundStyle(Color.secondaryTextColor)
      }
   }
   
   var notificationView: some View {
      Image(systemName: "bell")
         .resizable()
         .frame(width: 16, height: 16)
         .padding(10)
         .overlay(
            Circle()
               .fill(Color.appRedColor)
               .frame(width: 5, height: 5)
               .offset(x: 8, y: -9)
         )
         .background(
            RoundedRectangle(cornerRadius: 6)
               .stroke(Color.secondaryTextColor, lineWidth: 0.3)
         )
   }
   
   var actionButtonsView: some View {
      HStack {
         if !viewModel.clockedIn {
            Button {
               withAnimation {
                  viewModel.toggleClockIn()
               }
            } label: {
               Text("Clock-in")
                  .font(.system(size: 14, weight: .bold))
                  .padding(.vertical, 8)
                  .foregroundStyle(.white)
                  .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 5))
         } else {
            Button {
               
            } label: {
               Text("Take a Break")
                  .font(.system(size: 14, weight: .bold))
                  .padding(.vertical, 8)
                  .foregroundStyle(.white)
                  .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .background(Color.appYellowColor, in: RoundedRectangle(cornerRadius: 5))
            
            Button {
               withAnimation {
                  viewModel.toggleClockIn()
               }
            } label: {
               Text("Clock-out")
                  .font(.system(size: 14, weight: .bold))
                  .padding(.vertical, 8)
                  .foregroundStyle(.white)
                  .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .background(Color.appRedColor, in: RoundedRectangle(cornerRadius: 5))
         }
      }
      .padding(.vertical)
   }
   
   var contentSwitcher: some View {
      HStack(spacing: 0) {
         ForEach(TaskContent.allCases, id: \.self) { content in
            contentSwitcherButton(content: content)
         }
      }
      .padding(.vertical)
   }
   
   var content: some View {
      ScrollView(.vertical) {
         if viewModel.serviceUserTasks.isNotEmpty {
            ForEach(viewModel.serviceUserTasks, id: \.taskId) { task in
               MedicationEntryView(task: task)
                  .padding(.bottom)
            }
         } else {
            Text("You currently have no assigned tasks.")
               .font(.system(size: 30, weight: .semibold))
               .multilineTextAlignment(.center)
         }
      }
      .refreshable {
         viewModel.performGetServiceUserTasks()
      }
   }
   
   func contentSwitcherButton(content: TaskContent) -> some View {
      Button {
         withAnimation {
            viewModel.selectedContent = content
         }
      } label: {
         VStack {
            Text(content.rawValue)
               .font(.system(size: 16, weight: .semibold))
               .foregroundStyle(viewModel.selectedContent == content ? Color.accentColor : Color.secondaryTextColor)
            
            Divider()
               .frame(height: 2)
               .background(viewModel.selectedContent == content ? Color.accentColor : Color.primaryButtonColor.opacity(0.3))
         }
      }
   }
}

#Preview {
    HomeView()
}

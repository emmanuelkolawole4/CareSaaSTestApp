//
//  MedicationEntryView.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/18/24.
//

import SwiftUI

struct MedicationEntryView: View {
   
   var task: ServiceUserTask
   
    var body: some View {
       VStack(alignment: .leading, spacing: 16) {
          HStack {
             Text(task.taskGroup.orEmpty.capitalized(with: .current))
                .font(.system(size: 18, weight: .semibold))
             
             Spacer()
             
             Image(systemName: "arrow.forward.circle")
                .rotationEffect(task.priority == "Low" ? Angle(degrees: -30):  Angle(degrees: 30))
          }
          
          HStack {
             Label(
               title: { Text("James") },
               icon: { Image(systemName: "person") }
             )
             Spacer()
          }
          
          HStack(spacing: 20) {
             Label(
               title: { Text("Rm 3A") },
               icon: { Image(systemName: "door.left.hand.open") }
             )
             
             Label(
               title: { Text("Bed 45") },
               icon: { Image(systemName: "bed.double") }
             )
             
             Spacer()
             
             Label(
               title: { Text(task.hourOfDay.orEmpty) },
               icon: { Image(systemName: "clock") }
             )
          }
       }
       .foregroundStyle(Color.primaryTextColor)
       .font(.system(size: 16))
       .padding()
       .background(Color.primaryButtonColor.opacity(0.15), in: RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
   MedicationEntryView(
      task: ServiceUserTask.init(
         taskId: nil,
         taskType: nil,
         timeOfDay: nil,
         taskGroup: "Communication",
         priority: "Low",
         taskDetailRef: nil,
         hourOfDay: "06:00AM",
         supportPersonnel: nil,
         taskScheduleId: nil,
         taskAssignments: nil,
         noSupportPersonnel: nil,
         userId: nil,
         isAssigned: nil
      )
   )
}

import SwiftUI

struct ScheduledListView: View {
    @EnvironmentObject var viewModel: SessionViewModel


    var body: some View {
      
        ZStack{
            Color(red:225/255, green:239/255, blue:252/255)
            .ignoresSafeArea()
            VStack {
                if viewModel.scheduledSessions.isEmpty {
                    Text("No scheduled sessions yet.")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(viewModel.scheduledSessions) { session in
                            Text("\(formattedHour(session.hour)) on \(formattedDate(session.date))")
                        }
                        .onDelete(perform: viewModel.deleteSession)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)

                }
            }
            .navigationTitle("Scheduled Sessions")
        }
     
    
            }


    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }

    func formattedHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: Date())!
        return formatter.string(from: date)
    }
}

//Color(red:225/255, green:239/255, blue:252/255)
  //  .ignoresSafeArea()


import SwiftUI

struct ScheduledListView: View {
    @EnvironmentObject var viewModel: SessionViewModel

    var body: some View {
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
            }
        }
        .navigationTitle("Scheduled Sessions")
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



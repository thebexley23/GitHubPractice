import SwiftUI

struct CalendarView: View {
    
    @State private var selectedDate = Date()
    @State private var path = NavigationPath()
    
    @StateObject private var viewModel = SessionViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                HStack {
                    Text("Schedule LockIn Session")
                        .font(.title)
                        .fontWeight(.semibold)
                    Spacer()
                }
                Spacer()
                DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
                
                Button("Create Session") {
                    path.append(selectedDate)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Scheduled Sessions") {
                    path.append("scheduledList")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                Spacer()
                Spacer()
            }
            .padding()
            .background(Color(red: 153/255, green: 224/255, blue: 168/255))
            .navigationTitle("Home")
            .navigationBarHidden(true)
            .navigationDestination(for: Date.self) { date in
                ScheduleView(date: date)
                    .environmentObject(viewModel)
            }
            .navigationDestination(for: String.self) { value in
                if value == "scheduledList" {
                    ScheduledListView()
                        .environmentObject(viewModel)
                }
            }
        }
    }
}


#Preview {
    CalendarView()
}


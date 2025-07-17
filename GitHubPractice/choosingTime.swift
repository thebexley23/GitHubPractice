import SwiftUI
//edit
struct ScheduledSession: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let hour: Int
}

struct ScheduleView: View {
    let date: Date
    let hours = Array(0..<24)

    @State private var selectedHour: Int? = nil
    @State private var showPopup = false
    @EnvironmentObject var viewModel: SessionViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Selected Date:")
                    .font(.headline)

                Text(formattedDate(date))
                    .font(.title2)
                    .fontWeight(.medium)
                
// where we are changing the display of the time
                Text("Time Chosen: \(selectedHour.map { formattedHour($0) } ?? "None")")
                    .font(.headline)
                    .padding(.top)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(hours, id: \.self) { hour in
                            Button(action: {
                                selectedHour = hour                            }) {
                                Text(formattedHour(hour))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }

                if let hour = selectedHour {
                    VStack(spacing: 10) {
                        Button("Add to Schedule") {
                            viewModel.addSession(date: date, hour: hour)
                            selectedHour = nil
                            showConfirmationPopup()
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .background(Color(red:225/255, green:239/255, blue:252/255))
            .navigationTitle("")

            // Popup overlay
            if showPopup {
                VStack {
                    Spacer()
                    Text("Added to schedule")
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 50)
                }
                .animation(.easeInOut, value: showPopup)
            }
        }
    }

    // MARK: - Popup Trigger
    private func showConfirmationPopup() {
        withAnimation {
            showPopup = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showPopup = false
            }
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



#Preview {
    NavigationStack {
        ScheduleView(date: Date())
    }
}


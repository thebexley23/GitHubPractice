import SwiftUI

struct ContentView: View {
    
    @State private var tasks: [String] = []
    @State private var newTask: String = ""
    @State private var isDarkMode: Bool = true  // Toggle state for dark/light mode
    
    var body: some View {
        ZStack {
            // Background color based on toggle
            (isDarkMode ? Color.black : Color.white)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Text("To-Do List")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(isDarkMode ? .white : .black)
                    
                    Spacer()
                    
                    // Toggle to switch themes
                    Toggle(isOn: $isDarkMode) {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(isDarkMode ? .yellow : .orange)
                    }
                    .labelsHidden()
                }
                
                HStack {
                    TextField("Enter new task", text: $newTask)
                        .padding()
                        .background(isDarkMode ? Color.white : Color(.systemGray6))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    
                    Button(action: {
                        if !newTask.trimmingCharacters(in: .whitespaces).isEmpty {
                            tasks.append(newTask)
                            newTask = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.green)
                    }
                }
                
                List {
                    ForEach(tasks, id: \.self) { task in
                        Text(task)
                            .foregroundColor(isDarkMode ? .white : .black)
                            .listRowBackground(isDarkMode ? Color.black : Color.white)
                    }
                    .onDelete(perform: deleteTask)
                }
                .listStyle(PlainListStyle())
            }
            .padding()
        }
    }
    
    // Delete task function
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}





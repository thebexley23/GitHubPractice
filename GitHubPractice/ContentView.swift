import SwiftUI



struct ContentView: View {

    @State private var tasks: [String] = []

    @State private var newTask: String = ""



    var body: some View {

        ZStack {

            Color.black

                .ignoresSafeArea()

            

            VStack(alignment: .leading, spacing: 20) {

                HStack {

                    Text("To-Do List")

                        .font(.system(size: 40, weight: .bold))

                        .foregroundColor(.white)

                    Spacer()

                }



                HStack {

                HStack {
                    TextField("Enter new task", text: $newTask)

                        .padding()

                        .background(Color(.white))

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

                            .foregroundColor(.white)

                            .listRowBackground(Color.black)

                    }

                    .onDelete(perform: deleteTask)

                }

                .listStyle(PlainListStyle())

            }

            .padding()

        }

    }



    func deleteTask(at offsets: IndexSet) {

        tasks.remove(atOffsets: offsets)

    }

}



#Preview {

    ContentView()

}





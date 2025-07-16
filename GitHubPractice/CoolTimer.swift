//
//  CoolTimer.swift
//  GitHubPractice
//
//  Created by Scholar on 7/15/25.
//

import SwiftUI

struct CoolTimer_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct Home: View {
    @StateObject var dateModel = DateViewModel()
    var body: some View {
        ZStack{
            VStack(spacing: 12) {
                Text(dateModel.selectedDate, style: .time)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .onTapGesture {
                        // setting time as select
                        dateModel.setTime()
                        withAnimation(.spring()) {
                            dateModel.showPicker.toggle()
                            dateModel.showSavedMessage = false // hide message when editing again
                        }
                    }
                
                // Show saved message if true
                if dateModel.showSavedMessage {
                    Text("Your LockIn Schedule will start at \(dateModel.formattedTime)!")
                        .font(.headline)
                        .foregroundColor(.black)
                        .transition(.opacity)
                }
            }
            
            if dateModel.showPicker {
                VStack(spacing: 0) {
                    HStack(spacing: 18){
                        Spacer()
                        HStack(spacing: 0) {
                            Text("\(dateModel.hour):")
                                .font(.largeTitle)
                                .fontWeight(dateModel.changeToMin ? .light : .bold)
                                .onTapGesture {
                                    // updating angle values...
                                    dateModel.angle = Double(dateModel.hour * 30)
                                    dateModel.changeToMin = false
                                }
                            Text("\(dateModel.minutes < 10 ? "0": "")\(dateModel.minutes)")
                                .font(.largeTitle)
                                .fontWeight(dateModel.changeToMin ? .bold : .light)
                                .onTapGesture {
                                    dateModel.angle = Double(dateModel.minutes * 6)
                                    dateModel.changeToMin = true
                                }

                        }
                        VStack(spacing: 8) {
                            Text("AM")
                                .font(.title2)
                                .fontWeight(dateModel.symbol == "AM" ? .bold: .light)
                                .onTapGesture {
                                    dateModel.symbol = "AM"
                                }
                            Text("PM")
                                .font(.title2)
                                .fontWeight(dateModel.symbol == "PM" ? .bold: .light)
                                .onTapGesture {
                                    dateModel.symbol = "PM"
                                }
                        }
                        .frame(width: 50)
                    }
                    .padding()
                    .foregroundColor(Color(red: 255/255, green: 240/255, blue: 140/255))
                    
                    // Circular Slider....
                    TimeSlider()
                    
                    HStack {
                        Spacer()
                        Button(action: dateModel.generateTime, label: {
                            Text("Save")
                                .fontWeight(.bold)
                            
                        })
                    }
                    .padding()
                }
                // Max Width....
                .frame(width: getWidth()-120)
                .background(Color.primary)
                .cornerRadius(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.primary.opacity(0.3).ignoresSafeArea().onTapGesture {
                    withAnimation(.spring()) {
                        dateModel.showPicker.toggle()
                        dateModel.changeToMin = false
                    }
                })
                .environmentObject(dateModel)
            }
         
        }
    }
}

// extending View to get Screen Size...
extension View {
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}

//Data...
class DateViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var showPicker = false
    
    @Published var hour: Int = 12
    @Published var minutes: Int = 0
    
    @Published var changeToMin = false
    @Published var symbol = "AM"
    
    //angle...
    @Published var angle : Double = 0
    
    @Published var showSavedMessage = false
    
    // formatted time string for display in message
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: selectedDate)
    }
    
    // save button function....
    func generateTime() {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        
        let correctHourValue = symbol == "AM" ? (hour == 12 ? 0 : hour) : (hour == 12 ? 12 : hour + 12)
        let date = format.date(from: "\(correctHourValue):\(minutes)")
        if let date = date {
            self.selectedDate = date
        }
        
        withAnimation{
            showPicker.toggle()
            changeToMin = false
            showSavedMessage = true // show message after saving
        }
    }
    
    func setTime() {
        let calendar = Calendar.current
        
        // 24 Hrs...
        hour = calendar.component(.hour, from: selectedDate)
        symbol = hour < 12 ? "AM" : "PM"
        hour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        minutes = calendar.component(.minute, from: selectedDate)
        
        angle = Double(hour * 30)
    }
}

struct TimeSlider: View {
    
    @EnvironmentObject var dateModel: DateViewModel
    var body: some View {
        GeometryReader {
            reader in
            
            ZStack {
                //Time Slider
                let widdth = reader.frame(in: .global).width/2
                //Knob or Circle
                Circle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 40)
                    .offset(x: widdth - 50)
                    .rotationEffect(.init(degrees: dateModel.angle))
                    .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
                    .rotationEffect(.init(degrees:-90))
                ForEach(1...12, id: \.self) {
                    index in
                    
                    VStack {
                        Text("\(dateModel.changeToMin ? index * 5 : index)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        // reverting back the inside view...
                            .rotationEffect(.init(degrees: Double(-index)*30))
                        
                    }
                    .offset(y: -widdth + 50)
                    .rotationEffect(.init(degrees: Double(index)*30))
                }
                //Arrow
                Circle()
                    .fill(Color.blue)
                    .frame(width: 10, height: 10)
                    .overlay(
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 2, height: widdth/2)
                        ,alignment: .bottom
                    )
                    .rotationEffect(.init(degrees: dateModel.angle))
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        // maxheight...
        .frame(height: 300)
    }
    
    // gesture...
    func onChanged(value: DragGesture.Value) {
        // getting angle...
        let vector = CGVector(dx: value.location.x, dy:value.location.y)
        // circle or knob size
        let radians = atan2(vector.dy-20, vector.dx-20)
        
        var angle = radians * 180 / .pi
        
        if angle < 0 {
            angle = 360 + angle
        }
        dateModel.angle = Double(angle)
        
      // disabling for minutes
        if !dateModel.changeToMin {
            // rounding up the value...
            let roundValue = 30 * Int(round(dateModel.angle/30))
            
            dateModel.angle = Double(roundValue)
        }
        else {
            //updating minutes
            let progress = dateModel.angle / 360
            dateModel.minutes = Int(progress * 60)
        }
    }
    func onEnd(value: DragGesture.Value) {
       
        if !dateModel.changeToMin {
            // updating Hour value
            dateModel.hour = Int(dateModel.angle / 30)
            
            // updating picker to minutes
            withAnimation{
                
                // setting to minute Value...
                dateModel.angle = Double(dateModel.minutes * 6)
                dateModel.changeToMin = true
        
            }
        }
    }
}

//
//  ContentView.swift
//  BetterRest
//
//  Created by Liko Setiawan on 07/02/24.
//


import CoreML
import SwiftUI


struct ContentView: View {
    
    static var defaultWakeTime: Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
        
    }
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
//    
//    
//    func calculatedBedtime(){
//        do{
//            let config = MLModelConfiguration()
//            let model = try SleepCalculator(configuration: config)
//            //            print("\(config)")
//            
//            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
//            let hour = (components.hour ?? 0) * 60 * 60
//            let minute = (components.minute ?? 0) * 60
//            
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
//            
//            let sleepTime = wakeUp - prediction.actualSleep
//            
//            alertTitle = "Your ideal bedtime is…"
//            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
//            showingAlert = true
//            
//        }catch{
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime."
//            showingAlert = true
//        }
////        showingAlert = true
//    }
    
    
    
    var body: some View {
        NavigationStack{
            Form{
                VStack(alignment: .leading) {
                    Text("When do you want to wake up ?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time",selection: $wakeUp, displayedComponents: .hourAndMinute )
                        .labelsHidden()
                }
                VStack(alignment: .leading){
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) Hours", value: $sleepAmount, in: 4...12, step : 0.25)
                }
                Section{
                    Picker("Daily coffee intake", selection: $coffeeAmount){
                        ForEach(1...20, id : \.self ){cup in
                            Text("^[\(cup) cup](inflect:true)")
                        }
                        
                    }
                    .font(.headline)
                    
                }
                Section("Your ideal Bed Time"){
                    Text(idealBedtime)
                        .font(.title)
                }
            }
            .navigationTitle("Better Sleep")
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    var idealBedtime: String {
           do {
               let config = MLModelConfiguration()
               let model = try SleepCalculator(configuration: config)
               
               let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
               let hour = (components.hour ?? 0) * 60 * 60
               let minute = (components.minute ?? 0) * 60
               
               let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
               
               let sleepTime = wakeUp - prediction.actualSleep
               
               return sleepTime.formatted(date: .omitted, time: .shortened)
           } catch {
               return "Error calculating bedtime"
           }
       }
}

#Preview {
    ContentView()
}

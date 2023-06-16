//
//  ContentView.swift
//  BetterRest
//
//  Created by Pawan's Mac on 22/01/23.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeamount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    var body: some View {
        NavigationView{
            Form{
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter a time",selection: $wakeUp,displayedComponents:
                        .hourAndMinute)
                .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours",value: $sleepAmount,in: 4...12,step: 0.25)
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper(coffeeamount == 1 ? "1 cup" :"\(coffeeamount) cups", value:$coffeeamount,in: 1...20 )
            }
            .navigationTitle("BetterRest")
            .toolbar{
                Button("Calculate",action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showingAlert){
                Button("OK"){}
            }message: {
                Text(alertMessage)
            }
            
        }
      
    }
    func calculateBedTime(){
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration:config)
            
            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute =  (components.minute ?? 0) * 60
            let prediction =  try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeamount))
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle  = "Your actual bedtime is."
            alertMessage = sleepTime.formatted(date:.omitted, time: .shortened)
        }
        catch{
            alertTitle = "Error"
            alertMessage = "Sorry, There was a problem in calculating your bedtime. "
        }
       showingAlert = true
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

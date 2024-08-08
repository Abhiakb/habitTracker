import SwiftUI

struct CalendarView: View {
    
    @Binding var habits: [HabitStatus]
    @Binding var selectedHabits: [HabitStatus]
    @State private var selectedDate = Date()
    @State private var assignedHabits = [Date: [HabitStatus]]()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    var body: some View {
        VStack {
            Text("Select a date to assign habits")
                .font(.headline)
                .padding()
            
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            Text("Selected Date: \(dateFormatter.string(from: selectedDate))")
                .padding()
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach($selectedHabits) { $habitStatus in
                        HStack {
                            Text(habitStatus.habit.emoji)
                            Text(habitStatus.habit.name)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            Spacer()
                            if assignedHabits[selectedDate, default: []].contains(where: { $0.id == habitStatus.id }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.vertical, 5)
                        .onTapGesture {
                            // Toggle habit assignment for selected date
                            if let index = assignedHabits[selectedDate]?.firstIndex(where: { $0.id == habitStatus.id }) {
                                assignedHabits[selectedDate]?.remove(at: index)
                            } else {
                                if assignedHabits[selectedDate] == nil {
                                    assignedHabits[selectedDate] = []
                                }
                                assignedHabits[selectedDate]?.append(habitStatus)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)// Hide the back button
    }
}

struct CalendarView_Previews: PreviewProvider {
    @State static var habits = [
        HabitStatus(habit: Habit(name: "Workout", emoji: "🏋️‍♂️")),
        HabitStatus(habit: Habit(name: "Read a book", emoji: "📖"))
    ]
    
    @State static var selectedHabits = [
        HabitStatus(habit: Habit(name: "Workout", emoji: "🏋️‍♂️")),
        HabitStatus(habit: Habit(name: "Read a book", emoji: "📖"))
    ]
    
    static var previews: some View {
        CalendarView(habits: $habits, selectedHabits: $selectedHabits)
    }
}


import SwiftUI

struct Habit: Identifiable {
    var id = UUID()
    var name: String
    var emoji: String
}

struct HabitStatus: Identifiable {
    var id = UUID()
    var habit: Habit
    var isTapped: Bool = false
    var progress: Double = 0.0
    var completionDates: [Date] = []
}

struct HomeView: View {
    
    @State private var customHabit: String = ""
    @State private var habits = [
        Habit(name: "Eat Healthy", emoji: "🥗"),
        Habit(name: "Workout", emoji: "💪"),
        Habit(name: "Run", emoji: "🏃‍♂️"),
        Habit(name: "Read Book", emoji: "📖"),
        Habit(name: "Sleep Early", emoji: "😴"),
        Habit(name: "Call a Friend", emoji: "📞"),
        Habit(name: "Morning Meditation", emoji: "🧘‍♂️"),
        Habit(name: "Save Money", emoji: "💰"),
        Habit(name: "Invest Money", emoji: "📈"),
        Habit(name: "Pay My Bills", emoji: "💳")
    ].map { HabitStatus(habit: $0) }
    
    @State private var showSheet = false
    @State private var selectedHabits = [HabitStatus]()
    @State private var currentDate = Date()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }

    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.8))
                        .shadow(radius: 10)
                        .frame(height: 300) // Adjust the height as needed
                        .overlay(
                            VStack {
                                Text(dateFormatter.string(from: currentDate))
                                    .font(.headline)
                                    .padding(.bottom, 10)

                                ScrollView {
                                    VStack(alignment: .leading) {
                                        ForEach($habits) { $habitStatus in
                                            HStack {
                                                Text(habitStatus.habit.emoji)
                                                Text(habitStatus.habit.name)
                                                    .padding()
                                                    .background(Color(.systemGray6))
                                                    .cornerRadius(10)
                                                Spacer()
                                            }
                                            .padding(.vertical, 5)
                                            .onTapGesture {
                                                if !selectedHabits.contains(where: { $0.id == habitStatus.id }) {
                                                    selectedHabits.append(habitStatus)
                                                    showSheet = true
                                                }
                                            }
                                        }

                                        HStack {
                                            TextField("Enter custom habit", text: $customHabit)
                                                .padding()
                                                .background(Color(.systemGray6))
                                                .cornerRadius(10)
                                            Button(action: {
                                                // Handle custom habit entry
                                                let newHabit = Habit(name: customHabit, emoji: "🆕")
                                                habits.append(HabitStatus(habit: newHabit))
                                                customHabit = ""
                                            }) {
                                                Text("Add")
                                                    .foregroundColor(.white)
                                                    .padding(.vertical, 10)
                                                    .padding(.horizontal, 20)
                                                    .background(Color.blue)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        .padding(.vertical, 10)
                                    }
                                    .padding()
                                }
                            }
                            .padding()
                        )
                        .padding()

                    Spacer()
                }
                .sheet(isPresented: $showSheet) {
                    HabitDetailView(habitStatuses: $selectedHabits) {
                        selectedHabits.removeAll()
                        showSheet = false
                    }
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            NewView(habits: $selectedHabits)
                .tabItem {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("New")
                }

            CalendarView(habits: $habits, selectedHabits: $selectedHabits)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Calendar")
                }

            DashboardView(habits: $habits)
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Dashboard")
                }
        }
    }
}

struct HabitDetailView: View {
    @Binding var habitStatuses: [HabitStatus]
    var onClose: () -> Void

    var body: some View {
        VStack {
            Text("Track your habits")
                .font(.largeTitle)
                .padding()

            ScrollView {
                VStack {
                    ForEach(habitStatuses.indices, id: \.self) { index in
                        let habitStatusBinding = $habitStatuses[index]
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .frame(width: 300, height: 300)
                            .shadow(radius: 10)
                            .overlay(
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            habitStatuses.remove(at: index)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                                .padding()
                                        }
                                    }
                                    Text(habitStatusBinding.habit.emoji.wrappedValue)
                                        .font(.largeTitle)
                                        .padding(.bottom, 10)
                                    Text(habitStatusBinding.habit.name.wrappedValue)
                                        .font(.title2)
                                        .padding(.bottom, 10)
                                    Text("Progress: \(Int(habitStatusBinding.progress.wrappedValue * 100))%")
                                        .font(.body)
                                        .padding(.bottom, 10)
                                    
                                    HStack {
                                        Button("Done") {
                                            habitStatusBinding.progress.wrappedValue = 1.0
                                        }
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        
                                        Button("Missed") {
                                            habitStatusBinding.progress.wrappedValue = 0.0
                                        }
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    }
                                }
                                .padding()
                            )
                            .padding(.bottom,10)
                    }
                }
                .padding()
            }

            Spacer()

            Button("Close") {
                onClose()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            
        }
        .padding()
    }
}

struct NewView: View {
    @Binding var habits: [HabitStatus]
    
    var body: some View {
        VStack {
            ForEach($habits) { $habit in
                HabitCardView(habit: $habit)
            }
            Spacer()
        }
        .padding()
    }
}

struct HabitCardView: View {
    @Binding var habit: HabitStatus

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.white)
            .frame(width: 340, height: 250)
            .shadow(radius: 10)
            .overlay(
                VStack(alignment: .leading) {
                    HStack {
                        Text(habit.habit.emoji)
                            .font(.largeTitle)
                        Text(habit.habit.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.bottom, 5)

                    Text("\(Int(habit.progress * 100))% (\(habit.progress * 7.0, specifier: "%.1f") today)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    ProgressView(value: habit.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                        .padding(.vertical, 5)

                    HStack {
                        ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                            Text(day)
                                .frame(width: 30, height: 30)
                                .background(day == "W" && habit.habit.name == "Workout" ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.bottom, 10)
                }
                .padding()
            )
            .padding(.bottom, 10)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


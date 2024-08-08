import SwiftUI

struct DashboardView: View {
   
    @Binding var habits: [HabitStatus]
    @State private var notificationsEnabled = false
    @State private var notificationTime = Date()

    private var completedHabits: Int {
        habits.filter { $0.progress >= 1.0 }.count
    }

    private var inProgressHabits: Int {
        habits.filter { $0.progress == 0.0 }.count
    }

    private var habitCompletionRate: Double {
        guard !habits.isEmpty else { return 0 }
        return (Double(completedHabits) / Double(habits.count)) * 100
    }

    private var overallProgress: Double {
        guard !habits.isEmpty else { return 0 }
        let totalProgress = habits.map { $0.progress }.reduce(0, +)
        return totalProgress / Double(habits.count)
    }

    private var streaks: Int {
        // Calculate the maximum streak for completed habits
        let allCompletionDates = habits.flatMap { $0.completionDates }
        let sortedDates = allCompletionDates.sorted()

        var maxStreak = 0
        var currentStreak = 0
        var lastDate: Date?

        let calendar = Calendar.current
        let dateComponents = DateComponents(day: 1)

        for date in sortedDates {
            if let lastDate = lastDate, calendar.dateComponents([.day], from: lastDate, to: date).day == 1 {
                currentStreak += 1
            } else {
                currentStreak = 1
            }

            maxStreak = max(maxStreak, currentStreak)
            lastDate = date
        }

        return maxStreak
    }

    var body: some View {
        VStack {
            Text("Dashboard")
                .font(.largeTitle)
                .padding()

            HStack {
                VStack {
                    Text("Overall Progress")
                        .font(.headline)
                    ProgressView(value: overallProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .padding()
                    Text("\(Int(overallProgress * 100))%")
                }
                .padding()

                VStack {
                    Text("Completed Habits")
                        .font(.headline)
                    Text("\(completedHabits)")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                        .padding()
                }
                .padding()
            }

            HStack {
                VStack {
                    Text("In Progress Habits")
                        .font(.headline)
                    Text("\(inProgressHabits)")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .padding()
                }
                .padding()

                VStack {
                    Text("Streaks")
                        .font(.headline)
                    Text("\(streaks) days")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .padding()
                }
                .padding()
            }

            VStack {
                Text("Habit Completion Rate")
                    .font(.headline)
                Text(String(format: "%.2f%%", habitCompletionRate))
                    .font(.largeTitle)
                    .padding()
            }
            .padding()

            Spacer()
            
            VStack {
                Text("Notifications")
                    .font(.headline)
                    .padding()

                HStack {
                    Toggle("Enable reaminder", isOn: $notificationsEnabled)
                        .padding()

                    if notificationsEnabled {
                        DatePicker("Notification Time", selection: $notificationTime, displayedComponents: .hourAndMinute)
                            .padding()
                            .labelsHidden()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .padding()
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

struct DashboardView_Previews: PreviewProvider {
    @State static var habits = [
        HabitStatus(habit: Habit(name: "Workout", emoji: "🏋️‍♂️"), progress: 1.0, completionDates: [Date().addingTimeInterval(-86400 * 2), Date().addingTimeInterval(-86400)]),
        HabitStatus(habit: Habit(name: "Read Book", emoji: "📖"), progress: 0.0, completionDates: [])
    ]

    static var previews: some View {
        DashboardView(habits: $habits)
    }
}


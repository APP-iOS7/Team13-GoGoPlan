//
//  CalendarView.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//
/*
import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        // TODO: 달력 구현
        Text("Calendar View")
    }
}

*/
import SwiftUI

struct CalendarView: View {
    @Binding var selectedDates: Set<Date>
    @State private var currentDate = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter
    }()
    
    var body: some View {
        VStack {
            // 월 이동 헤더
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                }
                
                Text(monthFormatter.string(from: currentDate))
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            
            // 요일 헤더
            HStack {
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(day == "일" ? .red : .primary)
                }
            }
            .padding(.top)
            
            // 날짜 그리드
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(days, id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            isSelected: selectedDates.contains(date),
                            isToday: calendar.isDateInToday(date)
                        )
                        .onTapGesture {
                            if selectedDates.contains(date) {
                                selectedDates.remove(date)
                            } else {
                                selectedDates.insert(date)
                            }
                        }
                    } else {
                        Color.clear
                    }
                }
            }
        }
        .padding()
    }
    
    private var days: [Date?] {
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let range = calendar.range(of: .day, in: .month, for: start)!
        
        let firstWeekday = calendar.component(.weekday, from: start)
        let previousMonth = Array(repeating: nil as Date?, count: firstWeekday - 1)
        
        let daysInMonth = range.map { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: start)
        }
        
        return previousMonth + daysInMonth
    }
    
    private func previousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
    }
    
    private func nextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        Text(dateFormatter.string(from: date))
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(
                isSelected ? Color.blue :
                    isToday ? Color.gray.opacity(0.2) : Color.clear
            )
            .foregroundColor(
                isSelected ? .white :
                    calendar.component(.weekday, from: date) == 1 ? .red :
                    .primary
            )
            .clipShape(Circle())
    }
}

#Preview {
    CalendarView(selectedDates: .constant([]))
}

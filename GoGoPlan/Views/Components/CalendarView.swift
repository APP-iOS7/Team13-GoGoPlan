import SwiftUI

struct CalendarView: View {
    // 버튼을 눌렀을 떄 선택되는 날짜들
    @Binding var selectedDates: Set<Date>
    // 현재(지금) 날짜
    @State private var currentDate = Date()
    
    private let calendar = Calendar.current
    // 날짜 표기 포맷(숫자: d)
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    // 년, 월 표기 포맷(ex. 2025년 2월)
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter
    }()
    
    var body: some View {
        VStack {
            // 월 이동 헤더
            HStack {
                // < 이전 달로 이동 버튼
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                }
                
                Text(monthFormatter.string(from: currentDate))
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                // > 다음 달로 이동 버튼
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
                        // 날짜 하나 뷰
                        DayCell(
                            date: date,
                            isSelected: selectedDates.contains(date),
                            isToday: calendar.isDateInToday(date)
                        )
                        .onTapGesture {
                            // 눌렀을 때 선택된 날짜들의 배열에 추가 및 삭제
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
        // 이번 달의 첫번째 날짜
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        // 이번 달이 몇 일 있는지
        let range = calendar.range(of: .day, in: .month, for: start)!
        
        // 이번 달 첫날이 무슨 요일인지
        let firstWeekday = calendar.component(.weekday, from: start)
        
        // 저번 달의 날짜들을 nil로
        let previousMonth = Array(repeating: nil as Date?, count: firstWeekday - 1)
        
        // 이번 달의 모든 날짜를 배열로 생성
        let daysInMonth = range.map { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: start)
        }
        
        // 저번 달의 빈 칸과 현재 달의 날짜들을 합쳐서 리턴
        return previousMonth + daysInMonth
    }
    
    // 이번 달을 저번 달로 바꿔줌
    private func previousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
    }
    // 이번 달을 다음 달로 바꿔줌
    private func nextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
    }
}

// 날짜 하나 뷰
struct DayCell: View {
    // 날짜
    let date: Date
    // 해당 날짜가 눌렸는지 여부
    let isSelected: Bool
    // 오늘인지 여부
    let isToday: Bool
    
    // 오늘 날짜
    private let calendar = Calendar.current
    // 날짜 표시 포맷 (ex. 1(d))
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
                // 눌렸을 때 색깔을 파란색으로 아닌 경우는 투명색
                // 오늘인 경우 회색으로 배경을 칠함.
                // 삼항 연산자 중첩해서 사용하지 말라고 하셨는데...
                isSelected ? Color.blue :
                    isToday ? Color.gray.opacity(0.2) : Color.clear
            )
            .foregroundColor(
                // 일요일인 경우 빨간색 아닌 경우 검은색
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

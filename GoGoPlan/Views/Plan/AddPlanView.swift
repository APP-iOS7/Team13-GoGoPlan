import SwiftUI
import SwiftData

struct AddPlanView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    var onComplete: () -> Void
    
    @State private var searchText = ""
    @State private var selectedRegion = "서울"
    @State private var selectedDates = Set<Date>()
    
    var body: some View {
        VStack(spacing: 20) {
            // 검색창
            TextField("여행지를 검색해보세요", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // 지역 선택
            RegionScrollView(selectedRegion: $selectedRegion)
            
            // 달력
            CalendarView(selectedDates: $selectedDates)
            
            Spacer()
            
            // 완료 버튼
            Button(action: createPlan) {
                Text("완료")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        selectedDates.isEmpty ?
                        Color.gray :
                            Color.blue
                    )
                    .cornerRadius(10)
            }
            .disabled(selectedDates.isEmpty)
            .padding()
        }
        .navigationTitle("새로운 여행")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("취소") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    private func createPlan() {
        guard !selectedDates.isEmpty else { return }
        
        guard let startDate = selectedDates.min(), // 가장 빠른 날짜
              let endDate = selectedDates.max() else { return }
        
        // 새로운 Plan 생성
        let plan = Plan(
            region: selectedRegion,
            startDate: startDate,
            endDate: endDate
        )
        
        // startDate부터 endDate까지 하루씩 증가하며 Day 객체 생성
        var currentDate = startDate
        var dayNumber = 1
        while currentDate <= endDate {
            let day = Day(
                date: currentDate,
                dayNumber: dayNumber
            )
            plan.days.append(day)
            
            // 하루를 증가시킴
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            dayNumber += 1
        }
        
        // Plan을 ModelContext에 추가
        modelContext.insert(plan)
        
        // 저장 후 화면 닫기
        onComplete()
        presentationMode.wrappedValue.dismiss()
    }
}


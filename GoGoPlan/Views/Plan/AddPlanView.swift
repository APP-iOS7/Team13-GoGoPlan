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
        
        let sortedDates = selectedDates.sorted()
        guard let startDate = sortedDates.first,
              let endDate = sortedDates.last else { return }
        
        // 새로운 Plan 생성
        let plan = Plan(
            region: selectedRegion,
            startDate: startDate,
            endDate: endDate
        )
        
        // Day 객체들 생성
        for (index, date) in sortedDates.enumerated() {
            let day = Day(
                date: date,
                dayNumber: index + 1
            )
            plan.days.append(day)
        }
        
        // Plan을 ModelContext에 추가
        modelContext.insert(plan)
        
        onComplete()
    }
}


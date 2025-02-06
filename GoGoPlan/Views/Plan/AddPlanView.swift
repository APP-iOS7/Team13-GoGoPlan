import SwiftUI
import SwiftData

struct AddPlanView: View {
    // 모델 컨텍스트를 환경에서 가져옴
    @Environment(\.modelContext) private var modelContext
    // 현재 화면의 프레젠테이션 모드
    @Environment(\.presentationMode) var presentationMode
    // 완료 시 호출되는 클로저
    var onComplete: () -> Void
    
    // 상태 변수
    @State private var searchText = "" // 검색 텍스트
    @State private var selectedRegion = "서울" // 선택된 지역
    @State private var selectedDates = Set<Date>() // 선택된 날짜 집합
    
    var body: some View {
        VStack(spacing: 20) {
            // 검색창
            TextField("여행지를 검색해보세요", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // 텍스트 필드 스타일
                .padding(.horizontal) // 수평 패딩
            
            // 지역 선택 뷰
            RegionScrollView(selectedRegion: $selectedRegion)
            
            // 달력 뷰
            CalendarView(selectedDates: $selectedDates)
            
            Spacer() // 공간을 추가
            
            // 완료 버튼
            Button(action: createPlan) {
                Text("완료") // 버튼 텍스트
                    .font(.headline) // 헤드라인 폰트
                    .foregroundColor(.white) // 텍스트 색상
                    .frame(maxWidth: .infinity) // 최대 너비 설정
                    .padding() // 패딩
                    .background(
                        selectedDates.isEmpty ? // 날짜가 선택되지 않은 경우
                        Color.gray : // 회색 배경
                        Color.blue // 선택된 경우 파란색 배경
                    )
                    .cornerRadius(10) // 둥근 모서리
            }
            .disabled(selectedDates.isEmpty) // 날짜가 없으면 버튼 비활성화
            .padding() // 패딩
        }
        .navigationTitle("새로운 여행") // 내비게이션 타이틀
        .navigationBarTitleDisplayMode(.inline) // 타이틀 표시 모드
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("취소") {
                    presentationMode.wrappedValue.dismiss() // 취소 버튼 클릭 시 화면 닫기
                }
            }
        }
    }
    
    private func createPlan() {
        // 선택된 날짜가 없으면 함수 종료
        guard !selectedDates.isEmpty else { return }
        
        // 가장 빠른 시작 날짜와 가장 늦은 종료 날짜 가져오기
        guard let startDate = selectedDates.min(), // 가장 빠른 날짜
              let endDate = selectedDates.max() else { return }
        
        // 새로운 Plan 객체 생성
        let plan = Plan(
            region: selectedRegion, // 선택된 지역
            startDate: startDate, // 시작 날짜
            endDate: endDate // 종료 날짜
        )
        
        // startDate부터 endDate까지 하루씩 증가하며 Day 객체 생성
        var currentDate = startDate
        var dayNumber = 1 // 일 수
        while currentDate <= endDate {
            let day = Day(
                date: currentDate, // 현재 날짜
                dayNumber: dayNumber // 일 수
            )
            plan.days.append(day) // Plan에 Day 추가
            
            // 하루를 증가시킴
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            dayNumber += 1 // 일 수 증가
        }
        
        // Plan을 ModelContext에 추가
        modelContext.insert(plan)
        
        // 저장 후 화면 닫기
        onComplete() // 완료 클로저 호출
        presentationMode.wrappedValue.dismiss() // 화면 닫기
    }
}

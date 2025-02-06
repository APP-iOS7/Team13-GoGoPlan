import SwiftUI
import SwiftData
import MapKit

// 나의 일정 전체 뷰
struct PlanListView: View {
    // 닐짜의 시작날짜를 기준으로 일정들을 sorting한다
    @Query(sort: \Plan.startDate, order: .reverse) private var plans: [Plan]
    @Environment(\.modelContext) private var modelContext
    // 맵에서 사용할 위도 경도 등 정보들을 저장할 변수
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    // 선택된 일정
    @State private var selectedPlan: Plan?
    // 수정 중인지 여부
    @State private var isEditing = false
    // 검색된 장소들을 보여줄지 유무
    @State private var showSearchPlace = false
    // 메모 뷰를 보여줄지 여부
    @State private var showMemoView = false
    // 수정 눌렀을 때 날을 수정할지 여부
    @State private var editingDay: Day?
    // api에서 장소들을 가져옴
    @StateObject private var placeService = PlaceService()
    // 해당 뷰에서만 toolbar가 뜨도록 설정해줄 전역변수
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // 추가한 일정이 있는 경우
                if let plan = selectedPlan {
                    // 좌측 정렬
                    VStack(alignment: .leading, spacing: 16) {
                        // 지역 및 날짜 표시
                        HStack {
                            Text(plan.region)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            // 수정 버튼을 누른 경우 일정의 장소를 바꿀 수 있다.
                            if isEditing {
                                Menu {
                                    Picker("지역", selection: .init(
                                        get: { plan.region },
                                        set: { plan.region = $0 }
                                    )) {
                                        ForEach(["서울", "경기", "인천", "강원", "충북", "충남", "대전", "세종",
                                                 "경북", "경남", "대구", "울산", "부산", "전북", "전남", "광주", "제주"],
                                                id: \.self) { region in
                                            Text(region).tag(region)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "chevron.down.circle.fill")
                                }
                            }
                        }
                        
                        // 일정의 날짜를 표시
                        Text("\(plan.startDate.formatted(date: .numeric, time: .omitted)) - \(plan.endDate.formatted(date: .numeric, time: .omitted))")
                            .foregroundColor(.gray)
                        
                        // 지도(맵킷) 커스텀한거라...
                        // 일정의 Day별 추가한 장소의 위치 주소를 파라미터로 받으면 그 지역을 출력한다.
                        CustomMapView(places: plan.days.flatMap { $0.places })
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        // Day 리스트 -> 각 Day를 날짜 순서로 sorting한다. 즉 날짜 순서대로 보여준다.
                        ForEach(plan.days.sorted(by: { $0.date < $1.date})) { day in
                            // 지도 아래 Day들 중 하나 전체적인 뷰
                            DaySection(
                                day: day,
                                isEditing: isEditing,
                                onAddPlace: {
                                    editingDay = day
                                    showSearchPlace = true
                                },
                                onAddMemo: {
                                    editingDay = day
                                    showMemoView = true
                                },
                                onDelete: { place in
                                    if let index = day.places.firstIndex(where: { $0.id == place.id }) {
                                        day.places.remove(at: index)
                                    }
                                }
                            )
                        }
                    }
                    .padding()
                    
                } else {
                    Text("일정을 선택해주세요")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .onAppear {
                // 나의 일정 뷰가 보여지면
                // 일정이 없는경우 Plan 데이터에서 마지막 plan을 선택한다.
//                if selectedPlan == nil {
//                    selectedPlan = plans.last
//                }
                // 일정이 있는 경우 일정이 만들어진 순서대로 sorting해서 맨 마지막 일정을 보여준다.
                // 즉 일정을 새로 만들면 두번째 뷰에서 새로 만든 일정이 보이게 된다.
                // 하지만 두번째 뷰에서 다른 일정으로 바꿔도 다른 탭에 갔다가 돌아오면 다른 일정으로 바뀐다.
                
                // 코드 추가 -> 예외처리
                if selectedPlan == nil && !plans.isEmpty {
                    selectedPlan = plans.first
                }
                
                else {
                    selectedPlan = plans.sorted { $0.dateCreated < $1.dateCreated }.last
                }
            }
            .navigationTitle("나의 일정")
            .toolbar {
                // 탭뷰 중 나의 일정을 클릭한 경우에만 툴바가 보이도록
                // 저만 되는 듯...
                if appState.selectedTab == 1 {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // 일정이 있는 경우
                        if !plans.isEmpty {
                            Menu {
                                // 추가했던 일정들을 버튼으로 보여준다.
                                ForEach(plans) { plan in
                                    Button(plan.region) {
                                        selectedPlan = plan
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedPlan?.region ?? "일정 선택")
                                    Image(systemName: "chevron.down")
                                }
                            }
                        }
                    }
                    // 수정 버튼
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if selectedPlan != nil {
                            Button(isEditing ? "완료" : "수정") {
                                isEditing.toggle()
                            }
                        }
                    }
                }
            }
        }
        // 장소 추가 버튼 누르면 sheet 뷰로
        .sheet(isPresented: $showSearchPlace) {
            if let day = editingDay {
                SearchPlaceView(day: day, placeService: placeService)
            }
        }
        // memo추가 하면 sheet뷰로
        .sheet(isPresented: $showMemoView) {
            if let day = editingDay {
                MemoView(day: day)
            }
        }
    }
}

#Preview {
    PlanListView()
        .modelContainer(for: Plan.self)
}

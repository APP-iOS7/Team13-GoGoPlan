import SwiftUI
import SwiftData
import MapKit

struct PlanListView: View {
    @Query(sort: \Plan.startDate, order: .reverse) private var plans: [Plan]
    @Environment(\.modelContext) private var modelContext
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var selectedPlan: Plan?
    @State private var isEditing = false
    @State private var showSearchPlace = false
    @State private var showMemoView = false
    @State private var editingDay: Day?
    @StateObject private var placeService = PlaceService()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let plan = selectedPlan {
                    VStack(alignment: .leading, spacing: 16) {
                        // 지역 및 날짜 표시
                        HStack {
                            Text(plan.region)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
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
                        
                        Text("\(plan.startDate.formatted(date: .numeric, time: .omitted)) - \(plan.endDate.formatted(date: .numeric, time: .omitted))")
                            .foregroundColor(.gray)
                        
                        // 지도
                        CustomMapView(places: plan.days.flatMap { $0.places })
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        // Day 리스트
                        ForEach(plan.days) { day in
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
            .navigationTitle("나의 일정")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !plans.isEmpty {
                        Menu {
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
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedPlan != nil {
                        Button(isEditing ? "완료" : "수정") {
                            isEditing.toggle()
                        }
                    }
                }
            }
        }
        .onAppear {
            if selectedPlan == nil && !plans.isEmpty {
                selectedPlan = plans.first
            }
        }
        .sheet(isPresented: $showSearchPlace) {
            if let day = editingDay {
                SearchPlaceView(day: day, placeService: placeService)
            }
        }
        .sheet(isPresented: $showMemoView) {
            if let day = editingDay {
                MemoView(day: day)
            }
        }
    }
}

struct DaySection: View {
    let day: Day
    let isEditing: Bool
    let onAddPlace: () -> Void
    let onAddMemo: () -> Void
    let onDelete: (Place) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Day \(day.dayNumber)")
                .font(.headline)
            
            // 메모 목록
            if !day.memos.isEmpty {
                VStack(spacing: 8) {
                    ForEach(day.memos) { memo in
                        MemoRow(memo: memo)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    }
                }
            }
            
            HStack(spacing: 8) {
                Button(action: onAddPlace) {
                    Label("장소 추가", systemImage: "mappin.circle.fill")
                }
                .buttonStyle(.bordered)
                
                Button(action: onAddMemo) {
                    Label("메모 추가", systemImage: "square.and.pencil")
                }
                .buttonStyle(.bordered)
            }
            
            if !day.memos.isEmpty {
                ForEach(day.memos) { memo in
                    MemoRow(memo: memo)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct PlaceRow: View {
    let place: Place
    let isEditing: Bool
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            if let imageUrl = place.imageUrl {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.headline)
                Text(place.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if isEditing {
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

#Preview {
    PlanListView()
        .modelContainer(for: Plan.self)
}

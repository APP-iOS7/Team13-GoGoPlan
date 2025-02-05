//
//  PlanListView.swift
//  GoGoPlan
//
//  Created by 천문필 on 2/4/25.
//
/*
import SwiftUI

struct PlanListView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    PlanListView()
}
*/



/*
import SwiftUI
import MapKit

struct PlanListView: View {
    @State private var selectedRegion: String = ""
    @State private var selectedDates: [Date] = []
    @State private var days: [Int] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), // 서울 중심
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var body: some View {
        VStack(spacing: 16) {
            // 지역 및 날짜 표시
            VStack(alignment: .leading, spacing: 8) {
                if !selectedRegion.isEmpty {
                    Text(selectedRegion)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                if !selectedDates.isEmpty {
                    Text(formatDates(selectedDates))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            // 지도 표시
            Map(coordinateRegion: $region)
                .frame(height: 200)
                .cornerRadius(12)
                .padding(.horizontal)
            
            // Day 리스트
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(days, id: \.self) { day in
                        DaySection(dayNumber: day)
                    }
                    
                    // Day 추가 버튼
                    Button(action: addNewDay) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Day 추가")
                        }
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
    }
    
    private func addNewDay() {
        if let lastDay = days.last {
            days.append(lastDay + 1)
        } else {
            days.append(1)
        }
    }
    
    private func formatDates(_ dates: [Date]) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return dates.map { formatter.string(from: $0) }.joined(separator: " - ")
    }
}

struct DaySection: View {
    let dayNumber: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Day \(String(format: "%02d", dayNumber))")
                .font(.headline)
                .padding(.horizontal)
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                        Text("장소 추가")
                    }
                    .foregroundColor(.blue)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "note.text")
                        Text("메모 추가")
                    }
                    .foregroundColor(.blue)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
    }
}
*/
import SwiftUI
import SwiftData
import MapKit

struct PlanListView: View {
    @Query private var plans: [Plan]
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
    
    var body: some View {
        NavigationView {
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
        .sheet(isPresented: $showSearchPlace) {
            if let day = editingDay {
                SearchPlaceView(day: day)
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

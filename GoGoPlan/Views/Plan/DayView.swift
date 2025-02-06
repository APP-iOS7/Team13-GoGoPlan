import SwiftUI

struct DaySection: View {
    let day: Day
    let isEditing: Bool
    let onAddPlace: () -> Void
    let onAddMemo: () -> Void
    let onDelete: (Place) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Day \(day.dayNumber)")
                .font(.title)
            
            // 장소 목록
            if !day.places.isEmpty {
                VStack(spacing: 8) {
                    ForEach(day.places.sorted(by: {$0.createdAt < $1.createdAt})) { place in
                        PlaceRow(place: place, isEditing: isEditing, onDelete: {
                            // 삭제 로직
                            if let index = day.places.firstIndex(where: { $0.id == place.id }) {
                                day.places.remove(at: index)
                            }
                        })
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    }
                }
            }
            
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
            
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

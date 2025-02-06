import SwiftUI

// 나의 일정에서 각 Day들의 뷰
struct DaySection: View {
    // 날짜
    let day: Day
    // 수정 여부
    let isEditing: Bool
    // 장소 추가
    let onAddPlace: () -> Void
    // 메모 추가
    let onAddMemo: () -> Void
    // 메모 삭제
    let onDelete: (Place) -> Void
    
    var body: some View {
        // 좌측 정렬
        VStack(alignment: .leading, spacing: 12) {
            // Day 옆에 숫자 (Day "1")
            Text("Day \(day.dayNumber)")
                .font(.title)
            
            // 해당 날짜의 장소 배열이 비어있지 않은 경우 -> 해당 날짜에대한 장소가 있는 경우
            if !day.places.isEmpty {
                VStack(spacing: 8) {
                    // 장소가 추가된 날짜 순으로 sorting한다. -> 장소 추가시 아래로 계속 추가되도록
                    ForEach(day.places.sorted(by: {$0.createdAt < $1.createdAt})) { place in
                        // 장소 추가시 장소의 이름과 정보들을 출력하는 뷰
                        PlaceRow(place: place, isEditing: isEditing, onDelete: {
                            // 장소를 추가하다가 같은 장소를 또 추가하는 경우 마지막에 추가한 장소를 삭제함
                            if let index = day.places.firstIndex(where: { $0.id == place.id }) {
                                day.places.remove(at: index)
                            }
                        })
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    }
                }
            }
            
            // 해당 날짜의 메모 배열이 비어있지 않은 경우 -> 해당 날짜에대한 메모가 있는 경우
            if !day.memos.isEmpty {
                VStack(spacing: 8) {
                    ForEach(day.memos) { memo in
                        // 메모 하나의 뷰
                        MemoRow(memo: memo)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    }
                }
            }
            
            HStack(spacing: 8) {
                // 장소 추가 및 메모 추가의 버튼들
                // 눌렀을 때 onAddPlace 와 onAddMemo 클로저가 실행된다.
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

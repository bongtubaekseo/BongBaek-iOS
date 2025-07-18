import SwiftUI
import Combine

// MARK: - EventDateViewModel
class EventDateViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedDate: Date? = nil
    @Published var selectedAttendance: AttendanceType? = nil
    @Published var isDatePickerVisible: Bool = false
    @Published var isPastDate: Bool = false
    @Published var showEventLocationView = false
    
    // MARK: - Computed Properties
    var isNextButtonEnabled: Bool {
        selectedDate != nil && selectedAttendance != nil && !isPastDate
    }
    
    // MARK: - Date Validation Methods
    func checkDateAndUpdateUI() {
        guard let selectedDate = selectedDate else {
            isPastDate = false
            return
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selected = calendar.startOfDay(for: selectedDate)
        
        let pastDate = selected < today
        
        print("=== 날짜 검증 ===")
        print("선택된 날짜: \(selectedDate)")
        print("오늘 날짜: \(Date())")
        print("과거 날짜 여부: \(pastDate)")
        print("===============")
        
        DispatchQueue.main.async {
            self.isPastDate = pastDate
        }
    }
    
    // MARK: - Methods
    func selectAttendance(_ attendanceType: AttendanceType) {
        if selectedAttendance == attendanceType {
            selectedAttendance = nil
        } else {
            selectedAttendance = attendanceType
        }
    }
    
    func proceedToNext() {
        guard let selectedDate = selectedDate,
              let selectedAttendance = selectedAttendance,
              !isPastDate else {
            print("입력 정보가 완전하지 않거나 유효하지 않은 날짜입니다.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        print("행사 날짜: \(dateFormatter.string(from: selectedDate))")
        print("참석 여부: \(selectedAttendance.rawValue)")
        showEventLocationView = true
    }
    
    // MARK: - Helper Methods
    func resetForm() {
        selectedDate = nil
        selectedAttendance = nil
        isDatePickerVisible = false
        isPastDate = false
    }
    
    func isAttendanceSelected(_ attendanceType: AttendanceType) -> Bool {
        selectedAttendance == attendanceType
    }
}

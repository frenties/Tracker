import UIKit

enum WeekDay: Int, CaseIterable {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
    init?(date: Date, calendar: Calendar = .current) {
        let weekDayComponent = calendar.component(.weekday, from: date)
        let systemSunday = 1
        let targetRawValue = weekDayComponent == systemSunday
            ? WeekDay.sunday.rawValue
            : weekDayComponent - 1
        self.init(rawValue: targetRawValue)
    }
    
    var localizedName: String {
        switch self {
        case .monday: String(localized: "weekday_monday")
        case .tuesday: String(localized: "weekday_tuesday")
        case .wednesday: String(localized: "weekday_wednesday")
        case .thursday: String(localized: "weekday_thursday")
        case .friday: String(localized: "weekday_friday")
        case .saturday: String(localized: "weekday_saturday")
        case .sunday: String(localized: "weekday_sunday")
        }
    }
    
    var shortLocalizedName: String {
        switch self {
        case .monday: String(localized: "weekday_short_monday")
        case .tuesday: String(localized: "weekday_short_tuesday")
        case .wednesday: String(localized: "weekday_short_wednesday")
        case .thursday: String(localized: "weekday_short_thursday")
        case .friday: String(localized: "weekday_short_friday")
        case .saturday: String(localized: "weekday_short_saturday")
        case .sunday: String(localized: "weekday_short_sunday")
        }
    }
}

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
    let isPinned: Bool
    
    init(
        id: UUID,
        name: String,
        color: UIColor,
        emoji: String,
        schedule: [WeekDay],
        isPinned: Bool = false
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.isPinned = isPinned
    }
}

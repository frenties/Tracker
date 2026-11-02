import UIKit

// MARK: - CreateTracker UI Constants
enum UIConstants {
    
    static let cellIdentifier = "OptionCell"
    static let inputCellIdentifier = "InputCell"
    static let menuCellIdentifier = "MenuCell"
    static let emojiCellIdentifier = "EmojiCell"
    static let colorCellIdentifier = "ColorCell"
    static let headerIdentifier = "CreateTrackerHeader"
    
    static let emojis: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"
    ]
    
    static let colors: [UIColor] = [
        UIColor(resource: .colorSelection1),
        UIColor(resource: .colorSelection2),
        UIColor(resource: .colorSelection3),
        UIColor(resource: .colorSelection4),
        UIColor(resource: .colorSelection5),
        UIColor(resource: .colorSelection6),
        UIColor(resource: .colorSelection7),
        UIColor(resource: .colorSelection8),
        UIColor(resource: .colorSelection9),
        UIColor(resource: .colorSelection10),
        UIColor(resource: .colorSelection11),
        UIColor(resource: .colorSelection12),
        UIColor(resource: .colorSelection13),
        UIColor(resource: .colorSelection14),
        UIColor(resource: .colorSelection15),
        UIColor(resource: .colorSelection16),
        UIColor(resource: .colorSelection17),
        UIColor(resource: .colorSelection18)
    ]
    
    static let titleWidth: CGFloat = 133
    static let titleHeight: CGFloat = 22
    static let textFieldHeight: CGFloat = 75
    static let textFieldPadding: CGFloat = 16
    static let errorLabelHeight: CGFloat = 22
    static let buttonWidth: CGFloat = 166
    static let buttonHeight: CGFloat = 60
    static let tableViewHeight: CGFloat = 150
    
    static let titleTopOffset: CGFloat = 38
    static let textFieldTopOffset: CGFloat = 38
    static let errorLabelTopOffset: CGFloat = 8
    static let buttonBottomOffset: CGFloat = -16
    static let buttonLeadingPadding: CGFloat = 20
    static let buttonTrailingPadding: CGFloat = -20
    static let tableViewTopDefaultOffset: CGFloat = 24
    static let tableViewTopErrorOffset: CGFloat = 62
    
    static let cornerRadius: CGFloat = 16
    static let leadingPadding: CGFloat = 16
    static let trailingPadding: CGFloat = -16
    
    static let itemsPerRow: CGFloat = 6
    static let itemHeight: CGFloat = 52
    static let sectionHeaderHeight: CGFloat = 18
    static let interItemSpacing: CGFloat = 5
    static let lineSpacing: CGFloat = 0
    
    static let inputCellHeight: CGFloat = 75
    static let menuCellHeight: CGFloat = 75
    
    static let maxTrackerNameLength = 38
    
    // MARK: - Localizable Strings (String Catalog)
    enum Strings {
        static let category = String(localized: "create_tracker_category")
        static let schedule = String(localized: "create_tracker_schedule")
        static let everyDay = String(localized: "create_tracker_every_day")
        static let emojiSectionTitle = String(localized: "create_tracker_emoji_section")
        static let colorSectionTitle = String(localized: "create_tracker_color_section")
    }
}

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
    
    // MARK: - Validation & Table Constants
    static let maxTrackerNameLength = 38
    static let optionsTableRowsCount = 2
    static let daysInWeekCount = 7
    static let categoryRowIndex = 0
    static let scheduleRowIndex = 1
    
    // MARK: - Onboarding Constants
    static let onboardingButtonBottomOffset: CGFloat = -50
    static let onboardingTitleBottomOffset: CGFloat = -160
    static let onboardingPageControlBottomOffset: CGFloat = -134
    static let onboardingTitleLeadingTrailingPadding: CGFloat = 16

    static let onboardingTitleFontSize: CGFloat = 32
    static let onboardingTitleLineHeight: CGFloat = 38
    static let onboardingPageControlAlpha: CGFloat = 0.3
    
    // MARK: - Category Screen Constants
    static let categoryButtonBottomOffset: CGFloat = -16
    static let categoryButtonHeight: CGFloat = 60
    static let categoryPlaceholderImageSize: CGFloat = 80
    static let categoryPlaceholderLabelTopOffset: CGFloat = 8
    static let categoryTableViewTopOffset: CGFloat = 24
    static let categoryTableViewBottomOffset: CGFloat = -24
    static let categoryPlaceholderFontSize: CGFloat = 12
    static let categoryPlaceholderLineSpacing: CGFloat = 4
    static let categoryPlaceholderNumberOfLines = 2
    static let categoryTitleFontSize: CGFloat = 16
    static let categoryTextFieldFontSize: CGFloat = 17
    static let categoryButtonFontSize: CGFloat = 16
    
    // MARK: - Localizable
    enum Strings {
        static let category = NSLocalizedString("create_tracker_category", comment: "Текст ячейки Категория")
        static let schedule = NSLocalizedString("create_tracker_schedule", comment: "Текст ячейки Расписание")
        static let everyDay = NSLocalizedString("create_tracker_every_day", comment: "Текст Каждый день для подзаголовка")
        static let emojiSectionTitle = "Emoji"
        static let colorSectionTitle = "Цвет"
        static let categoryPlaceholder = "Привычки и события можно\nобъединить по смыслу"
        static let addCategoryButtonTitle = "Добавить категорию"
        static let newCategoryTitle = "Новая категория"
        static let categoryNamePlaceholder = "Введите название категории"
        static let doneButtonTitle = "Готово"
    }
}

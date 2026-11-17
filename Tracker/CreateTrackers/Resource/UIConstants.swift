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
        Asset.colorSelection1.color,
        Asset.colorSelection2.color,
        Asset.colorSelection3.color,
        Asset.colorSelection4.color,
        Asset.colorSelection5.color,
        Asset.colorSelection6.color,
        Asset.colorSelection7.color,
        Asset.colorSelection8.color,
        Asset.colorSelection9.color,
        Asset.colorSelection10.color,
        Asset.colorSelection11.color,
        Asset.colorSelection12.color,
        Asset.colorSelection13.color,
        Asset.colorSelection14.color,
        Asset.colorSelection15.color,
        Asset.colorSelection16.color,
        Asset.colorSelection17.color,
        Asset.colorSelection18.color
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
    
    // MARK: - CreateTracker Screen Constants
    static let cancelButtonBorderWidth: CGFloat = 1
    static let scrollViewTopOffset: CGFloat = 24
    static let collectionViewTopOffset: CGFloat = 32
    static let collectionViewHeight: CGFloat = 460
    static let buttonsTopOffset: CGFloat = 16
    
    // MARK: - CreateTracker Collection Constants
    static let trackerCollectionSectionsCount = 2
    static let emojiSectionIndex = 0
    static let colorSectionIndex = 1
    static let collectionItemSize: CGFloat = 52
    static let collectionInterItemSpacing: CGFloat = 0
    static let collectionLineSpacing: CGFloat = 6
    static let collectionHeaderHeight: CGFloat = 34
    static let emojiSectionTopInset: CGFloat = 12
    static let colorSectionTopInset: CGFloat = 16
    static let collectionSectionBottomInset: CGFloat = 12
    
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
    
    // MARK: - CreateTracker Color Cell Constants
    static let colorViewCornerRadius: CGFloat = 8
    static let colorViewSize: CGFloat = 40
    static let colorCellCornerRadius: CGFloat = 12
    static let colorCellBorderWidth: CGFloat = 3
    static let colorCellSelectionAlpha: CGFloat = 0.3
    
    // MARK: - Tracker Card Cell Constants
    static let cardCornerRadius: CGFloat = 16
    static let cardBorderWidth: CGFloat = 1
    static let cardHeight: CGFloat = 90
    static let cardContentPadding: CGFloat = 12
    static let emojiBackgroundSize: CGFloat = 24
    static let emojiBackgroundCornerRadius: CGFloat = 12
    static let emojiBackgroundAlpha: CGFloat = 0.3
    static let emojiFontSize: CGFloat = 16
    static let cardTextFontSize: CGFloat = 12
    static let titleNumberOfLines = 2
    static let completeButtonTopOffset: CGFloat = 8
    static let completeButtonSize: CGFloat = 34
    static let completeButtonCornerRadius: CGFloat = 17
    
    // MARK: - Main Screen Constants
    static let mainTitleFontSize: CGFloat = 34
    static let mainSubtitleFontSize: CGFloat = 12
    static let datePickerCornerRadius: CGFloat = 8
    static let searchFieldCornerRadius: CGFloat = 10
    
    // MARK: - Main Screen Layout Constants
    static let mainTitleTopOffset: CGFloat = 88
    static let addButtonTopOffset: CGFloat = 45
    static let addButtonLeadingPadding: CGFloat = 6
    static let addButtonSize: CGFloat = 42
    static let searchFieldTopOffset: CGFloat = 136
    static let searchFieldHeight: CGFloat = 36
    static let collectionTopOffset: CGFloat = 16
    static let emptyStateImageCenterYOffset: CGFloat = 402
    
    // MARK: - Trackers Collection Constants
    static let trackersColumnsCount: CGFloat = 2
    static let trackersCellHeight: CGFloat = 148
    static let trackersInterItemSpacing: CGFloat = 9
    static let trackersSectionTopInset: CGFloat = 12
    static let trackersSectionBottomInset: CGFloat = 16
    static let trackersSectionRightInset: CGFloat = 16
    static let trackersHeaderHeight: CGFloat = 18
    static let completedButtonAlpha: CGFloat = 0.5
    static let defaultButtonAlpha: CGFloat = 1.0
    
    // MARK: - Statistic Screen Constants
    static let statisticCardsTopOffset: CGFloat = 77
    static let statisticStackSpacing: CGFloat = 12
    static let statisticCardHeight: CGFloat = 90
    static let statisticCardCornerRadius: CGFloat = 16
    static let statisticCardBorderWidth: CGFloat = 1
    static let statisticCardPadding: CGFloat = 12
    static let statisticCardInnerSpacing: CGFloat = 7
    static let statisticValueFontSize: CGFloat = 34
    static let statisticDescriptionFontSize: CGFloat = 12
    
    static let statisticGradientStartPoint = CGPoint(x: 0, y: 0.5)
    static let statisticGradientEndPoint = CGPoint(x: 1, y: 0.5)
    static let statisticBorderInsetDivisor: CGFloat = 2
    
    static let editDaysCountFontSize: CGFloat = 32
    static let editTextFieldTopOffset: CGFloat = 40
    
    // MARK: - Filters Screen Constants
    static let filtersButtonWidth: CGFloat = 114
    static let filtersButtonHeight: CGFloat = 50
    static let filtersButtonBottomOffset: CGFloat = -16
    static let collectionBottomInsetWithFilters: CGFloat = 80
    
    // MARK: - Localizable Strings (String Catalog)
    enum Strings {
        static let category = String(localized: "create_tracker_category")
        static let schedule = String(localized: "create_tracker_schedule")
        static let everyDay = String(localized: "create_tracker_every_day")
        static let emojiSectionTitle = String(localized: "create_tracker_emoji_section")
        static let colorSectionTitle = String(localized: "create_tracker_color_section")
        
        static let categoryPlaceholder = String(localized: "category_placeholder")
        static let addCategoryButtonTitle = String(localized: "add_category_button")
        static let newCategoryTitle = String(localized: "new_category_title")
        static let categoryNamePlaceholder = String(localized: "category_name_placeholder")
        static let doneButtonTitle = String(localized: "done_button")
        
        static let newHabitTitle = String(localized: "new_habit_title")
        static let trackerNamePlaceholder = String(localized: "tracker_name_placeholder")
        static let cancelButtonTitle = String(localized: "cancel_button")
        static let createButtonTitle = String(localized: "create_button")
        static let nameLengthError = String(localized: "name_length_error")
    }
}

import Foundation
import UIKit

// MARK: - CreateTracker UI Constants
enum UIConstants {
    
    enum Strings {
           static let category = NSLocalizedString("create_tracker_category", comment: "Текст ячейки Категория")
           static let schedule = NSLocalizedString("create_tracker_schedule", comment: "Текст ячейки Расписание")
           static let everyDay = NSLocalizedString("create_tracker_every_day", comment: "Текст Каждый день для подзаголовка")
       }
       
    static let cellIdentifier: String = "OptionCell"
    
    static let textFieldHeight: CGFloat = 75
    static let tableViewHeight: CGFloat = 150
    static let textFieldPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 16
    
    static let buttonWidth: CGFloat = 166
    static let buttonHeight: CGFloat = 60
    static let titleWidth: CGFloat = 133
    static let titleHeight: CGFloat = 22
    static let errorLabelHeight: CGFloat = 22
    
    static let leadingPadding: CGFloat = 16
    static let trailingPadding: CGFloat = -16
    static let buttonLeadingPadding: CGFloat = 20
    static let buttonTrailingPadding: CGFloat = -20
    
    static let titleTopOffset: CGFloat = 38
    static let textFieldTopOffset: CGFloat = 38
    static let errorLabelTopOffset: CGFloat = 8
    static let buttonBottomOffset: CGFloat = -16
    
    static let tableViewTopDefaultOffset: CGFloat = 24
    static let tableViewTopErrorOffset: CGFloat = 62
}


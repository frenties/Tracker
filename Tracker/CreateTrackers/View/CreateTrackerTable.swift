import UIKit

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CreateTrackerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UIConstants.optionsTableRowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: UIConstants.cellIdentifier)
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: UIConstants.categoryTextFieldFontSize, weight: .regular)
        cell.textLabel?.textColor = UIColor(resource: .blackDay)
        
        if indexPath.row == UIConstants.categoryRowIndex {
            cell.textLabel?.text = UIConstants.Strings.category
            if !selectedCategoryTitle.isEmpty {
                cell.detailTextLabel?.text = selectedCategoryTitle
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: UIConstants.categoryTextFieldFontSize, weight: .regular)
                cell.detailTextLabel?.textColor = UIColor(resource: .gray)
            } else {
                cell.detailTextLabel?.text = nil
            }
        } else {
            cell.textLabel?.text = UIConstants.Strings.schedule
            
            if !selectedDays.isEmpty {
                cell.detailTextLabel?.text = formatSelectedDays(selectedDays)
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: UIConstants.categoryTextFieldFontSize, weight: .regular)
                cell.detailTextLabel?.textColor = UIColor(resource: .gray)
            } else {
                cell.detailTextLabel?.text = nil
            }
        }
        
        let chevronImageView = UIImageView(image: UIImage(resource: .chevron))
        chevronImageView.tintColor = UIColor(resource: .grayYP)
        cell.accessoryView = chevronImageView
        
        if indexPath.row == UIConstants.scheduleRowIndex {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: UIConstants.leadingPadding,
                bottom: 0,
                right: UIConstants.leadingPadding
            )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.menuCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == UIConstants.categoryRowIndex {
            guard let trackerCategoryStore = TrackerCategoryStore.makeDefaultStore() else { return }
            
            let categoryListViewModel = CategoryListViewModel(trackerCategoryStore: trackerCategoryStore)
            
            categoryListViewModel.onCategorySelected = { [weak self] categoryTitle in
                guard let self else { return }
                self.selectedCategoryTitle = categoryTitle
                self.optionsTableView.reloadData()
                self.validateForm()
            }
            
            let categoryVC = CategoryViewController(viewModel: categoryListViewModel)
            categoryVC.selectedCategoryTitle = self.selectedCategoryTitle
            
            if let navigationController = navigationController {
                navigationController.pushViewController(categoryVC, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: categoryVC)
                present(navController, animated: true, completion: nil)
            }
            
        } else if indexPath.row == UIConstants.scheduleRowIndex {
            let scheduleVC = ScheduleViewController()
            scheduleVC.delegate = self
            
            scheduleVC.currentSelectedDays = Set(self.selectedDays)
            present(scheduleVC, animated: true, completion: nil)
        }
    }
}

// MARK: - ScheduleViewControllerDelegate
extension CreateTrackerViewController: ScheduleViewControllerDelegate {
    func didUpdateSchedule(_ selectedDays: [WeekDay]) {
        self.selectedDays = selectedDays
        self.optionsTableView.reloadData()
        
        validateForm()
    }
}

// MARK: - UITextFieldDelegate
extension CreateTrackerViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        self.trackerName = updatedText
        
        if updatedText.count > UIConstants.maxTrackerNameLength {
            errorLabel.isHidden = false
            optionsTableViewTopConstraint?.constant = UIConstants.tableViewTopErrorOffset
            
            if currentText.count == UIConstants.maxTrackerNameLength && !string.isEmpty {
                return false
            }
        } else {
            errorLabel.isHidden = true
            optionsTableViewTopConstraint?.constant = UIConstants.tableViewTopDefaultOffset
        }
        
        validateForm()
        return true
    }
}

// MARK: - Private Methods
private extension CreateTrackerViewController {
    
    func formatSelectedDays(_ days: [WeekDay]) -> String {
        if days.count == UIConstants.daysInWeekCount {
            return UIConstants.Strings.everyDay
        }
        
        let shortNames = days.map { day -> String in
            switch day {
            case .monday: return "Пн"
            case .tuesday: return "Вт"
            case .wednesday: return "Ср"
            case .thursday: return "Чт"
            case .friday: return "Пт"
            case .saturday: return "Сб"
            case .sunday: return "Вс"
            }
        }
        return shortNames.joined(separator: ", ")
    }
}

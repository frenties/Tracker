import Foundation
import UIKit

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CreateTrackerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "OptionCell") {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "OptionCell")
        }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.textLabel?.textColor = UIColor(resource: .blackDay)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = nil
        } else {
            cell.textLabel?.text = "Расписание"
            
            
            if !selectedDays.isEmpty {
                
                if selectedDays.count == 7 {
                    cell.detailTextLabel?.text = "Каждый день"
                } else {
                    let shortNames = selectedDays.map { day -> String in
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
                    cell.detailTextLabel?.text = shortNames.joined(separator: ", ")
                }
                
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                cell.detailTextLabel?.textColor = .gray
            } else {
                cell.detailTextLabel?.text = nil
            }
        }
        
        let chevronImageView = UIImageView(image: UIImage(resource: .chevron))
        chevronImageView.tintColor = UIColor(resource: .grayYP)
        cell.accessoryView = chevronImageView
        
        if indexPath.row == 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10000)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
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
    }
}

// MARK: - UITextFieldDelegate
extension CreateTrackerViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count > 38 {
            errorLabel.isHidden = false
            optionsTableViewTopConstraint?.constant = 62
            
            if currentText.count == 38 && !string.isEmpty {
                return false
            }
        } else {
            errorLabel.isHidden = true
            optionsTableViewTopConstraint?.constant = 24
        }
        
        return true
    }
}

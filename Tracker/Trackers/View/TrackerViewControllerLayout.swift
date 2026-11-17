import UIKit

extension TrackerViewController {
    
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.mainTitleTopOffset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingPadding)
        ])
    }
    
    func setupAddButton() {
        view.addSubview(addTrackerButton)
        
        NSLayoutConstraint.activate([
            addTrackerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.addButtonTopOffset),
            addTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.addButtonLeadingPadding),
            addTrackerButton.widthAnchor.constraint(equalToConstant: UIConstants.addButtonSize),
            addTrackerButton.heightAnchor.constraint(equalToConstant: UIConstants.addButtonSize)
        ])
    }
    
    func setupDatePicker() {
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.trailingPadding)
        ])
    }
    
    func setupSearchTextField() {
        view.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.searchFieldTopOffset),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingPadding),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.trailingPadding),
            searchTextField.heightAnchor.constraint(equalToConstant: UIConstants.searchFieldHeight)
        ])
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: UIConstants.collectionTopOffset),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.leadingPadding),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.trailingPadding),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupBackgroundImage() {
        view.addSubview(backgroundImage)
        
        NSLayoutConstraint.activate([
            backgroundImage.widthAnchor.constraint(equalToConstant: UIConstants.categoryPlaceholderImageSize),
            backgroundImage.heightAnchor.constraint(equalToConstant: UIConstants.categoryPlaceholderImageSize),
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.centerYAnchor.constraint(equalTo: view.topAnchor, constant: UIConstants.emptyStateImageCenterYOffset)
        ])
    }
    
    func setupSubtitleLabel() {
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: UIConstants.categoryPlaceholderLabelTopOffset),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupFiltersButton() {
        view.addSubview(filtersButton)
        
        NSLayoutConstraint.activate([
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIConstants.filtersButtonBottomOffset),
            filtersButton.widthAnchor.constraint(equalToConstant: UIConstants.filtersButtonWidth),
            filtersButton.heightAnchor.constraint(equalToConstant: UIConstants.filtersButtonHeight)
        ])
    }
}

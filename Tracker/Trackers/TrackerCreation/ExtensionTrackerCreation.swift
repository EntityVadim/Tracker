//
//  ExtensionTrackerCreation.swift
//  Tracker
//
//  Created by Вадим on 16.08.2024.
//

import UIKit

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TrackerCreationViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return collectionView == emojiCollectionView ? emojis.count : colors.count
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == emojiCollectionView {
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EmojiCell.reuseIdentifier,
                    for: indexPath) as? EmojiCell {
                    let emoji = emojis[indexPath.item]
                    let isSelected = emoji == selectedEmoji
                    cell.configure(with: emoji, isSelected: isSelected)
                    return cell
                } else {
                    return UICollectionViewCell()
                }
            } else {
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ColorCell.reuseIdentifier,
                    for: indexPath) as? ColorCell {
                    let color = colors[indexPath.item]
                    let isSelected = color == selectedColor
                    cell.configure(with: color, isSelected: isSelected)
                    return cell
                } else {
                    return UICollectionViewCell()
                }
            }
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.bounds.width) / 6
            return CGSize(width: width, height: width)
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
            if collectionView == emojiCollectionView {
                selectedEmoji = emojis[indexPath.item]
            } else {
                selectedColor = colors[indexPath.item]
            }
            collectionView.reloadData()
            updateSaveButtonState()
        }
}

//
//  NotesTableViewHeaderCell.swift
//  Notes
//
//  Created by Андрей on 11.03.2025.
//

import Foundation
import UIKit

final class NotesTableViewHeaderCell: UITableViewHeaderFooterView {
    
    lazy var label = makeLabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(
            origin: CGPoint(
                x: Constants.labelX,
                y: Constants.labelY),
            size: CGSize(
                width: bounds.width,
                height: Constants.labelHeight))
    }
    
    func configure(text: String) {
        label.text = text
    }
}

//MARK: - Private methods
extension NotesTableViewHeaderCell {
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(label)
    }
    
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.font = Constants.labelFont
        
        return label
    }
}

private enum Constants {
    static let labelFont = UIFont.boldSystemFont(ofSize: 20)
    static let labelX: CGFloat = 0
    static let labelY: CGFloat = -40
    static let labelHeight: CGFloat = 50
}

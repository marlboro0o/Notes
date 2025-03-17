//
//  TableViewCell.swift
//  Notes
//
//  Created by Андрей on 05.02.2025.
//

import UIKit

final class NotesTableViewCell: UITableViewCell {
    
    private lazy var containerView = UIView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var contentLabel = makeContentLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.frame = CGRect(
            origin: CGPoint(
                x: bounds.minX + Constants.titleX,
                y: bounds.minY + Constants.titleY),
            size: Constants.titleSize)
        
        containerView.frame = CGRect(
            origin: CGPoint(
                x: Constants.containerViewX,
                y: Constants.containerViewY),
            size: CGSize(
                width: contentView.bounds.width,
                height: contentView.bounds.height))
        
        contentLabel.frame = CGRect(
            origin: CGPoint(
                x: titleLabel.bounds.minX + Constants.bodyX,
                y: titleLabel.bounds.maxY + Constants.bodyY),
            size: Constants.bodySize)
    }
    
    func configure(state: NotesTableViewState) {
        titleLabel.text = state.title
        contentLabel.text = "\(state.dateCell) \(state.textBody)"
    }
    
    func roundCorners(for position: CellPosition) {
        let maskPath: UIBezierPath
        
        switch position {
        case .top:
            maskPath = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: CGSize(width: 10, height: 10))
        case .bottom:
            maskPath = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.bottomLeft, .bottomRight],
                cornerRadii: CGSize(width: 10, height: 10))
        case .single:
            maskPath = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.allCorners],
                cornerRadii: CGSize(width: 10, height: 10))
        case .middle:
            layer.mask = nil
            return
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}

//MARK: - PrivateMethods
extension NotesTableViewCell {
    
    private func setupUI() {
        backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = Constants.titleFont
        
        return label
    }
    
    private func makeContentLabel() -> UILabel {
        let label = UILabel()
        label.font = Constants.bodyFont
        label.textColor = .gray
        
        return label
    }
}

//MARK: - Constants
extension NotesTableViewCell {
    private enum Constants {
        static let titleSize: CGSize = CGSize(width: 250, height: 40)
        static let bodySize: CGSize = CGSize(width: 300, height: 40)
        static let titleFont: UIFont = UIFont.boldSystemFont(ofSize: 18)
        static let bodyFont: UIFont = UIFont.systemFont(ofSize: 16)
        static let titleX: CGFloat = 25
        static let titleY: CGFloat = 5
        static let bodyX: CGFloat = 25
        static let bodyY: CGFloat = -3
        static let containerViewX: CGFloat = 0
        static let containerViewY: CGFloat = 0
    }
}

enum CellPosition {
    case top
    case bottom
    case single
    case middle
}

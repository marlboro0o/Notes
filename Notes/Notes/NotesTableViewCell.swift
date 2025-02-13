//
//  TableViewCell.swift
//  Notes
//
//  Created by Андрей on 05.02.2025.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    private lazy var containerView = makeContainerView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var contentLabel = makeContentLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(state: NoteViewState) {
        titleLabel.text = state.title
        contentLabel.text = state.content
    }
    
    private func setupUI() {
        backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
    }
    
    private func makeContainerView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height))
        
        return view
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 25, y: 5, width: Int(containerView.bounds.width) - 40, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        return label
    }
    
    private func makeContentLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 25, y: 35, width: Int(containerView.bounds.width) - 40, height: 40))
        label.textColor = .gray
        
        return label
    }
}

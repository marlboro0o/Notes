//
//  NoteViewController.swift
//  Notes
//
//  Created by Андрей on 25.12.2024.
//

import UIKit
import Combine

final class NotesTableViewController: UIViewController {
    
    private let viewModel: NotesTablePresenting
    private let router: NotesRouter
    private var cancellable: Set<AnyCancellable> = []
    private lazy var headLabel = makeLabelHead()
    private lazy var searchTextField = makeSearchTextField()
    private lazy var tableView = makeTableView()
    private lazy var footerView = makeFooterView()
    private lazy var newNoteButton = makeNewNoteButton()
    
    init(viewModel: NotesTablePresenting, router: NotesRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        headLabel.frame = .init(
            origin: .init(
                x: view.bounds.minX + Constants.headerLabelX,
                y: view.bounds.minY + Constants.headerLabelY),
            size: CGSize(
                width: self.view.frame.width / 2,
                height: 50))
        
        searchTextField.frame = .init(
            origin: .init(
                x: view.bounds.minX + Constants.searchTextFieldX,
                y: headLabel.frame.maxY + Constants.searchTextFieldY),
            size: CGSize(
                width: view.bounds.width - 40,
                height: 40))

        tableView.frame = CGRect(
            origin: CGPoint(
                x: view.bounds.minX + Constants.tableViewX,
                y: searchTextField.frame.maxY + Constants.tableViewY),
            size: CGSize(
                width: Int(view.bounds.width) + Constants.tableViewWidth,
                height: Int(view.bounds.height) - Int(searchTextField.frame.maxY + Constants.tableViewY) - 70))
        
        footerView.frame = .init(
            origin: .init(
                x: view.bounds.minX + Constants.footerViewX,
                y: view.bounds.maxY + Constants.footerViewY),
            size: CGSize(
                width: Int(view.frame.width),
                height: 100))
        
        newNoteButton.frame = .init(
            origin: .init(
                x: footerView.bounds.maxX + Constants.newNoteButtonX,
                y: footerView.bounds.minY + Constants.newNoteButtonY),
            size: CGSize(
                width: 30,
                height: 30))
    }
    
}

// MARK: - TableViewDataSource
extension NotesTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.viewState.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NotesTableViewCell
        else {
            assertionFailure("Всегда должен быть айтем на индексе")
            return UITableViewCell()
        }
        
        if let state = viewModel.viewState[safe: indexPath.row] {
            cell.configure(state: state)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(Constants.tableViewHeight)
    }
}

// MARK: - TableViewDelegate
extension NotesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        makeActionConfiguration(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didTapOpenNote(for: indexPath.row)
    }
}

// MARK: - Private methods
extension NotesTableViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemGray5
        view.addSubview(headLabel)
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(newNoteButton)
    }
    
    private func bind() {
        viewModel.viewStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard
                    let self,
                    value
                else {
                    return
                }
                tableView.reloadData()
            }
            .store(in: &cancellable)
        
        viewModel.configPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard 
                    let self,
                    let navigationController
                else {
                    return
                }
                    router.openNote(navigation: navigationController, viewModel: viewModel, config: value)
                
            }
            .store(in: &cancellable)
    }
    
    private func makeLabelHead() -> UILabel {
        let label = UILabel()
        label.text = "Заметки"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        
        return label
    }
    
    private func makeSearchTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Поиск"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = .systemGray4
        
        let icon = UIImage(systemName: "magnifyingglass")
        let iconView = UIImageView(image: icon)
        iconView.tintColor = .gray
        iconView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftView.addSubview(iconView)
        
        textField.leftView = leftView
        textField.leftViewMode = .always
       
        return textField
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: "NoteCell")
        
        return tableView
    }
    
    private func makeFooterView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }
    
    private func makeNewNoteButton() -> UIButton {
        
        let button = UIButton(type: .detailDisclosure)
        
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .orange
        button.addTarget(self, action: #selector(didTapNewNote), for: .touchUpInside)
        
        return button
    }
    
    private func makeActionConfiguration(indexPath: IndexPath) -> UISwipeActionsConfiguration {
        
        let deletedAction = UIContextualAction(style: .destructive, title: "Delete") {
            (_, _, _)  in
            print("delete")
        }
        
        return UISwipeActionsConfiguration(actions: [deletedAction])
    }
    
    private func setTableViewFrame() {
        tableView.frame = .init(
            origin: .init(
                x: view.bounds.minX + Constants.tableViewX,
                y: searchTextField.frame.maxY + Constants.tableViewY),
            size: CGSize(
                width: Int(view.bounds.width) + Constants.tableViewWidth,
                height: viewModel.viewState.count * Constants.tableViewHeight))
    }
    
    @objc private func didTapNewNote() {
        viewModel.didTapAddNote()
    }
}

//MARK: - Constants
extension NotesTableViewController {
    private enum Constants {
        static let tableViewWidth: Int = -40
        static let tableViewHeight: Int = 80
        static let headerLabelX: CGFloat = 20
        static let headerLabelY: CGFloat = 80
        static let searchTextFieldX: CGFloat = 20
        static let searchTextFieldY: CGFloat = 10
        static let tableViewX: CGFloat = 20
        static let tableViewY: CGFloat = 20
        static let footerViewX: CGFloat = 0
        static let footerViewY: CGFloat = -100
        static let newNoteButtonX: CGFloat = -50
        static let newNoteButtonY: CGFloat = 15
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

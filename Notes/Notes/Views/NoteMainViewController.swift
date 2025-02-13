//
//  NoteViewController.swift
//  Notes
//
//  Created by Андрей on 25.12.2024.
//

import UIKit
import Combine

final class NoteMainViewController: UIViewController {
    
    private let viewModel: NotePresenting
    private var cancellable: Set<AnyCancellable> = []
    private var viewState: [NoteViewState] = []
    private lazy var headLabel = makeLabelHead()
    private lazy var searchTextField = makeSearchTextField()
    private lazy var tableView = makeTableView()
    private lazy var footerView = makeFooterView()
    private lazy var newNoteButton = makeNewNoteButton()
    
    init(viewModel: NotePresenting) {
        self.viewModel = viewModel
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
}

// MARK: - TableViewDataSource
extension NoteMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewState.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NotesTableViewCell else { return UITableViewCell() }
        
        if let state = viewState[safe: indexPath.row] {
            cell.configure(state: state)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

// MARK: - TableViewDelegate
extension NoteMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        makeActionConfiguration(indexPath: indexPath)
    }
}

// MARK: - Private methods
extension NoteMainViewController {
    
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
            .sink(receiveValue: { [weak self] values in
                if let self = self {
                    self.viewState = values
                    self.tableView.reloadData()
                    self.tableView.frame = CGRect(origin: self.tableView.frame.origin, size: CGSize(width: Int(self.tableView.bounds.width), height: values.count * 80))
                }
            })
            .store(in: &cancellable)
    }
    
    private func makeLabelHead() -> UILabel {
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 20, y: 80), size: CGSize(width: self.view.frame.width / 2, height: 50)))
        label.text = "Заметки"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        
        return label
    }
    
    private func makeSearchTextField() -> UITextField {
        let textField = UITextField(frame: CGRect(x: 20, y: 140, width: view.bounds.width - 40, height: 40))
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
        let tableView = UITableView(frame: CGRect(x: 20, y: 200, width: view.bounds.width - 40, height: 50))
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: "NoteCell")
        
        return tableView
    }
    
    private func makeFooterView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: Int(view.frame.height) - 100, width: Int(view.frame.width), height: 100))
        view.backgroundColor = .systemGray5
        return view
    }
    
    private func makeNewNoteButton() -> UIButton {
        
        let sizeButton = 30
        let button = UIButton(type: .detailDisclosure)
        button.frame = CGRect(x: Int(view.bounds.width) - sizeButton - 20, y: 15, width: sizeButton, height: sizeButton)
        
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
    
    @objc private func didTapNewNote() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Заметки", style: .plain, target: nil, action: nil)
        NotesRouter.openNote(navigation: navigationController, viewModel: viewModel)
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//
//  NoteViewController.swift
//  Notes
//
//  Created by Андрей on 25.12.2024.
//

import UIKit
import Combine

final class NoteMainViewController: UIViewController {
    
    private let viewModel: NoteMainPresenting
    private var cancellable: Set<AnyCancellable> = []
    private var viewState: [NoteMainViewState] = []
    private lazy var headLabel = makeLabelHead()
    private lazy var searchTextField = makeSearchTextField()
    private lazy var tableView = makeTableView()
    private lazy var footerView = makeFooterView()
    private lazy var newNoteButton = makeNewNoteButton()
    
    init(viewModel: NoteMainPresenting) {
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
    
    override func viewIsAppearing(_ animated: Bool) {
        headLabel.frame = .init(
            origin: .init(
                x: view.bounds.minX + 20,
                y: view.bounds.minY + 80),
            size: CGSize(width: self.view.frame.width / 2, height: 50))
        
        searchTextField.frame = .init(
            origin: .init(
                x: view.bounds.minX + 20,
                y: headLabel.frame.maxY + 10),
            size: CGSize(width: view.bounds.width - 40, height: 40))

        tableView.frame = .init(
            origin: .init(
                x: view.bounds.minX + 20,
                y: searchTextField.frame.maxY + 20),
            size: CGSize(width: Int(view.bounds.width) - 40, height: viewState.count * 80))
        
        footerView.frame = .init(
            origin: .init(
                x: view.bounds.minX,
                y: view.bounds.maxY - 100),
            size: CGSize(width: Int(view.frame.width), height: 100))
        
        newNoteButton.frame = .init(
            origin: .init(
                x: footerView.bounds.maxX - 50,
                y: footerView.bounds.minY + 15),
            size: CGSize(width: 30, height: 30))
    }
    
}

// MARK: - TableViewDataSource
extension NoteMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewState.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NotesTableViewCell
        else {
            assertionFailure("Всегда должен быть айтем на индексе")
            return UITableViewCell()
        }
        
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
            .sink { [weak self] values in
                if let self = self {
                    self.viewState = values
                    self.tableView.reloadData()
                    self.tableView.frame.size = .init(
                        width: Int(view.bounds.width) - 40,
                        height: viewState.count * 80)
                   }
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
    
    @objc private func didTapNewNote() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Заметки", style: .plain, target: nil, action: nil)
        
        guard let navigationController else { return }
        viewModel.openNote(navigation: navigationController)
        //NotesRouter.openNote(navigation: navigationController, viewModel: viewModel)
    }
}

//MARK: - Constants
extension NoteMainViewController {
    private enum Constants {
        static let tableSizeWidth: Int = -40
        static let tableHeight: Int = 80
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

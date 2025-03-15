//
//  NoteNewNoteViewController.swift
//  Notes
//
//  Created by Андрей on 07.02.2025.
//

import UIKit
import Combine

class NoteViewController: UIViewController {
    private let viewModel: NotePresenting
    private lazy var noteTextView = makeNoteTextView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: NotePresenting) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Заметки", style: .plain, target: nil, action: nil)
        
        view.backgroundColor = .white
        view.addSubview(noteTextView)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(swipeView))
        view.addGestureRecognizer(gesture)
        
        bind()
        viewModel.viewDidLoad()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        noteTextView.frame = CGRect(
            origin:
                CGPoint(
                    x: Constants.noteTextViewX,
                    y: Constants.noteTextViewY),
            size: CGSize(
                width: view.bounds.width,
                height: view.bounds.height + Constants.noteTextViewHeight))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !noteTextView.text.isEmpty {
            viewModel.saveNote(for: noteTextView.text)
        }
    }
}

//MARK: - Pivate methods
extension NoteViewController {
    
    private func makeNoteTextView() -> UITextView {
        let textView = UITextView()
        textView.font = Constants.textBodyFont
        textView.isScrollEnabled = true
        textView.delegate = self
        return textView
    }
    
    private func bind() {
        viewModel.viewStatePublisher
            .sink { [weak self] value in
                guard
                    let self,
                    let viewState = value
                else {
                    return
                }
                noteTextView.text = viewState.textBody
                updateTextViewStyle()
            }.store(in: &cancellables)
    }
    
    private func updateTextViewStyle() {
        guard 
            let text = noteTextView.text,
            !text.isEmpty 
        else {
            return
        }
        
        let lines = text.components(separatedBy: .newlines)
        let attributedString = NSMutableAttributedString(string: text)
        
        let firstLineRange = (text as NSString).range(of: lines[0])
        attributedString.addAttributes([
            .font: Constants.titleFont,
            .foregroundColor: UIColor.label
        ], range: firstLineRange)
        
        let remainingTextRange = NSRange(location: firstLineRange.length, length: text.count - firstLineRange.length)
        attributedString.addAttributes([
            .font: Constants.textBodyFont,
            .foregroundColor: UIColor.label
        ], range: remainingTextRange)
        
        noteTextView.attributedText = attributedString
    }
    
    
    @objc private func swipeView(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        
        switch
        recognizer.state {
        case .began:
            print("began \(translation.x)")
        case .changed:
            print("changed \(translation.x)")
        case .ended:
            print("ended")
        default: return
        }
    }
}

//MARK: - TextViewDelegate
extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewStyle()
    }
}

//MARK: - Constants
private enum Constants {
    static let titleFont: UIFont = UIFont.systemFont(ofSize: 24, weight: .bold)
    static let textBodyFont: UIFont = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let noteTextViewX: CGFloat = 20
    static let noteTextViewY: CGFloat = 100
    static let noteTextViewHeight: CGFloat = -40
}


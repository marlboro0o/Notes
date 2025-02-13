//
//  NoteNewNoteViewController.swift
//  Notes
//
//  Created by Андрей on 07.02.2025.
//

import UIKit

class NoteViewController: UIViewController {
   
    private let viewModel: NotePresenting
    private lazy var noteTextView = makeNoteTextView()
    
    init(viewModel: NotePresenting) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(noteTextView)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(swipeView))
        view.addGestureRecognizer(gesture)
        
        updateTextViewStyle()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !noteTextView.text.isEmpty {
            viewModel.createNote(text: noteTextView.text)
        }
    }
    
    private func makeNoteTextView() -> UITextView {
        let textView = UITextView(frame: CGRect(x: 20, y: 100, width: view.bounds.width, height: view.bounds.height - 40))
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isScrollEnabled = true
        textView.delegate = self
        return textView
    }
    
    private func updateTextViewStyle() {
        guard let text = noteTextView.text else { return }
        
        let lines = text.components(separatedBy: .newlines)
        let attributedString = NSMutableAttributedString(string: text)
        
        let firstLineRange = (text as NSString).range(of: lines[0])
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.label
        ], range: firstLineRange)
        
        let remainingTextRange = NSRange(location: firstLineRange.length, length: text.count - firstLineRange.length)
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 17, weight: .regular),
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

extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewStyle()
    }
}


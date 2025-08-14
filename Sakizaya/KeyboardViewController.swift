//
//  KeyboardViewController.swift
//  Sakizaya
//
//  Created by 蘇炫瑋 on 2025/6/10.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    var deleteButton: UIButton!
    var spaceButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // 設置鍵盤高度
        let heightConstraint = NSLayoutConstraint(
            item: self.view!,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 0.0,
            constant: 216.0
        )
        self.view.addConstraint(heightConstraint)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }
    
    func setupKeyboard() {
        // 創建主要容器視圖
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemGray3
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // 設置容器視圖約束
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupButtons(in: containerView)
        setupLayout()
    }
    
    func setupButtons(in containerView: UIView) {
        // 創建切換鍵盤按鈕
        
        // 創建刪除按鈕
        deleteButton = UIButton(type: .system)
        deleteButton.setTitle("⌫",for: .normal)
        deleteButton.setTitleColor(.label,for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        deleteButton.backgroundColor = UIColor.systemGray2
        deleteButton.layer.cornerRadius = 5
        deleteButton.addTarget(self, action: #selector(deleteBackward), for: .touchUpInside)
        
        // 創建空格鈕
        spaceButton = UIButton(type: .system)
        spaceButton.setTitle("space", for: .normal)
        spaceButton.setTitleColor(.label, for: .normal)
        spaceButton.backgroundColor = UIColor.systemBackground
        spaceButton.layer.cornerRadius = 5
        spaceButton.addTarget(self, action: #selector(insertSpace), for: .touchUpInside)
        
        // 添加到容器視圖
        [deleteButton, spaceButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        // 創建字母按鈕
        createLetterButtons(in: containerView)
    }
    
    func createLetterButtons(in containerView: UIView) {
        let letters = [
            ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
            ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
            ["Z", "X", "C", "V", "B", "N", "M"]
        ]
        
        var previousRowView: UIView?
        
        for (_, row) in letters.enumerated() {
            let rowView = UIView()
            rowView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(rowView)
            
            // 設置行約束
            NSLayoutConstraint.activate([
                rowView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
                rowView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                rowView.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            if let previousRow = previousRowView {
                rowView.topAnchor.constraint(equalTo: previousRow.bottomAnchor, constant: 8).isActive = true
            } else {
                rowView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
            }
            
            // 創建該行的按鈕
            var buttons: [UIButton] = []
            for letter in row {
                let button = UIButton(type: .system)
                button.setTitle(letter, for: .normal)
                button.setTitleColor(.label, for: .normal)
                button.backgroundColor = UIColor.systemBackground
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.systemGray3.cgColor
                button.addTarget(self, action: #selector(letterButtonTapped(_:)), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                buttons.append(button)
                rowView.addSubview(button)
            }
            
            // 設置按鈕約束
            for (index, button) in buttons.enumerated() {
                button.topAnchor.constraint(equalTo: rowView.topAnchor).isActive = true
                button.bottomAnchor.constraint(equalTo: rowView.bottomAnchor).isActive = true
                
                if index == 0 {
                    button.leadingAnchor.constraint(equalTo: rowView.leadingAnchor).isActive = true
                } else {
                    button.leadingAnchor.constraint(equalTo: buttons[index-1].trailingAnchor, constant: 6).isActive = true
                    button.widthAnchor.constraint(equalTo: buttons[0].widthAnchor).isActive = true
                }
                
                if index == buttons.count - 1 {
                    button.trailingAnchor.constraint(equalTo: rowView.trailingAnchor).isActive = true
                }
            }
            
            previousRowView = rowView
        }
    }
    
    func setupLayout() {
        // 設置底部按鈕約束
        NSLayoutConstraint.activate([
            
            // 空格按鈕
            spaceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spaceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            spaceButton.widthAnchor.constraint(equalToConstant: 200),
            spaceButton.heightAnchor.constraint(equalToConstant: 40),
            
            // 刪除按鈕
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            deleteButton.widthAnchor.constraint(equalToConstant: 50),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - 按鈕事件處理
    
    @objc func letterButtonTapped(_ sender: UIButton) {
        guard let letter = sender.title(for: .normal) else { return }
        textDocumentProxy.insertText(letter.lowercased())
    }
    
    @objc func insertSpace() {
        textDocumentProxy.insertText(" ")
    }
    
    @objc func deleteBackward() {
        textDocumentProxy.deleteBackward()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // 文字將要改變時調用
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // 文字已改變時調用 - 可以在這裡實現智能提示等功能
    }
}

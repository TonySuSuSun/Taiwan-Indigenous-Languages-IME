//
//  KeyboardViewController.swift
//  Amis
//
//  Created by 蘇炫瑋 on 2025/6/10.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    func createButtonWithTitle(title: String) -> UIButton {

        let button = UIButton.init(type: .system)
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setTitle(title, for: .normal)
        button.sizeToFit()
        button.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.darkGray, for: .normal)

        button.addTarget(self, action: "didTapButton:", for: .touchUpInside)

        return button
    }

    func didTapButton(sender: AnyObject?) {

        let button = sender as! UIButton

        var proxy = textDocumentProxy

        if let title = button.title(for: .normal) as String? {
            switch title {
            case "BP":
                proxy.deleteBackward()
            case "RETURN":
                proxy.insertText("\n")
            case "SPACE":
                proxy.insertText(" ")
            case "CHG":
                self.advanceToNextInputMode()
            default:
                proxy.insertText(title)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let buttonTitles1 = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        let buttonTitles2 = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
        let buttonTitles3 = ["CP", "Z", "X", "C", "V", "B", "N", "M", "BP"]
        let buttonTitles4 = ["CHG", "SPACE", "RETURN"]

        var row1 = createRowOfButtons(buttonTitles: buttonTitles1)
        var row2 = createRowOfButtons(buttonTitles: buttonTitles2)
        var row3 = createRowOfButtons(buttonTitles: buttonTitles3)
        var row4 = createRowOfButtons(buttonTitles: buttonTitles4)

        self.view.addSubview(row1)
        self.view.addSubview(row2)
        self.view.addSubview(row3)
        self.view.addSubview(row4)

        row1.translatesAutoresizingMaskIntoConstraints = false
        row2.translatesAutoresizingMaskIntoConstraints = false
        row3.translatesAutoresizingMaskIntoConstraints = false
        row4.translatesAutoresizingMaskIntoConstraints = false

        addConstraintsToInputView(
            inputView: self.view, rowViews: [row1, row2, row3, row4])
    }

    func addIndividualButtonConstraints(buttons: [UIButton], rowView: UIView) {

        for (index, button) in (buttons).enumerated() {

            var topConstraint = NSLayoutConstraint(
                item: button, attribute: .top, relatedBy: .lessThanOrEqual,
                toItem: rowView, attribute: .top, multiplier: 1.0, constant: 1.0
            )
            var bottomConstraint = NSLayoutConstraint(
                item: button, attribute: .bottom,
                relatedBy: .greaterThanOrEqual, toItem: rowView,
                attribute: .bottom, multiplier: 1.0, constant: -1.0)

            var rightConstraint: NSLayoutConstraint!

            if index == buttons.count - 1 {

                rightConstraint = NSLayoutConstraint(
                    item: button, attribute: .right,
                    relatedBy: .greaterThanOrEqual, toItem: rowView,
                    attribute: .right, multiplier: 1.0, constant: 0.0)

            } else {

                let nextButton = buttons[index + 1]
                rightConstraint = NSLayoutConstraint(
                    item: button, attribute: .right, relatedBy: .equal,
                    toItem: nextButton, attribute: .left, multiplier: 1.0,
                    constant: -1.0)
            }

            var leftConstraint: NSLayoutConstraint!

            if index == 0 {

                leftConstraint = NSLayoutConstraint(
                    item: button, attribute: .left, relatedBy: .lessThanOrEqual,
                    toItem: rowView, attribute: .left, multiplier: 1.0,
                    constant: 0.0)

            } else {

                let prevtButton = buttons[index - 1]
                leftConstraint = NSLayoutConstraint(
                    item: button, attribute: .left, relatedBy: .equal,
                    toItem: prevtButton, attribute: .right, multiplier: 1.0,
                    constant: 1.0)

                let firstButton = buttons[0]
                var widthConstraint = NSLayoutConstraint(
                    item: firstButton, attribute: .width, relatedBy: .equal,
                    toItem: button, attribute: .width, multiplier: 1.0,
                    constant: 0.0)

                widthConstraint.priority = .defaultHigh
                rowView.addConstraint(widthConstraint)
            }

            rowView.addConstraints([
                topConstraint, bottomConstraint, rightConstraint,
                leftConstraint,
            ])
        }
    }

    func createRowOfButtons(buttonTitles: [String]) -> UIView {

        var buttons = [UIButton]()
        var keyboardRowView = UIView(frame: CGRectMake(0, 0, 320, 50))

        for buttonTitle in buttonTitles {

            let button = createButtonWithTitle(title: buttonTitle as String)
            buttons.append(button)
            keyboardRowView.addSubview(button)
        }

        addIndividualButtonConstraints(
            buttons: buttons, rowView: keyboardRowView)

        return keyboardRowView
    }

    func addConstraintsToInputView(inputView: UIView, rowViews: [UIView]) {

        for (index, rowView) in (rowViews).enumerated() {

            var rightSideConstraint = NSLayoutConstraint(
                item: rowView, attribute: .right, relatedBy: .equal,
                toItem: inputView, attribute: .right, multiplier: 1.0,
                constant: 0.0)
            var leftConstraint = NSLayoutConstraint(
                item: rowView, attribute: .left, relatedBy: .equal,
                toItem: inputView, attribute: .left, multiplier: 1.0,
                constant: 0.0)

            inputView.addConstraints([leftConstraint, rightSideConstraint])

            var topConstraint: NSLayoutConstraint

            if index == 0 {
                topConstraint = NSLayoutConstraint(
                    item: rowView, attribute: .top, relatedBy: .equal,
                    toItem: inputView, attribute: .top, multiplier: 1.0,
                    constant: 0.0)
            } else {

                let prevRow = rowViews[index - 1]
                topConstraint = NSLayoutConstraint(
                    item: rowView, attribute: .top, relatedBy: .equal,
                    toItem: prevRow, attribute: .bottom, multiplier: 1.0,
                    constant: 0.0)

                let firstRow = rowViews[0]
                var heightConstraint = NSLayoutConstraint(
                    item: firstRow, attribute: .height, relatedBy: .equal,
                    toItem: rowView, attribute: .height, multiplier: 1.0,
                    constant: 0.0)

                heightConstraint.priority = .defaultHigh
                inputView.addConstraint(heightConstraint)
            }
            inputView.addConstraint(topConstraint)

            var bottomConstraint: NSLayoutConstraint

            if index == (rowViews.count - 1) {
                bottomConstraint = NSLayoutConstraint(
                    item: rowView, attribute: .bottom, relatedBy: .equal,
                    toItem: inputView, attribute: .bottom, multiplier: 1.0,
                    constant: 0.0)

            } else {

                let nextRow = rowViews[index + 1]
                bottomConstraint = NSLayoutConstraint(
                    item: rowView, attribute: .bottom, relatedBy: .equal,
                    toItem: nextRow, attribute: .top, multiplier: 1.0,
                    constant: 0.0)
            }

            inputView.addConstraint(bottomConstraint)
        }

    }
}

//
//  ConversationInputAccessoryView.swift
//  Drift-SDK
//
//  Created by Eoin O'Connell on 24/01/2018.
//  Copyright © 2018 Drift. All rights reserved.
//

import UIKit

protocol ConversationInputAccessoryViewDelegate: class {
    func didPressRightButton()
    func didPressLeftButton()
    func getKeyboardRect() -> CGRect
    func expandingKeyboard()
    func compressingKeyboard()
    func didPressView()
}

class ConversationInputAccessoryView: UIView {
    
    var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    var bottomContainerView: UIView = {
        let bottomContainerView = UIView()
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.backgroundColor = .clear
        return bottomContainerView
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.88, green:0.93, blue:0.96, alpha:1.0)
        view.alpha = 0.6
        return view
    }()
    
    
    var textView: ConversationInputTextView = {
        let view = ConversationInputTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()
    
    
    var addButton: UIButton = {
        let addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(didPressPlus), for: .touchUpInside)
        addButton.setImage(UIImage(named: "attachImage", in: Bundle(for: Drift.self), compatibleWith: nil), for: .normal)
        addButton.tintColor = ColorPalette.navyExtraDark
        return addButton
    }()
    
    var expandButton: UIButton = {
        let expandButton = UIButton()
        expandButton.setImage(UIImage(named: "expandButton", in: Bundle(for: Drift.self), compatibleWith: nil), for: .normal)
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        expandButton.addTarget(self, action: #selector(didPressExpand), for: .touchUpInside)
        expandButton.imageView?.contentMode = .center
        return expandButton
    }()
    
    var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(didPressSend), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.setTitleColor(DriftDataStore.sharedInstance.generateBackgroundColor(), for: .normal)
        button.setTitleColor(ColorPalette.navyDark, for: .disabled)
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 14)!
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorPalette.navyDark.cgColor
        return button
    }()
    
    
    private var textViewMaxHeightConstraint: NSLayoutConstraint!
    private var textViewHeightConstraint: NSLayoutConstraint!
    
    private var contentViewBottomConstraint: NSLayoutConstraint!
    
    private var backgroundBottomConstraint: NSLayoutConstraint!
    
    private var textViewTopConstraint: NSLayoutConstraint!
    private var textViewBottomConstraint: NSLayoutConstraint!
    
    private var windowAnchor: NSLayoutConstraint?
    
    var expanded = false

    weak var delegate:ConversationInputAccessoryViewDelegate?
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        autoresizingMask = .flexibleHeight
        textView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressView))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
        addViews()
        layoutConstraints()
    }
    
    
    override var intrinsicContentSize: CGSize {
        
        //Action bar height + action bar bottom + textView intrinsic height + top
        
        var height = textViewBottomConstraint.constant
        height = height + bottomContainerView.frame.height
        height = height + textViewTopConstraint.constant
        height = height + textView.intrinsicContentSize.height
        return CGSize(width: frame.width, height: height)
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = window {

                windowAnchor?.isActive = false
                windowAnchor = contentView.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1)
                windowAnchor?.constant = 0
                windowAnchor?.priority = UILayoutPriority(rawValue: 750)
                windowAnchor?.isActive = true
                backgroundBottomConstraint.constant = window.safeAreaInsets.bottom
            }
        }
    }
    
    @objc func didPressView(){
        delegate?.didPressView()
    }
    
    func addViews(){
        addSubview(backgroundView)
        backgroundView.addSubview(contentView)
        contentView.addSubview(bottomContainerView)
        contentView.addSubview(lineView)
        bottomContainerView.addSubview(addButton)
        bottomContainerView.addSubview(sendButton)
        contentView.addSubview(textView)
        contentView.addSubview(expandButton)
    }
    
    func layoutConstraints(){
        
        //AddBackgroundView pinned to all sides
        
        backgroundBottomConstraint = backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundBottomConstraint
        ])
        
        //Add Content view, top, leading, trailing, and safeArea on the bottom
        
        if #available(iOS 11.0, *) {
            contentViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        } else {
            contentViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        }

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            contentViewBottomConstraint
        ])
        
        //Add Line view to top
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineView.topAnchor.constraint(equalTo: contentView.topAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1.0)
            ])
        
        NSLayoutConstraint.activate([
            bottomContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            bottomContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            bottomContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
        
        //Add add button, leading bottom to content and width and height
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor,constant: 15),
            addButton.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -3),
            addButton.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 10),
            addButton.widthAnchor.constraint(equalToConstant: 25),
            addButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        //Add send button, trailing, bottom height and width, hold onto width constraint
        
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -15),
            sendButton.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -6),
            sendButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        //Add textview, leading send, trailing add, top and bottom
        
        textViewMaxHeightConstraint = textView.heightAnchor.constraint(lessThanOrEqualToConstant: 150)
        textViewMaxHeightConstraint.priority = UILayoutPriority(999)
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 35)
        
        //Add textview height > 35, height < 100, height ==
        
        textViewTopConstraint = textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)

        textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: -5)
        
        NSLayoutConstraint.activate([
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            textViewBottomConstraint,
            textViewTopConstraint,
            textViewMaxHeightConstraint,
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            expandButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            expandButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            expandButton.widthAnchor.constraint(equalToConstant: 30),
            expandButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func expandToggled() {
        
        if !textView.isFirstResponder {
            textView.becomeFirstResponder()
            return
        }
        
        if !expanded {
            var height = UIScreen.main.bounds.height - (delegate?.getKeyboardRect() ?? CGRect.zero).height - 80
            
            height = max(height, 200)
            
            textViewHeightConstraint.constant = height
            textViewHeightConstraint.isActive = true
            textViewMaxHeightConstraint.isActive = false
            backgroundView.layer.cornerRadius = 15
            lineView.alpha = 0
        } else {
            textViewHeightConstraint.isActive = false
            textViewMaxHeightConstraint.isActive = true
            backgroundView.layer.cornerRadius = 0
            lineView.alpha = 1
        }
    
        expanded = !expanded

        
        if expanded{
            delegate?.expandingKeyboard()
        } else{
            delegate?.compressingKeyboard()
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, animations: {
            self.superview?.superview?.layoutIfNeeded()
        }, completion: nil)
    }
    
    func updateSendButton(enabled: Bool) {
        sendButton.isEnabled = enabled
        if enabled {
            sendButton.layer.borderColor = DriftDataStore.sharedInstance.generateBackgroundColor().cgColor
        } else {
            sendButton.layer.borderColor = ColorPalette.navyDark.cgColor
        }
    }
    
    @objc func didPressSend(){
        
        if expanded {
            expandToggled()
        }
        
        delegate?.didPressRightButton()
        textViewDidChange(textView) //To disable the text
    }
    
    @objc func didPressPlus(){
        delegate?.didPressLeftButton()
    }
    
    @objc func didPressExpand(){
        expandToggled()
    }
}

extension ConversationInputAccessoryView : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeholderLabel.isHidden = !textView.text.isEmpty
        updateSendButton(enabled: !textView.text.isEmpty)
        
        if textView.intrinsicContentSize.height >= textViewMaxHeightConstraint.constant && !textView.isScrollEnabled{
            textViewHeightConstraint.constant = textView.contentSize.height
            textViewHeightConstraint.isActive = true
            textView.isScrollEnabled = true
        } else if textView.isScrollEnabled && textView.contentSize.height < textViewMaxHeightConstraint.constant{
            textViewHeightConstraint.isActive = false
            textView.isScrollEnabled = false
            textView.invalidateIntrinsicContentSize()
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, animations: {
                self.superview?.superview?.layoutIfNeeded()
            })
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.didPressView()
    }
}

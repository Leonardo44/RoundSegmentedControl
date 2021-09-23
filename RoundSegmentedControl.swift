//
//  RoundSegmentedControl.swift
//
//  Created by Leonado Lopez on 23/9/21.
//

import UIKit

protocol RoundSegmentedControlDelegate: AnyObject {
    func didSelectItem(index: Int)
}

public class RoundSegmentedControl: UIView {
    var selectedBackgroundColor:UIColor = UIColor.blue {
        didSet {
            self.slideView.backgroundColor = selectedBackgroundColor
        }
    }
    var selectedTextColor: UIColor = UIColor.white
    var unselectedTextColor: UIColor = UIColor.black
    var radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = radius
            slideView.layer.cornerRadius = radius - 4
        }
    }
    var leftButtonText: String = "" {
        didSet {
            leftButton.setTitle(leftButtonText, for: .normal)
        }
    }
    var rightButtonText: String = "" {
        didSet {
            rightButton.setTitle(rightButtonText, for: .normal)
        }
    }
    var startingIndex: Int = -1 {
        didSet {
            didSelectButton(at: startingIndex)
        }
    }
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment  = .center
        return button
    }()
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment  = .center
        return button
    }()
    lazy var stackView: UIStackView = UIStackView(arrangedSubviews: [])
    lazy var slideView: UIView = {
        var view = UIView(frame: CGRect.zero)
        view.backgroundColor = self.selectedBackgroundColor
        return view
    }()
    private var currentIndex: Int = 0
    private var buttons: [UIButton] = []
    private var leftSlideViewConstraint: NSLayoutConstraint?
    private var rightSlideViewConstraint: NSLayoutConstraint?
    private var heightSlideViewConstraint: NSLayoutConstraint?
    weak var delegate: RoundSegmentedControlDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
        
    private func setupView() {
        self.buttons = [leftButton, rightButton]
        leftButton.sizeToFit()
        rightButton.sizeToFit()
            
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(rightButton)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 4
            
        addSubview(slideView)
        slideView.translatesAutoresizingMaskIntoConstraints = false
        rightSlideViewConstraint = slideView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        leftSlideViewConstraint = slideView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4)
        slideView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        slideView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        leftSlideViewConstraint?.isActive = true
        rightSlideViewConstraint?.isActive = true
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
            
        leftButton.addTarget(self, action: #selector(RoundSegmentedControl.buttonTapped(sender:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(RoundSegmentedControl.buttonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func buttonTapped(sender :UIButton!) {
        switch sender {
        case leftButton:
            didSelectButton(at: 0)
            break
        case rightButton:
            didSelectButton(at: 1)
            break
        default:
            break
        }
    }
        
    func didSelectButton(at index: Int) {
        if index == 0 {
            delegate?.didSelectItem(index: index)
            leftButton.setTitleColor(selectedTextColor, for: .normal)
            rightButton.setTitleColor(unselectedTextColor, for: .normal)
           
            UIView.animate(withDuration: 0.1) {
                self.rightSlideViewConstraint?.constant = -self.rightButton.frame.width - self.stackView.spacing
                self.leftSlideViewConstraint?.constant = 4
                self.slideView.isHidden = false
                
                self.layoutIfNeeded()
            }
        } else if index == 1 {
            delegate?.didSelectItem(index: index)
            
            
            leftButton.setTitleColor(unselectedTextColor, for: .normal)
            rightButton.setTitleColor(selectedTextColor, for: .normal)
    
            UIView.animate(withDuration: 0.1) {
                self.rightSlideViewConstraint?.constant = -4
                self.leftSlideViewConstraint?.constant = self.leftButton.frame.width + self.stackView.spacing
                self.slideView.isHidden = false
                
                self.layoutIfNeeded()
            }
        } else {
            leftButton.setTitleColor(unselectedTextColor, for: .normal)
            rightButton.setTitleColor(unselectedTextColor, for: .normal)
            slideView.isHidden = true
        }
        currentIndex = index
    }
}

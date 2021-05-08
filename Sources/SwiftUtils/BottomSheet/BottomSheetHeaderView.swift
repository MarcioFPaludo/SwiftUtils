//
//  BottomSheetHeaderView.swift
//  
//
//  Created by Marcio F. Paludo on 07/03/21.
//

import UIKit

public class BottomSheetHeaderView: UIView {
    
    public typealias Completion = (BottomSheetHeaderView) -> Void
    private weak var indicatorView: UIView!
    private weak var titleLabel: UILabel!
    
    public override var tintColor: UIColor! { didSet { indicatorView?.backgroundColor = tintColor } }
    @IBInspectable public var titleColor: UIColor! { didSet{ titleLabel?.textColor = titleColor } }
    @IBInspectable public  var title: String? { didSet { titleLabel?.text = title } }
    public var tapCompletion: Completion?
    
    // MARK: - Instance
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
        
    }
    
    private func initialize() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapHeader(_:)))
        var constraints: [NSLayoutConstraint] = [], indicatorView = UIView(), titleLabel = UILabel()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.backgroundColor = tintColor
        titleLabel.font = .systemFont(ofSize: 9)
        indicatorView.layer.cornerRadius = 3
        indicatorView.clipsToBounds = true
        titleLabel.textAlignment = .center
        titleLabel.textColor = titleColor
        titleLabel.text = title
        
        constraints.append(widthAnchor.constraint(greaterThanOrEqualToConstant: 44))
        constraints.append(indicatorView.widthAnchor.constraint(equalToConstant: 44))
        constraints.append(indicatorView.heightAnchor.constraint(equalToConstant: 6))
        constraints.append(indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor))
        constraints.append(indicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 13))
        constraints.append(titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor))
        constraints.append(titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor))
        constraints.append(titleLabel.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 4))
        constraints.append(bottomAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 10))
        
        addSubview(titleLabel)
        addSubview(indicatorView)
        addConstraints(constraints)
        self.titleLabel = titleLabel
        self.indicatorView = indicatorView
        addGestureRecognizer(gestureRecognizer)
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Actions
    
    @objc private func didTapHeader(_ sender: Any) {
        tapCompletion?(self)
    }
    
}


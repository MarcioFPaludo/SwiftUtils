//
//  BottomSheetView.swift
//
//
//  Created by Marcio F. Paludo on 29/01/21.
//

import UIKit

fileprivate extension UIColor {
    class var safeSystemBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    
    class var safeSystemFill: UIColor {
        if #available(iOS 13, *) {
            return .systemFill
        } else {
            return .white
        }
    }
}

public final class BottomSheetView: UIView {
    /// Defines a sizing style for the sheet
    public enum SheetSizingStyle {
        /// Adapts the size of the bottom sheet to its content. If the content height is greater than the available frame height, it pins the sheet to the top safe area inset, like `toSafeAreaTop`.
        case adaptive
        /// Aligns the top of the bottom sheet to the top safe area inset.
        case toSafeAreaTop
        /// Sets a fixed height for the sheet. If `height` is greater than the available frame height, it pins the sheet to the top safe area inset, like `toSafeAreaTop`.
        case fixed(height: CGFloat)
    }

    public var sheetSizingStyle: SheetSizingStyle
        
    /// Ancdhors the top of the `contentView` to its superview
    lazy var contentViewTopAnchor = contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: contentInsets.top)
    lazy var contentViewLeadingAnchor = contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left)
    lazy var contentViewTrailingAnchor = contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right)
    lazy var contentViewBottomAnchor = contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsets.bottom)
    
    /// The content of the bottom sheet. Assign your view to this variable to set a custom content.
    public var contentView: UIView = UIView() {
        didSet {
            oldValue.removeFromSuperview()
            addSubview(contentView)
            setContentViewConstraints()
        }
    }
        
    public var contentInsets: UIEdgeInsets = .zero {
        didSet {
            updateContentConstraints()
            setNeedsDisplay()
            setNeedsUpdateConstraints()
        }
    }

    public init(sheetSizingStyle: SheetSizingStyle = .toSafeAreaTop) {
        self.sheetSizingStyle = sheetSizingStyle
        super.init(frame: .zero)
        
        backgroundColor = .clear

        addSubview(contentView)
        setContentViewConstraints()
    }
    
    override init(frame: CGRect) {
        self.sheetSizingStyle = .toSafeAreaTop
        super.init(frame: frame)
        
        backgroundColor = .clear

        addSubview(contentView)
        setContentViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.sheetSizingStyle = .toSafeAreaTop
        super.init(coder: coder)

        backgroundColor = .clear

        addSubview(contentView)
        setContentViewConstraints()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func updateContentConstraints() {
        contentViewTopAnchor.constant = contentInsets.top
        contentViewLeadingAnchor.constant = contentInsets.left
        contentViewBottomAnchor.constant = -contentInsets.bottom
        contentViewTrailingAnchor.constant = -contentInsets.right
    }
    
    private func setContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentViewTopAnchor = contentView.topAnchor.constraint(equalTo: topAnchor, constant: contentInsets.top)
        contentViewBottomAnchor = contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentInsets.bottom)
        contentViewLeadingAnchor = contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left)
        contentViewTrailingAnchor = contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right)
        
        
        NSLayoutConstraint.activate([
            contentViewLeadingAnchor,
            contentViewTrailingAnchor,
            contentViewBottomAnchor,
            contentViewTopAnchor
        ])
    }
    
}

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 13, *)
struct BottomSheetViewRepresentable: UIViewRepresentable {
    
    typealias UIViewType = BottomSheetView
    
    func makeUIView(context: Context) -> BottomSheetView {
        return BottomSheetView()
    }
    
    func updateUIView(_ uiView: BottomSheetView, context: Context) {}
}

@available(iOS 13, *)
struct BottomSheetViewPreview: PreviewProvider {
    static var previews: some View {
        BottomSheetViewRepresentable() .previewLayout(.fixed(width: 375, height: 460))
    }
}

#endif

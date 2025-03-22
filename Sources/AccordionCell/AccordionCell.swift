// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

open class ExpandableCell: UICollectionViewCell {
    
    public var originalView = UIView()
    public var additionalView = UIView()
    
    private lazy var shrinkedBottomConstraint = originalView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    private lazy var expandedBottomConstraint = additionalView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    
    override open var isSelected: Bool {
        didSet { setAppearance() }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setViewHierarchy()
        setupLayoutConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViewHierarchy() {
        contentView.addSubview(originalView)
        contentView.addSubview(additionalView)
    }
    
    private func setupLayoutConstraints() {
        originalView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        originalView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        originalView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
//        originalView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
        contentView.layoutIfNeeded()
    }
    
    private func setAppearance() {
//        expandedBottomConstraint.isActive = isSelected
//        shrinkedBottomConstraint.isActive = !isSelected
        contentView.layoutIfNeeded()
    }
    
}

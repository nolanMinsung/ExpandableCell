// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

open class AccCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let collectionViewHorizontalSectionInset: CGFloat = 24
    private lazy var widthConstraint = contentView.widthAnchor.constraint(
        equalToConstant: 0
    )
    
    private lazy var shrinkedBottomConstraint = upperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    private lazy var expandedBottomConstraint = lowerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    
    open override var isSelected: Bool {
        didSet { setAppearance() }
    }
    
    //MARK: - UI Properties
    
    /// view displaying on cell when folded
    public let upperView = UIView()
    
    /// additional view displaying on cell when expanded
    public let lowerView = UIView()
    
    //MARK: - Life Cycle
    
    /// 재정의 시 반드시 super 호출
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension AccCell {
    
    //MARK: - Private Func
    
    private func setupViewHierarchy() {
        contentView.addSubview(upperView)
        contentView.addSubview(lowerView)
    }
    
    private func setupStyle() {
        contentView.clipsToBounds = true
        upperView.clipsToBounds = true
        lowerView.clipsToBounds = true
    }
    
    private func setupLayout() {
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        upperView.translatesAutoresizingMaskIntoConstraints = false
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            upperView.topAnchor.constraint(equalTo: contentView.topAnchor),
            upperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            upperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lowerView.topAnchor.constraint(equalTo: upperView.bottomAnchor),
            lowerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lowerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        expandedBottomConstraint.priority = .defaultLow
        shrinkedBottomConstraint.priority = .defaultLow
        
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
    }
    
    private func setAppearance() {
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
        contentView.updateConstraints()
        contentView.layoutIfNeeded()
    }
    
}

public extension AccCell {
    
    public func updateWidth(_ width: CGFloat) {
        self.widthConstraint.constant = width
        setAppearance()
    }
    
}

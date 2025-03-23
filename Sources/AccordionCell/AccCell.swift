// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

protocol WidthAdoptable {
    func adoptWidth(_ width: CGFloat)
}

open class AccCell: UICollectionViewCell {

//MARK: - Properties

private let collectionViewHorizontalSectionInset: CGFloat = 24
private lazy var widthConstraint = contentView.widthAnchor.constraint(
    equalToConstant: (UIScreen.main.bounds.width - collectionViewHorizontalSectionInset * 3)
)

private lazy var expandedBottomConstraint = lowerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
private lazy var shrinkedBottomConstraint = upperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    
    override public var isSelected: Bool {
        didSet { setAppearance() }
    }
    
//    @available(*, deprecated, message: "contentView에 직접 접근하지 마세요. 대신 upperView 또는 lowerView를 사용하세요.")
//    open override var contentView: UIView {
//        return self.upperView
//    }
    
    //MARK: - UI Properties
    
    /// view displaying on cell when folded
    let upperView = UIView()
    
    /// additional view displaying on cell when expanded
    let lowerView = UIView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AccCell {
    
    //MARK: - Private Func
    
    private func setupViewHierarchy() {
        contentView.backgroundColor = .lightGray
        contentView.addSubview(upperView)
        contentView.addSubview(lowerView)
    }
    
    private func setupStyle() {
        
        upperView.clipsToBounds = true
        upperView.backgroundColor = .orange
        lowerView.clipsToBounds = true
        lowerView.backgroundColor = .lightGray
    }
    
    private func setupLayout() {
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            upperView.topAnchor.constraint(equalTo: contentView.topAnchor),
            upperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            upperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
//        upperView.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalToSuperview()
//        }
        
        NSLayoutConstraint.activate([
            lowerView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            lowerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lowerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
//        lowerView.snp.makeConstraints { make in
//            make.top.equalTo(upperView.snp.bottom)
//            make.horizontalEdges.equalToSuperview()
//        }
        
        expandedBottomConstraint.priority = .defaultLow
        shrinkedBottomConstraint.priority = .defaultLow
        
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
        lowerView.isHidden = !isSelected
    }
    
    private func setAppearance() {
        lowerView.isHidden = !isSelected
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
        contentView.updateConstraints()
        contentView.layoutIfNeeded()
    }
    
}

extension AccCell: WidthAdoptable {
    
    func adoptWidth(_ width: CGFloat) {
        self.widthConstraint.constant = width
        setAppearance()
    }
    
}

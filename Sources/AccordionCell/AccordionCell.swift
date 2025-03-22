// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

class ExpandableCell: UICollectionViewCell {
    
    private var isExpanded = false
    private let expandableView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(expandableView)
        // 추가 콘텐츠 레이아웃 설정
        expandableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandableView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            expandableView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            expandableView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            expandableView.heightAnchor.constraint(equalToConstant: 0) // 초기 높이 0
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleAccordion() {
        isExpanded.toggle()
        
        // 애니메이션을 통해 펼쳐지거나 접히는 효과 적용
        UIView.animate(withDuration: 0.3) {
            self.expandableView.isHidden = !self.isExpanded
            self.expandableView.frame.size.height = self.isExpanded ? 100 : 0 // 높이 조절
            self.layoutIfNeeded() // 레이아웃 업데이트
        }
    }
}

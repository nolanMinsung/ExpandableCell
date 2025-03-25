//
//  File.swift
//  ExpandableCell
//
//  Created by 김민성 on 3/25/25.
//

import UIKit

open class ExpandableCellCollectionViewController: UIViewController {
    
    var sectionInset: UIEdgeInsets
    var minimumLineSpacing: CGFloat
    
    private lazy var exCellCollectionView = ExpandableCellCollectionView(
        sectionInset: sectionInset,
        minimumLineSpacing: minimumLineSpacing
    )
    
    public var collectionView: ExpandableCellCollectionView {
        view as? ExpandableCellCollectionView ?? ExpandableCellCollectionView()
    }
    
    public init(sectionInset: UIEdgeInsets = .zero, minimumLineSpacing: CGFloat = .zero) {
        self.sectionInset = sectionInset
        self.minimumLineSpacing = minimumLineSpacing
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func loadView() {
        view = exCellCollectionView
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        exCellCollectionView.dataSource = self
    }
    
}

// MARK: - UICollectionViewDataSource

extension ExpandableCellCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
}

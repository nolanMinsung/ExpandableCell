//
//  File.swift
//  ExpandableCell
//
//  Created by 김민성 on 3/25/25.
//

import UIKit

open class ExpandableCellCollectionViewController: UIViewController {
    
    var sectionInset: UIEdgeInsets = .zero
    
    let collectionView = ExpandableCellCollectionView()
    
    override open func loadView() {
        view = collectionView
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: 여기서 이 메서드 사용해야 처음 레이아웃 그려질 때 셀이 의도한 크기대로 그려짐
        collectionView.performBatchUpdates(nil)
    }
    
}

// MARK: - UICollectionViewDataSource

extension ExpandableCellCollectionViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    
}

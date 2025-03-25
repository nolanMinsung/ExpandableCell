# ExpandableCell

A lightweight and smooth accordion-style collection view cell library for iOS.

📌 **Supports easy integration with `ExpandableCellCollectionViewController` and provides smooth animations.**  

![Demo GIF](path/to/demo.gif) <!-- 여기에 GIF 파일을 추가해주세요 -->

---

## ✨ Features

- **Smooth Expanding Animation**  
  Cells smoothly transition between expanded and folded states.  
- **Easy to Use**  
  Simply inherit `ExpandableCell`, register it in `ExpandableCellCollectionViewController`, and set up your data source.

### Other Features  
- Currently optimized for a single-section layout with multiple cells in one row.  
  Support for multiple sections is planned for future updates.  

---

## 🚀 Usage

### 1. Define a custom cell by inheriting `ExpandableCell`
- Instead of using `contentView` directly, use `mainContentView` and `detailContentView` when configuring view hierarchy.
  - Add content that should remain visible when the cell is folded as a subview of `mainContentView` in ExpandableCell.
  - Add content that should only be visible when expanded and hidden when folded as a subview of `detailContentView`.
- The width of `ExpandableCell` is automatically set based on the width of ExpandableCellCollectionView and the specified insets.

``` swift
import UIKit
import ExpandableCell

class MyExpandableCell: ExpandableCell {
    // Properties
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        // setting View Hierarchy
        mainContentView.addSubview(titleLabel)
        detailContentView.addSubview(descriptionLabel)

        // setting contents' properties...
        // setting contents' layout...
    }

    func configure(with data: DataModel) {
        // configure cell's contents...
    }
}
```

### 2. Define a custom view controller by inheriting `ExpandableCellCollectionViewController`
- You can define simple layout properties like insets when initializing.
- you can manage data source of collection view in the view controller.
- `ExpandableCellCollectionViewController` adopts `UICollectionViewDataSource` protocol, so you can just implement `UICollectionViewDataSource`-related methods in this view controller. 

```swift
import UIKit

import ExpandableCell

class MyExpandableCellCollectionVC: ExpandableCellCollectionViewController {
    
    private var dataList: [DataModel] = [ ... ]
    
    init() {
        super.init(
            sectionInset: .init(top: 15, left: 15, bottom: 15, right: 15),
            minimumLineSpacing: 15
        )
        
        // additional settings during initializing...
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell for collection view.
        self.collectionView.register(MyExpandableCell.self, forCellWithReuseIdentifier: "MyExpandableCell")
    }
    
}

// implement methods related to UICollectionViewDataSource
extension MyExpandableCellCollectionVC {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MyExpandableCell", for: indexPath
        ) as? MyExpandableCell else { fatalError() }
        let data = self.dataList[indexPath.item]
        cell.configure(with: data)
        return cell
    }
    
}
```


### 3. add custom view controller as a child view controller where you want to show at.
``` swift
import UIKit
import ExpandableCell

class ViewController: UIViewController {

    let exCellCollectionViewController = MyExpandableCellCollectionVC()
    var exCellCollectionView: ExpandableCellCollectionView { exCellCollectionViewController.collectionView }

    override func viewDidLoad() {
        super.viewDidLoad()

        // add as a child view controller.
        addChild(exCellCollectionViewController)
        // set view hierarchy, layout, etc.
    }

}
```
---
## 📜 License

ExpandableCell is available under the  [MIT License](https://github.com/nolanMinsung/ExpandableCell/blob/main/LICENSE).

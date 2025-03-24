# ExpandableCell

A lightweight and smooth accordion-style collection view cell library for iOS.

📌 **Supports easy integration with `ExpandableCellCollectionView` and provides smooth animations.**  

![Demo GIF](path/to/demo.gif) <!-- 여기에 GIF 파일을 추가해주세요 -->

---

## ✨ Features

- **Smooth Expanding Animation**  
  Cells smoothly transition between expanded and folded states.  
- **Easy to Use**  
  Simply inherit `ExpandableCell`, register it in `ExpandableCellCollectionView`, and set up your data source.

### Other Features  
- Currently optimized for a single-section layout with multiple cells in one row.  
  Support for multiple sections is planned for future updates.  

---

## 🚀 Usage

### 1. Create an instance of `ExpandableCellCollectionView`
You can define simple layout properties like insets when initializing.

```swift
import UIKit
import ExpandableCell

class ViewController: UIViewController {
    // Properties
    let fcCollectionView = ExpandableCellCollectionView
    
    // initialize view controller...
    // set fcCollectionView's view hierarchy and layout
    // ...
}
```

### 2. Define a custom cell by inheriting ExpandableCell
- Instead of using `contentView` directly, use `mainContentView` and `detailContentView`.
  
  You can set background color of `contentView` when you want to set whole background of cell.
- Add content that should remain visible when the cell is folded as a subview of `mainContentView` in ExpandableCell.
- Add content that should only be visible when expanded and hidden when folded as a subview of `detailContentView`.
- The width of `ExpandableCell` is automatically set based on the width of ExpandableCellCollectionView and the specified insets.
``` swift
// Example of Code Using SnapKit Library

import UIKit
import ExpandableCell

class MyCell: ExpandableCell {
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
    // ...
}
```

### 3. Register the custom cell and implement UICollectionViewDataSource
``` swift
import UIKit
import ExpandableCell

class ViewController: UIViewController {
    // Properties
    let fcCollectionView = ExpandableCellCollectionView
    
    // initialize view controller...
    // set fcCollectionView's view hierarchy and layout...
    // ...

    // Register cell, set dataSource delegate
    fcCollectionView.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
    fcCollectionView.dataSource = self
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    // implement dataSource methods...
}
```
---
## 📜 License

ExpandableCell is available under the  [MIT License](https://github.com/nolanMinsung/ExpandableCell/blob/main/LICENSE).

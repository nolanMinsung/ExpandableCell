# FoldableCell

A lightweight and smooth accordion-style collection view cell library for iOS.

📌 **Supports easy integration with `FoldableCellCollectionView` and provides smooth animations.**  

![Demo GIF](path/to/demo.gif) <!-- 여기에 GIF 파일을 추가해주세요 -->

---

## ✨ Features

- **Smooth Folding Animation**  
  Cells smoothly transition between folded and expanded states.  
- **Easy to Use**  
  Simply inherit `FoldableCell`, register it in `FoldableCellCollectionView`, and set up your data source.

### Other Features  
- Currently optimized for a single-section layout with multiple cells in one row.  
  Support for multiple sections is planned for future updates.  

---

## 🚀 Usage

### 1. Create an instance of `FoldableCellCollectionView`
You can define simple layout properties like insets when initializing.

```swift
import UIKit
import FoldableCell

class ViewController: UIViewController {
    // Properties
    let fcCollectionView = FoldableCellCollectionView
    
    // initialize view controller...
    // set fcCollectionView's view hierarchy and layout
    // ...
}
```

### 2. Define a custom cell by inheriting FoldableCell
- Instead of using `contentView` directly, use `mainContentView` and `detailContentView`.
  
  You can set background color of `contentView` when you want to set whole background of cell.
- Add content that should remain visible when the cell is folded as a subview of `mainContentView` in FoldableCell.
- Add content that should only be visible when expanded and hidden when folded as a subview of `detailContentView`.
- The width of `FoldableCell` is automatically set based on the width of FoldableCellCollectionView and the specified insets.
``` swift
// Example of Code Using SnapKit Library

import UIKit
import FoldableCell

class MyCell: FoldableCell {
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
import FoldableCell

class ViewController: UIViewController {
    // Properties
    let fcCollectionView = FoldableCellCollectionView
    
    // initialize view controller...
    // set fcCollectionView's view hierarchy and layout...
    // ...

    // Register cell, set dataSource delegate
    fcCollectionView.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
    fcCollectionView.dataSource = self
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    // set dataSource methods...
}
```
---
## 📜 License

FoldableCell is available under the  [MIT License](https://github.com/nolanMinsung/FoldableCell/blob/main/LICENSE).

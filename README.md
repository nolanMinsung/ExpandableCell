## A lightweight and smooth accordion-style collection view cell library for iOS.

📌 **Supports easy integration with `ExpandableCellCollectionView` and provides smooth animations.**  

| | |
|:-:|:-:|
| <img src="https://github.com/user-attachments/assets/a7c35a9e-9794-4c33-9cae-976dff1e38a0" width=200> | <img src="https://github.com/user-attachments/assets/888484d3-fdc5-40a5-9184-fee211bf952d" width=200> |

---

# ⬇️ Installation

This library supports installation via [Swift Package Manager](https://swift.org/package-manager/) only:

1. Open your Xcode project.
2. Go to **File > Add Package Dependencies...**
3. Enter the package URL: `https://github.com/nolanMinsung/ExpandableCell.git`
4. Select the version and add it to your target.

--- 

# ✨ Features

- **Smooth Expanding Animation**  
  Cells smoothly transition between expanded and folded states.  
- **Easy to Use**  
  Simply inherit `ExpandableCell`, register it in `ExpandableCellCollectionView`, and set up your data source.

## 📱 Portrait Mode Recommended
- This library is optimized for apps that support only portrait mode. Unexpected layout issues may occur if the collection view is visible when the device rotates.

## Other Features  
- Currently optimized for vertical scrolling with a single-column layout.

---

# 🚀 How to Use

## 1. Define a custom cell by inheriting `ExpandableCell`
- Instead of using `contentView` directly, use `mainContentView` and `detailContentView` when configuring view hierarchy.
  - Add content that should remain visible when the cell is folded as a subview of `mainContentView` in `ExpandableCell`.
  - Add content that should only be visible when expanded and hidden when folded as a `subview` of `detailContentView`.
- The width of `ExpandableCell` is automatically set based on the width of collection view and the specified insets.

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

## 2. Use `ExpandableCellCollectionView`
  `ExpandableCellCollectionView` is a custom `UICollectionView` that enables expand/collapse interaction when tapping on cells.
  Key Notes:
- You can either instantiate `ExpandableCellCollectionView` directly or subclass it for more customization.
- Only cells of type `ExpandableCell` are allowed to be registered.
- Expanding/collapsing behavior is built-in and automatically triggered on selection.  
  You can prevent the expanding behavior by returning false in `collectionView(_:shouldSelectItemAt:)`.
- As of version 2.x, you can now assign your own `delegate` to `ExpandableCellCollectionView`, just like any `UICollectionView`.
  ``` swift
  expandableCellCollectionView.delegate = self // ✅ Allowed from version 2.0.0
  ```
---

# 🧪 Example Project

The following repository is an example that demonstrates how to use this library:
<p align="left">
  <a href="[https://github.com/your-repo-link](https://github.com/nolanMinsung/ExpandableCellExampleProject)">
    <img src="https://img.shields.io/badge/GitHub-ExpandableCell%20Example-blue?style=for-the-badge&logo=github" alt="GitHub Repo">
  </a>
</p>

[🔗 Example Repository](https://github.com/nolanMinsung/ExpandableCellExampleProject)

---

# 📜 License

ExpandableCell is available under the  [MIT License](https://github.com/nolanMinsung/ExpandableCell/blob/main/LICENSE).

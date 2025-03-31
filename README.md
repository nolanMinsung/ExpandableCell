A lightweight and smooth accordion-style collection view cell library for iOS.

📌 **Supports easy integration with `ExpandableCellCollectionViewController` and provides smooth animations.**  

| | |
|:-:|:-:|
| <img src="https://github.com/user-attachments/assets/a7c35a9e-9794-4c33-9cae-976dff1e38a0" width=200> | <img src="https://github.com/user-attachments/assets/f05728c8-1b8e-4272-ad4f-f7223475e44f" width=200> |


![Demo GIF](path/to/demo.gif) <!-- 여기에 GIF 파일을 추가해주세요 -->

---

## ✨ Features

- **Smooth Expanding Animation**  
  Cells smoothly transition between expanded and folded states.  
- **Easy to Use**  
  Simply inherit `ExpandableCell`, register it in `ExpandableCellCollectionViewController`, and set up your data source.

### 📱 Portrait Mode Recommended
- This library is optimized for apps that support only portrait mode. Unexpected layout issues may occur if the collection view is visible when the device rotates.

### Other Features  
- Currently optimized for a layout with cells and sections in one row.  

---

## 🚀 How to Use

### 1. Define a custom cell by inheriting `ExpandableCell`
- Instead of using `contentView` directly, use `mainContentView` and `detailContentView` when configuring view hierarchy.
  - Add content that should remain visible when the cell is folded as a subview of `mainContentView` in ExpandableCell.
  - Add content that should only be visible when expanded and hidden when folded as a subview of `detailContentView`.
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

### 2. Define a custom view controller by inheriting `ExpandableCellCollectionViewController`
- You can define simple layout properties like insets when initializing.
- you can manage data source of collection view in the view controller.
- `ExpandableCellCollectionViewController` adopts `UICollectionViewDataSource` protocol, so if you want to implement `UICollectionViewDataSource`-related methods, you can just override the methods in this view controller(just like using UICollectionViewController).

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

## 🔗 Example Repository

The following repository is an example that demonstrates how to use this library:
<p align="left">
  <a href="[https://github.com/your-repo-link](https://github.com/nolanMinsung/ExpandableCellExampleProject)">
    <img src="https://img.shields.io/badge/GitHub-ExpandableCell%20Example-blue?style=for-the-badge&logo=github" alt="GitHub Repo">
  </a>
</p>

[🔗 Example Repository](https://github.com/nolanMinsung/ExpandableCellExampleProject)


[![Repo](https://gh-card.dev/repos/your-username/your-repo.svg)]([https://github.com/your-username/your-repo](https://github.com/nolanMinsung/ExpandableCellExampleProject))


---

## 📜 License

ExpandableCell is available under the  [MIT License](https://github.com/nolanMinsung/ExpandableCell/blob/main/LICENSE).

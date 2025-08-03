# HybridKit

A Swift package that enables seamless integration between UIKit and SwiftUI components.

## Overview

HybridKit is a powerful framework that bridges UIKit and SwiftUI, allowing developers to embed SwiftUI views within UIKit components. This enables gradual migration from UIKit to SwiftUI or the use of SwiftUI's declarative syntax within existing UIKit-based applications.

The framework provides hybrid versions of common UIKit components:
- View Controllers
- Table View Cells
- Table View Header/Footer Views

## Topics

### View Controllers

- ``HybridController``
- ``HybridControllerWith``

### Table View Components

- ``HybridTableViewCell``
- ``HybridTableViewCellWith``
- ``HybridTableHeaderFooterView``
- ``HybridTableHeaderFooterViewWith``

## Key Features

- **Easy Integration**: Seamlessly embed SwiftUI views in UIKit components
- **Observable Object Support**: Full support for SwiftUI's `@ObservableObject` and data binding
- **Generic Configuration**: Type-safe configuration for table view cells and header/footer views
- **iOS Compatibility**: Works on iOS platforms (excludes macOS)
- **Automatic Layout**: Handles Auto Layout constraints automatically

## Getting Started

### Basic View Controller

Create a hybrid view controller by subclassing `HybridController`:

```swift
import HybridKit
import SwiftUI

class MyViewController: HybridController {
    override var body: any View {
        VStack {
            Text("Hello, HybridKit!")
            Button("Tap me") {
                // Handle button tap
            }
        }
        .padding()
    }
}
```

### View Controller with Observable Object

For data-driven UIs, use `HybridControllerWith` with an `ObservableObject`:

```swift
class MyViewModel: ObservableObject {
    @Published var text: String = "Hello"
    @Published var counter: Int = 0
}

class DataViewController: HybridControllerWith<MyViewModel> {
    override var body: any View {
        VStack {
            Text(observedObject.text)
            Text("Count: \(observedObject.counter)")
            Button("Increment") {
                observedObject.counter += 1
            }
        }
        .padding()
    }
}

// Usage
let viewModel = MyViewModel()
let viewController = DataViewController(observedObject: viewModel)
```

### Table View Cells

Create custom table view cells with SwiftUI content:

```swift
class CustomTableViewCell: HybridTableViewCellWith<String> {
    override func body(with configure: String) -> any View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text(configure)
                .font(.headline)
            Spacer()
        }
        .padding()
    }
}

// In your table view data source
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
    cell.configure(with: "Item \(indexPath.row)")
    return cell
}
```

### Table Header/Footer Views

Create custom header and footer views:

```swift
class SectionHeaderView: HybridTableHeaderFooterViewWith<String> {
    override func body(with configure: String) -> any View {
        HStack {
            Text(configure)
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}

// Usage in table view delegate
func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as! SectionHeaderView
    headerView.configure(with: "Section \(section)")
    return headerView
}
```

## Architecture

### Component Hierarchy

```
HybridKit
├── HybridController (Base View Controller)
├── HybridControllerWith<Object> (View Controller with Observable Object)
├── HybridTableViewCell (Base Table Cell)
├── HybridTableViewCellWith<CellConfigure> (Configurable Table Cell)
├── HybridTableHeaderFooterView (Base Header/Footer)
└── HybridTableHeaderFooterViewWith<HeaderFooterConfigurable> (Configurable Header/Footer)
```

### Design Principles

1. **Inheritance-based**: Extend hybrid classes and override the `body` method
2. **Type Safety**: Generic types ensure compile-time safety for configurations
3. **Memory Management**: Automatic cleanup in `prepareForReuse()` methods
4. **Constraint Handling**: Automatic Auto Layout setup and cleanup

## Advanced Usage

### Navigation and UI Integration

Hybrid view controllers work seamlessly with UIKit navigation:

```swift
class HomeViewController: HybridControllerWith<HomeViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Combine subscriptions for UIKit integration
        observedObject.$presentError
            .sink { [weak self] error in
                if let error = error {
                    self?.showAlert(for: error)
                }
            }
            .store(in: &cancellables)
    }
    
    override var body: any View {
        List {
            Section("Navigation") {
                Button("Push New View") {
                    let newVC = DetailViewController()
                    navigationController?.pushViewController(newVC, animated: true)
                }
            }
            
            Section("Input") {
                TextField("Enter text", text: $observedObject.inputText)
            }
        }
    }
    
    private func showAlert(for error: Error) {
        let alert = UIAlertController(title: "Error", 
                                    message: error.localizedDescription, 
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
```

### Complex Table View Cells

Create sophisticated table view cells with SwiftUI:

```swift
struct ItemData {
    let title: String
    let subtitle: String
    let imageName: String
    let isSelected: Bool
}

class ComplexTableViewCell: HybridTableViewCellWith<ItemData> {
    override func body(with configure: ItemData) -> any View {
        HStack(spacing: 12) {
            Image(systemName: configure.imageName)
                .frame(width: 24, height: 24)
                .foregroundColor(configure.isSelected ? .blue : .gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(configure.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(configure.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if configure.isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}
```

## Best Practices

### 1. Memory Management
- Hybrid components automatically handle view cleanup in `prepareForReuse()`
- Store Combine subscriptions in view controllers for proper lifecycle management

### 2. Performance Considerations
- SwiftUI views are embedded using `UIHostingController`
- Consider view complexity for table view cells to maintain smooth scrolling

### 3. State Management
- Use `@ObservableObject` for shared state between UIKit and SwiftUI
- Leverage Combine for reactive programming patterns

### 4. Testing
- Hybrid components can be tested using standard UIKit testing approaches
- SwiftUI content can be tested independently

## Platform Support

- **iOS**: ✅ Supported
- **macOS**: ❌ Not supported (UIKit dependency)
- **watchOS**: ❌ Not supported (UIKit dependency)  
- **tvOS**: ✅ Should work (UIKit available)

## Migration Guide

### From Pure UIKit

1. Replace `UIViewController` with `HybridController`
2. Move UI logic to the `body` property using SwiftUI syntax
3. Gradually convert complex views to SwiftUI

### From Pure SwiftUI

1. Use hybrid components when UIKit integration is needed
2. Wrap SwiftUI views in hybrid containers for UIKit compatibility
3. Maintain SwiftUI patterns while gaining UIKit capabilities

## Requirements

- iOS 13.0+
- Swift 5.0+
- Xcode 11.0+

## Installation

Add HybridKit to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/your-repo/HybridKit.git", from: "1.0.0")
]
```

## See Also

- [UIKit Documentation](https://developer.apple.com/documentation/uikit)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Combine Framework](https://developer.apple.com/documentation/combine)
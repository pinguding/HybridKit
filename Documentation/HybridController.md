# HybridController

A base view controller class that embeds SwiftUI views within UIKit view controllers.

## Overview

`HybridController` is the foundational class for creating UIKit view controllers that display SwiftUI content. It automatically handles the embedding of SwiftUI views using `UIHostingController` and manages the layout constraints.

## Declaration

```swift
open class HybridController: UIViewController
```

## Usage

Subclass `HybridController` and override the `body` property to define your SwiftUI content:

```swift
class WelcomeViewController: HybridController {
    override var body: any View {
        VStack(spacing: 20) {
            Image(systemName: "hand.wave.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("Welcome to HybridKit!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Seamlessly blend UIKit and SwiftUI")
                .font(.subtitle)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Get Started") {
                // Handle button action
                print("Getting started...")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
```

## Key Features

- **Automatic Layout**: Constrains the SwiftUI view to fill the entire view controller
- **Simple Integration**: Just override the `body` property
- **UIKit Compatibility**: Works with navigation controllers, tab controllers, and other UIKit containers

## Implementation Details

The `HybridController` automatically:

1. Creates a `UIHostingController` with your SwiftUI content
2. Adds the hosting controller as a child view controller
3. Sets up Auto Layout constraints to fill the entire view
4. Handles the view controller lifecycle

## Initialization

```swift
public init()
```

Creates a new hybrid view controller. The default implementation calls `super.init(nibName: nil, bundle: nil)`.

## Methods

### body

```swift
open var body: any View { get }
```

Override this property to provide your SwiftUI content. The default implementation returns `EmptyView()`.

**Return Value**: A SwiftUI view that will be displayed in the view controller.

### loadView()

```swift
override open func loadView()
```

Called when the view controller's view needs to be created. This method automatically embeds the SwiftUI content from the `body` property.

> Important: You typically don't need to override this method unless you have specific view setup requirements.

## Best Practices

### 1. Keep It Simple
For simple static content, `HybridController` is perfect:

```swift
class AboutViewController: HybridController {
    override var body: any View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("About Our App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("This app demonstrates the power of HybridKit...")
                    .font(.body)
            }
            .padding()
        }
    }
}
```

### 2. UIKit Integration
Access UIKit features through the view controller:

```swift
class MenuViewController: HybridController {
    override var body: any View {
        List {
            Button("Show Settings") {
                let settingsVC = SettingsViewController()
                self.navigationController?.pushViewController(settingsVC, animated: true)
            }
            
            Button("Present Modal") {
                let modalVC = ModalViewController()
                self.present(modalVC, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure navigation bar
        navigationItem.title = "Menu"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(donePressed)
        )
    }
    
    @objc private func donePressed() {
        dismiss(animated: true)
    }
}
```

### 3. Lifecycle Handling
Handle view controller lifecycle events:

```swift
class StatefulViewController: HybridController {
    @State private var isViewVisible = false
    
    override var body: any View {
        VStack {
            if isViewVisible {
                Text("View is visible!")
                    .foregroundColor(.green)
            } else {
                Text("View is hidden")
                    .foregroundColor(.gray)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewVisible = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isViewVisible = false
    }
}
```

## Common Patterns

### Tab Bar Integration

```swift
class TabController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        
        viewControllers = [homeVC, profileVC]
    }
}

class HomeViewController: HybridController {
    override var body: any View {
        Text("Home Content")
    }
}
```

### Navigation Controller Integration

```swift
class RootViewController: HybridController {
    override var body: any View {
        Button("Navigate to Detail") {
            let detailVC = DetailViewController()
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
```

## Limitations

- **State Management**: For complex state management, consider using ``HybridControllerWith`` with an `ObservableObject`
- **Data Binding**: Limited data binding capabilities compared to ``HybridControllerWith``
- **SwiftUI Navigation**: Cannot use SwiftUI's navigation features; must use UIKit navigation

## See Also

- ``HybridControllerWith``
- [UIViewController Documentation](https://developer.apple.com/documentation/uikit/uiviewcontroller)
- [SwiftUI View Documentation](https://developer.apple.com/documentation/swiftui/view)
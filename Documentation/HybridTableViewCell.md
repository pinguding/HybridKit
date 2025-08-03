# HybridTableViewCell

A table view cell class that embeds SwiftUI views for custom cell content.

## Overview

`HybridTableViewCell` allows you to create custom table view cells using SwiftUI's declarative syntax while maintaining compatibility with UIKit's `UITableView`. This class handles the embedding of SwiftUI views and manages the cell lifecycle automatically.

## Declaration

```swift
open class HybridTableViewCell: UITableViewCell
```

## Usage

Subclass `HybridTableViewCell` and override the `body()` method to define your cell's SwiftUI content:

```swift
class CustomTableViewCell: HybridTableViewCell {
    override func body() -> any View {
        HStack(spacing: 12) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Sample Title")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Sample subtitle with additional information")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// Usage in table view
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
    cell.configure()
    return cell
}
```

## Key Features

- **SwiftUI Content**: Create rich, dynamic cell layouts using SwiftUI
- **Automatic Layout**: Handles Auto Layout constraints automatically
- **Cell Reuse**: Properly manages view cleanup during cell reuse
- **UIKit Integration**: Works seamlessly with existing UITableView implementations

## Methods

### body()

```swift
open func body() -> any View
```

Override this method to provide the SwiftUI content for your cell. The default implementation returns `EmptyView()`.

**Return Value**: A SwiftUI view that will be displayed in the cell.

### configure()

```swift
public final func configure()
```

Call this method to configure the cell with its SwiftUI content. This method should be called in your table view's `cellForRowAt` data source method.

> Important: Always call `configure()` after dequeuing the cell to ensure the SwiftUI content is properly set up.

### prepareForReuse()

```swift
open override func prepareForReuse()
```

Automatically called by UIKit when the cell is being reused. This method cleans up the previous SwiftUI content and constraints to prevent visual artifacts.

> Note: You typically don't need to override this method unless you have additional cleanup requirements.

## Implementation Examples

### Simple Text Cell

```swift
class SimpleTextCell: HybridTableViewCell {
    override func body() -> any View {
        HStack {
            Text("Simple Cell Content")
                .font(.body)
            Spacer()
        }
        .padding()
    }
}
```

### Rich Content Cell

```swift
class RichContentCell: HybridTableViewCell {
    override func body() -> any View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
                
                Text("Status: Active")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text("2 min ago")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Text("Important Notification")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("This is a detailed message that provides more context about the notification content.")
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Button("Action") {
                    // Handle action
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Dismiss") {
                    // Handle dismiss
                }
                .buttonStyle(.borderless)
                .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
```

### Interactive Cell

```swift
class InteractiveCell: HybridTableViewCell {
    override func body() -> any View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Toggle Setting")
                        .font(.body)
                    Text("Enable this feature for better experience")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Toggle("", isOn: .constant(true))
                    .labelsHidden()
            }
            
            Divider()
            
            HStack {
                Text("Value: 50%")
                Spacer()
                Slider(value: .constant(0.5), in: 0...1)
                    .frame(width: 120)
            }
        }
        .padding()
    }
}
```

## Table View Integration

### Registration and Dequeue

```swift
class TableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.register(RichContentCell.self, forCellReuseIdentifier: "RichCell")
        
        // Configure table view
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
            cell.configure()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RichCell", for: indexPath) as! RichContentCell
            cell.configure()
            return cell
        }
    }
}
```

### Dynamic Content

```swift
class DynamicContentCell: HybridTableViewCell {
    private var isExpanded = false
    
    override func body() -> any View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("Expandable Cell")
                        .font(.headline)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                }
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                Text("This is the expanded content that shows additional details when the cell is tapped.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .transition(.slide)
            }
        }
        .padding()
        .animation(.easeInOut(duration: 0.3), value: isExpanded)
    }
}
```

## Best Practices

### 1. Performance Considerations

- Keep cell content lightweight for smooth scrolling
- Avoid complex animations in cells
- Use appropriate view modifiers for better performance

```swift
class OptimizedCell: HybridTableViewCell {
    override func body() -> any View {
        HStack {
            // Use fixed frame for images to prevent layout calculations
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 60, height: 60)
            .clipped()
            
            VStack(alignment: .leading) {
                Text(title)
                    .lineLimit(1) // Limit lines for performance
                Text(subtitle)
                    .lineLimit(2)
                    .font(.caption)
            }
            
            Spacer()
        }
        .padding()
    }
}
```

### 2. State Management

- Avoid complex state in cells
- Consider using ``HybridTableViewCellWith`` for data-driven cells
- Keep cells stateless when possible

### 3. Accessibility

```swift
class AccessibleCell: HybridTableViewCell {
    override func body() -> any View {
        HStack {
            Image(systemName: "envelope")
                .accessibilityHidden(true) // Hide decorative images
            
            VStack(alignment: .leading) {
                Text("Message Title")
                    .font(.headline)
                Text("Message preview...")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to open message")
    }
}
```

### 4. Testing

```swift
class TableViewCellTests: XCTestCase {
    func testCellConfiguration() {
        let cell = CustomTableViewCell()
        cell.configure()
        
        // Verify that the cell has content
        XCTAssertFalse(cell.contentView.subviews.isEmpty)
        
        // Test prepare for reuse
        cell.prepareForReuse()
        XCTAssertTrue(cell.contentView.subviews.isEmpty)
    }
}
```

## Limitations

- **Static Content**: Better suited for static content; use ``HybridTableViewCellWith`` for dynamic data
- **State Persistence**: Cell state is not preserved during reuse
- **Performance**: Complex SwiftUI content may impact scrolling performance

## See Also

- ``HybridTableViewCellWith``
- ``HybridTableHeaderFooterView``
- [UITableViewCell Documentation](https://developer.apple.com/documentation/uikit/uitableviewcell)
# HybridTableHeaderFooterView

A table view header/footer view class that embeds SwiftUI views for custom section headers and footers.

## Overview

`HybridTableHeaderFooterView` allows you to create custom table view section headers and footers using SwiftUI's declarative syntax. This class provides the same embedding capabilities as ``HybridTableViewCell`` but is specifically designed for `UITableViewHeaderFooterView` components.

## Declaration

```swift
open class HybridTableHeaderFooterView: UITableViewHeaderFooterView
```

## Usage

Subclass `HybridTableHeaderFooterView` and override the `body()` method to define your header/footer content:

```swift
class SectionHeaderView: HybridTableHeaderFooterView {
    override func body() -> any View {
        HStack {
            Text("Section Header")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGroupedBackground))
    }
}

// Usage in table view delegate
func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as! SectionHeaderView
    headerView.configure()
    return headerView
}
```

## Key Features

- **Custom Headers/Footers**: Create rich section headers and footers with SwiftUI
- **Automatic Layout**: Handles constraint setup and cleanup automatically
- **Reuse Support**: Properly manages view cleanup during header/footer reuse
- **UIKit Integration**: Works seamlessly with `UITableView` delegate methods

## Methods

### body()

```swift
open func body() -> any View
```

Override this method to provide the SwiftUI content for your header or footer view. The default implementation returns `EmptyView()`.

**Return Value**: A SwiftUI view that will be displayed in the header/footer.

### configure()

```swift
public final func configure()
```

Call this method to configure the header/footer view with its SwiftUI content. This method should be called in your table view's delegate methods.

### prepareForReuse()

```swift
open override func prepareForReuse()
```

Automatically called by UIKit when the header/footer view is being reused. This method cleans up the previous SwiftUI content and constraints.

## Implementation Examples

### Simple Section Header

```swift
class SimpleSectionHeader: HybridTableHeaderFooterView {
    override func body() -> any View {
        Text("My Section")
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
    }
}
```

### Rich Section Header

```swift
class RichSectionHeader: HybridTableHeaderFooterView {
    override func body() -> any View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "folder.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Documents")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("12 items")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    // Handle sort action
                }) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Divider()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}
```

### Interactive Section Header

```swift
class CollapsibleSectionHeader: HybridTableHeaderFooterView {
    override func body() -> any View {
        Button(action: {
            // Handle section expand/collapse
            // This would typically notify a delegate or update a data source
        }) {
            HStack {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .rotationEffect(.degrees(90)) // Assuming expanded state
                
                Text("Collapsible Section")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("3 items")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGroupedBackground))
            .animation(.easeInOut(duration: 0.2), value: true)
        }
        .buttonStyle(.plain)
    }
}
```

### Section Footer

```swift
class SectionFooterView: HybridTableHeaderFooterView {
    override func body() -> any View {
        VStack(spacing: 8) {
            Divider()
            
            HStack {
                Text("End of section")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Load More") {
                    // Handle load more action
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
    }
}
```

## Table View Integration

### Registration and Configuration

```swift
class TableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register header/footer classes
        tableView.register(RichSectionHeader.self, 
                          forHeaderFooterViewReuseIdentifier: "RichHeader")
        tableView.register(SectionFooterView.self, 
                          forHeaderFooterViewReuseIdentifier: "SectionFooter")
        
        // Configure table view
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 44
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = 28
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "RichHeader") as! RichSectionHeader
        headerView.configure()
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionFooter") as! SectionFooterView
        footerView.configure()
        return footerView
    }
}
```

### Dynamic Height Headers

```swift
class DynamicHeightHeader: HybridTableHeaderFooterView {
    override func body() -> any View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Variable Content Header")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("This header has content that varies in length. The table view will automatically adjust the height based on the intrinsic content size of the SwiftUI view. This is particularly useful for headers that need to display different amounts of text or varying numbers of UI elements.")
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                ForEach(["Tag1", "Tag2", "Tag3"], id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
    }
}
```

## Advanced Use Cases

### Settings Section Headers

```swift
class SettingsSectionHeader: HybridTableHeaderFooterView {
    override func body() -> any View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "gear")
                    .foregroundColor(.gray)
                
                Text("PREFERENCES")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 8)
            
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 0.5)
                .padding(.leading, 16)
        }
        .background(Color(.systemGroupedBackground))
    }
}
```

### Data Summary Footer

```swift
struct SectionSummary {
    let totalItems: Int
    let totalSize: String
    let lastModified: Date
}

class DataSummaryFooter: HybridTableHeaderFooterView {
    private let summary = SectionSummary(
        totalItems: 25,
        totalSize: "2.3 MB",
        lastModified: Date()
    )
    
    override func body() -> any View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 0.5)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(summary.totalItems) items")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Total size: \(summary.totalSize)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("Updated \(summary.lastModified, style: .relative)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(.systemGroupedBackground))
    }
}
```

## Best Practices

### 1. Height Management

```swift
// Good: Use fixedSize for dynamic height
Text(longDescription)
    .fixedSize(horizontal: false, vertical: true)

// Good: Set estimated heights in table view
tableView.estimatedSectionHeaderHeight = 44
tableView.sectionHeaderHeight = UITableView.automaticDimension
```

### 2. Performance

```swift
// Keep header/footer content lightweight
class LightweightHeader: HybridTableHeaderFooterView {
    override func body() -> any View {
        HStack {
            Text("Section")
                .font(.headline)
            Spacer()
        }
        .padding()
        // Avoid complex animations or heavy content
    }
}
```

### 3. Accessibility

```swift
class AccessibleHeader: HybridTableHeaderFooterView {
    override func body() -> any View {
        HStack {
            Text("Accessible Section Header")
                .font(.headline)
            Spacer()
        }
        .padding()
        .accessibilityAddTraits(.isHeader)
        .accessibilityLabel("Section header")
    }
}
```

### 4. Consistent Styling

```swift
extension Color {
    static let sectionHeaderBackground = Color(.systemGroupedBackground)
    static let sectionHeaderText = Color(.label)
}

class StyledHeader: HybridTableHeaderFooterView {
    override func body() -> any View {
        Text("Consistent Header")
            .font(.headline)
            .foregroundColor(.sectionHeaderText)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.sectionHeaderBackground)
    }
}
```

## Limitations

- **Static Content**: Better suited for static content; use ``HybridTableHeaderFooterViewWith`` for dynamic data
- **State Management**: Header/footer state is not preserved during reuse
- **Complex Interactions**: For complex user interactions, consider using custom UIKit implementations

## See Also

- ``HybridTableHeaderFooterViewWith``
- ``HybridTableViewCell``
- [UITableViewHeaderFooterView Documentation](https://developer.apple.com/documentation/uikit/uitableviewheaderfooterview)
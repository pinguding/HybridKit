# HybridTableHeaderFooterViewWith

A generic table view header/footer view class that embeds SwiftUI views with configurable data.

## Overview

`HybridTableHeaderFooterViewWith` extends ``HybridTableHeaderFooterView`` by adding support for generic configuration data. This enables you to create reusable section headers and footers that can be configured with different data types while maintaining type safety.

## Declaration

```swift
open class HybridTableHeaderFooterViewWith<HeaderFooterConfigurable>: UITableViewHeaderFooterView
```

## Generic Parameters

- `HeaderFooterConfigurable`: The type of configuration data used to customize the header/footer content

## Usage

Define your configuration data type and subclass `HybridTableHeaderFooterViewWith`:

```swift
// 1. Define your configuration data
struct SectionConfig {
    let title: String
    let itemCount: Int
    let icon: String
    let isCollapsed: Bool
    let backgroundColor: Color
}

// 2. Create the header view
class ConfigurableSectionHeader: HybridTableHeaderFooterViewWith<SectionConfig> {
    override func body(with configure: SectionConfig) -> any View {
        HStack(spacing: 12) {
            Image(systemName: configure.icon)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(configure.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(configure.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("\(configure.itemCount) items")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: configure.isCollapsed ? "chevron.right" : "chevron.down")
                .font(.caption)
                .foregroundColor(.secondary)
                .animation(.easeInOut(duration: 0.2), value: configure.isCollapsed)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
}

// 3. Use in table view delegate
func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ConfigurableHeader") as! ConfigurableSectionHeader
    let config = sectionConfigs[section]
    headerView.configure(with: config)
    return headerView
}
```

## Key Features

- **Type Safety**: Generic constraint ensures compile-time type safety for configuration data
- **Reusable**: Same header/footer class can be used with different data types
- **Data-Driven**: Content automatically updates based on configuration
- **Flexible**: Supports any data type as configuration

## Methods

### body(with:)

```swift
open func body(with configure: HeaderFooterConfigurable) -> any View
```

Override this method to provide the SwiftUI content for your header/footer based on the configuration data.

**Parameters:**
- `configure`: The configuration data of type `HeaderFooterConfigurable`

**Return Value**: A SwiftUI view that will be displayed in the header/footer.

### configure(with:)

```swift
public final func configure(with configure: HeaderFooterConfigurable)
```

Configures the header/footer view with the provided data. Call this method in your table view's delegate methods.

**Parameters:**
- `configure`: The configuration data to use for this header/footer instance

## Advanced Examples

### Category Header with Statistics

```swift
struct CategoryHeaderConfig {
    let name: String
    let totalItems: Int
    let completedItems: Int
    let priority: Priority
    let lastUpdated: Date
    
    enum Priority: CaseIterable {
        case low, medium, high
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .orange
            case .high: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .low: return "minus.circle"
            case .medium: return "exclamationmark.circle"
            case .high: return "exclamationmark.triangle"
            }
        }
    }
    
    var completionPercentage: Double {
        guard totalItems > 0 else { return 0 }
        return Double(completedItems) / Double(totalItems)
    }
}

class CategoryHeaderView: HybridTableHeaderFooterViewWith<CategoryHeaderConfig> {
    override func body(with configure: CategoryHeaderConfig) -> any View {
        VStack(spacing: 12) {
            // Main header content
            HStack {
                // Priority indicator
                Image(systemName: configure.priority.icon)
                    .foregroundColor(configure.priority.color)
                    .font(.title3)
                
                // Category info
                VStack(alignment: .leading, spacing: 2) {
                    Text(configure.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("Updated \(configure.lastUpdated, style: .relative)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Completion badge
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(configure.completedItems)/\(configure.totalItems)")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Text("\(configure.completionPercentage * 100, specifier: "%.0f")%")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            // Progress bar
            ProgressView(value: configure.completionPercentage)
                .progressViewStyle(LinearProgressViewStyle(tint: configure.priority.color))
                .scaleEffect(y: 0.8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .fill(configure.priority.color)
                .frame(width: 4)
                .frame(maxWidth: .infinity, alignment: .leading)
        )
    }
}
```

### Expandable Section Header

```swift
struct ExpandableSectionConfig {
    let title: String
    let subtitle: String?
    let isExpanded: Bool
    let canExpand: Bool
    let badge: BadgeInfo?
    let onToggle: () -> Void
    
    struct BadgeInfo {
        let text: String
        let color: Color
    }
}

class ExpandableSectionHeader: HybridTableHeaderFooterViewWith<ExpandableSectionConfig> {
    override func body(with configure: ExpandableSectionConfig) -> any View {
        Button(action: {
            if configure.canExpand {
                configure.onToggle()
            }
        }) {
            HStack(spacing: 12) {
                // Expansion indicator
                if configure.canExpand {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(configure.isExpanded ? 90 : 0))
                        .animation(.easeInOut(duration: 0.2), value: configure.isExpanded)
                } else {
                    Circle()
                        .fill(Color(.systemFill))
                        .frame(width: 8, height: 8)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(configure.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    if let subtitle = configure.subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Badge
                if let badge = configure.badge {
                    Text(badge.text)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(badge.color)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(.systemGroupedBackground))
        }
        .buttonStyle(.plain)
    }
}
```

### Data Summary Footer

```swift
struct SummaryFooterConfig {
    let totalCount: Int
    let totalSize: String
    let averageRating: Double?
    let lastUpdated: Date
    let hasMoreData: Bool
    let onLoadMore: (() -> Void)?
}

class SummaryFooterView: HybridTableHeaderFooterViewWith<SummaryFooterConfig> {
    override func body(with configure: SummaryFooterConfig) -> any View {
        VStack(spacing: 12) {
            // Statistics
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Total: \(configure.totalCount) items")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if let rating = configure.averageRating {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                    .foregroundColor(.yellow)
                                
                                Text("\(rating, specifier: "%.1f")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Text("Size: \(configure.totalSize)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("Updated \(configure.lastUpdated, style: .relative)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // Load more button
            if configure.hasMoreData, let onLoadMore = configure.onLoadMore {
                Button(action: onLoadMore) {
                    HStack {
                        Text("Load More")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Image(systemName: "arrow.down.circle")
                            .font(.subheadline)
                    }
                    .foregroundColor(.blue)
                }
                .padding(.top, 4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGroupedBackground))
    }
}
```

### Filter Header

```swift
struct FilterConfig {
    let activeFilters: [FilterItem]
    let totalResults: Int
    let onClearFilters: () -> Void
    let onAddFilter: () -> Void
    
    struct FilterItem {
        let title: String
        let value: String
        let onRemove: () -> Void
    }
}

class FilterHeaderView: HybridTableHeaderFooterViewWith<FilterConfig> {
    override func body(with configure: FilterConfig) -> any View {
        VStack(alignment: .leading, spacing: 12) {
            // Results summary
            HStack {
                Text("\(configure.totalResults) results")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                if !configure.activeFilters.isEmpty {
                    Button("Clear All") {
                        configure.onClearFilters()
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
            }
            
            // Active filters
            if !configure.activeFilters.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(configure.activeFilters.indices, id: \.self) { index in
                            let filter = configure.activeFilters[index]
                            
                            HStack(spacing: 6) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(filter.title)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    
                                    Text(filter.value)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                
                                Button(action: filter.onRemove) {
                                    Image(systemName: "xmark")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        // Add filter button
                        Button(action: configure.onAddFilter) {
                            HStack(spacing: 4) {
                                Image(systemName: "plus")
                                Text("Filter")
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal, 1) // Prevent clipping
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
}
```

## Best Practices

### 1. Configuration Design

```swift
// Good: Focused, immutable configuration
struct MessageSectionConfig {
    let sectionTitle: String
    let messageCount: Int
    let hasUnread: Bool
    let lastMessageTime: Date
}

// Avoid: Mutable or overly complex configuration
class ComplexConfig {
    var data: [String: Any] = [:] // Too generic
    var callbacks: [() -> Void] = [] // Hard to manage
}
```

### 2. Performance Considerations

```swift
// Implement Equatable for efficient updates
struct OptimizedConfig: Equatable {
    let id: String
    let title: String
    let count: Int
    
    static func == (lhs: OptimizedConfig, rhs: OptimizedConfig) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title && lhs.count == rhs.count
    }
}
```

### 3. Callback Management

```swift
// Use weak references in callbacks to prevent retain cycles
struct CallbackConfig {
    let title: String
    let onAction: () -> Void
    
    init(title: String, target: AnyObject, action: @escaping () -> Void) {
        self.title = title
        self.onAction = { [weak target] in
            guard target != nil else { return }
            action()
        }
    }
}
```

### 4. Type Safety with Enums

```swift
enum SectionType {
    case inbox(unreadCount: Int)
    case archive(totalCount: Int)
    case trash(daysUntilEmpty: Int)
    
    var title: String {
        switch self {
        case .inbox: return "Inbox"
        case .archive: return "Archive"
        case .trash: return "Trash"
        }
    }
    
    var subtitle: String {
        switch self {
        case .inbox(let count): return "\(count) unread"
        case .archive(let count): return "\(count) messages"
        case .trash(let days): return "Empties in \(days) days"
        }
    }
}

struct TypedSectionConfig {
    let sectionType: SectionType
    let isSelected: Bool
}
```

## Testing

```swift
class HeaderFooterViewTests: XCTestCase {
    func testConfigurationBinding() {
        let config = SectionConfig(
            title: "Test Section",
            itemCount: 5,
            icon: "folder",
            isCollapsed: false,
            backgroundColor: .blue
        )
        
        let headerView = ConfigurableSectionHeader()
        headerView.configure(with: config)
        
        // Verify configuration was applied
        XCTAssertFalse(headerView.contentView.subviews.isEmpty)
    }
    
    func testPrepareForReuse() {
        let headerView = ConfigurableSectionHeader()
        let config = SectionConfig(
            title: "Test",
            itemCount: 1,
            icon: "star",
            isCollapsed: true,
            backgroundColor: .red
        )
        
        headerView.configure(with: config)
        headerView.prepareForReuse()
        
        // Verify cleanup
        XCTAssertTrue(headerView.contentView.subviews.isEmpty)
    }
}
```

## See Also

- ``HybridTableHeaderFooterView``
- ``HybridTableViewCellWith``
- [Swift Generics Documentation](https://docs.swift.org/swift-book/LanguageGuide/Generics.html)
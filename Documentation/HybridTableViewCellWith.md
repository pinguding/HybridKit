# HybridTableViewCellWith

A generic table view cell class that embeds SwiftUI views with configurable data.

## Overview

`HybridTableViewCellWith` extends ``HybridTableViewCell`` by adding support for generic configuration data. This enables you to create reusable cells that can be configured with different data types while maintaining type safety.

## Declaration

```swift
open class HybridTableViewCellWith<CellConfigure>: UITableViewCell
```

## Generic Parameters

- `CellConfigure`: The type of configuration data used to customize the cell content

## Usage

Define your configuration data type and subclass `HybridTableViewCellWith`:

```swift
// 1. Define your configuration data
struct MessageCellConfig {
    let senderName: String
    let message: String
    let timestamp: Date
    let isRead: Bool
    let avatarURL: URL?
}

// 2. Create the cell
class MessageTableViewCell: HybridTableViewCellWith<MessageCellConfig> {
    override func body(with configure: MessageCellConfig) -> any View {
        HStack(spacing: 12) {
            // Avatar
            AsyncImage(url: configure.avatarURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(configure.senderName)
                        .font(.headline)
                        .fontWeight(configure.isRead ? .regular : .bold)
                    
                    Spacer()
                    
                    Text(configure.timestamp, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(configure.message)
                    .font(.body)
                    .foregroundColor(configure.isRead ? .secondary : .primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            // Unread indicator
            if !configure.isRead {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(configure.isRead ? Color.clear : Color.blue.opacity(0.05))
    }
}

// 3. Use in table view
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
    let config = messages[indexPath.row]
    cell.configure(with: config)
    return cell
}
```

## Key Features

- **Type Safety**: Generic constraint ensures compile-time type safety
- **Reusable**: Same cell class can be used with different configuration types
- **Data-Driven**: Cell content automatically updates based on configuration data
- **Flexible**: Supports any data type as configuration

## Methods

### body(with:)

```swift
open func body(with configure: CellConfigure) -> any View
```

Override this method to provide the SwiftUI content for your cell based on the configuration data.

**Parameters:**
- `configure`: The configuration data of type `CellConfigure`

**Return Value**: A SwiftUI view that will be displayed in the cell.

### configure(with:)

```swift
public final func configure(with configure: CellConfigure)
```

Configures the cell with the provided data. Call this method in your table view's `cellForRowAt` data source method.

**Parameters:**
- `configure`: The configuration data to use for this cell instance

## Advanced Examples

### E-commerce Product Cell

```swift
struct ProductCellConfig {
    let name: String
    let price: Double
    let originalPrice: Double?
    let imageURL: URL?
    let rating: Double
    let reviewCount: Int
    let isOnSale: Bool
    let isFavorite: Bool
}

class ProductTableViewCell: HybridTableViewCellWith<ProductCellConfig> {
    override func body(with configure: ProductCellConfig) -> any View {
        HStack(spacing: 12) {
            // Product Image
            AsyncImage(url: configure.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(alignment: .topTrailing) {
                if configure.isOnSale {
                    Text("SALE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .offset(x: -4, y: 4)
                }
            }
            
            // Product Details
            VStack(alignment: .leading, spacing: 6) {
                Text(configure.name)
                    .font(.headline)
                    .lineLimit(2)
                
                // Rating
                HStack(spacing: 4) {
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(configure.rating) ? "star.fill" : "star")
                                .font(.caption2)
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    Text("(\(configure.reviewCount))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Price
                HStack(spacing: 8) {
                    Text("$\(configure.price, specifier: "%.2f")")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(configure.isOnSale ? .red : .primary)
                    
                    if let originalPrice = configure.originalPrice, configure.isOnSale {
                        Text("$\(originalPrice, specifier: "%.2f")")
                            .font(.caption)
                            .strikethrough()
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            
            Spacer()
            
            // Favorite Button
            VStack {
                Button(action: {
                    // Handle favorite toggle
                }) {
                    Image(systemName: configure.isFavorite ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundColor(configure.isFavorite ? .red : .gray)
                }
                
                Spacer()
            }
        }
        .padding()
    }
}
```

### Dynamic Content Cell

```swift
enum CellContentType {
    case text(String)
    case image(URL)
    case video(URL, thumbnail: URL)
    case poll(question: String, options: [String])
}

struct DynamicCellConfig {
    let id: String
    let contentType: CellContentType
    let timestamp: Date
    let authorName: String
    let likeCount: Int
    let isLiked: Bool
}

class DynamicContentCell: HybridTableViewCellWith<DynamicCellConfig> {
    override func body(with configure: DynamicCellConfig) -> any View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(configure.authorName)
                    .font(.headline)
                
                Spacer()
                
                Text(configure.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Dynamic Content
            Group {
                switch configure.contentType {
                case .text(let text):
                    Text(text)
                        .font(.body)
                
                case .image(let url):
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                case .video(let url, let thumbnail):
                    ZStack {
                        AsyncImage(url: thumbnail) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                    }
                
                case .poll(let question, let options):
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ForEach(options.indices, id: \.self) { index in
                            HStack {
                                Circle()
                                    .stroke(Color.blue, lineWidth: 2)
                                    .frame(width: 16, height: 16)
                                
                                Text(options[index])
                                    .font(.body)
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            // Footer
            HStack {
                Button(action: {
                    // Handle like
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: configure.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(configure.isLiked ? .red : .gray)
                        Text("\(configure.likeCount)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button("Share") {
                    // Handle share
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
        }
        .padding()
    }
}
```

### Form-like Cell

```swift
struct FormFieldConfig {
    let title: String
    let placeholder: String
    let value: String
    let isRequired: Bool
    let inputType: InputType
    let validationError: String?
    
    enum InputType {
        case text
        case email
        case phone
        case password
        case number
    }
}

class FormFieldCell: HybridTableViewCellWith<FormFieldConfig> {
    override func body(with configure: FormFieldConfig) -> any View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            HStack {
                Text(configure.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if configure.isRequired {
                    Text("*")
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            
            // Input Field
            Group {
                switch configure.inputType {
                case .text:
                    TextField(configure.placeholder, text: .constant(configure.value))
                
                case .email:
                    TextField(configure.placeholder, text: .constant(configure.value))
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                
                case .phone:
                    TextField(configure.placeholder, text: .constant(configure.value))
                        .keyboardType(.phonePad)
                
                case .password:
                    SecureField(configure.placeholder, text: .constant(configure.value))
                
                case .number:
                    TextField(configure.placeholder, text: .constant(configure.value))
                        .keyboardType(.numberPad)
                }
            }
            .textFieldStyle(.roundedBorder)
            
            // Validation Error
            if let error = configure.validationError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
```

## Best Practices

### 1. Configuration Design

```swift
// Good: Focused, specific configuration
struct UserCellConfig {
    let name: String
    let email: String
    let avatarURL: URL?
    let isOnline: Bool
}

// Avoid: Generic, unfocused configuration
struct GenericCellConfig {
    let data: [String: Any] // Too generic
}
```

### 2. Performance

```swift
struct OptimizedConfig {
    let id: String // For efficient comparison
    let title: String
    let imageURL: URL?
    
    // Implement Equatable for efficient updates
}

extension OptimizedConfig: Equatable {
    static func == (lhs: OptimizedConfig, rhs: OptimizedConfig) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
}
```

### 3. Type Safety

```swift
// Use enums for limited options
enum Priority {
    case low, medium, high
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .red
        }
    }
}

struct TaskCellConfig {
    let title: String
    let priority: Priority // Type-safe
    let isCompleted: Bool
}
```

## See Also

- ``HybridTableViewCell``
- ``HybridTableHeaderFooterViewWith``
- [Swift Generics Documentation](https://docs.swift.org/swift-book/LanguageGuide/Generics.html)
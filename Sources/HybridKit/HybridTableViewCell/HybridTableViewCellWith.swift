//
//  File.swift
//  HybridKit
//
//  Created by 박종우 on 10/8/24.
//
#if !os(macOS)
import SwiftUI

/// A generic table view cell class that embeds SwiftUI views with configurable data.
///
/// `HybridTableViewCellWith` extends `HybridTableViewCell` by adding support for generic configuration data.
/// This enables you to create reusable cells that can be configured with different data types while
/// maintaining type safety.
///
/// ## Usage
///
/// Define your configuration data type and subclass `HybridTableViewCellWith`:
///
/// ```swift
/// // 1. Define your configuration data
/// struct MessageCellConfig {
///     let senderName: String
///     let message: String
///     let isRead: Bool
/// }
///
/// // 2. Create the cell
/// class MessageTableViewCell: HybridTableViewCellWith<MessageCellConfig> {
///     override func body(with configure: MessageCellConfig) -> any View {
///         HStack(spacing: 12) {
///             Circle()
///                 .fill(Color.gray)
///                 .frame(width: 44, height: 44)
///             
///             VStack(alignment: .leading, spacing: 4) {
///                 Text(configure.senderName)
///                     .font(.headline)
///                     .fontWeight(configure.isRead ? .regular : .bold)
///                 
///                 Text(configure.message)
///                     .font(.body)
///                     .foregroundColor(.secondary)
///             }
///             
///             Spacer()
///         }
///         .padding()
///     }
/// }
///
/// // 3. Use in table view
/// func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
///     let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
///     let config = messages[indexPath.row]
///     cell.configure(with: config)
///     return cell
/// }
/// ```
///
/// ## Key Features
///
/// - **Type Safety**: Generic constraint ensures compile-time type safety
/// - **Reusable**: Same cell class can be used with different configuration types
/// - **Data-Driven**: Cell content automatically updates based on configuration data
/// - **Flexible**: Supports any data type as configuration
open class HybridTableViewCellWith<CellConfigure>: UITableViewCell {
    
    /// Automatically called by UIKit when the cell is being reused.
    ///
    /// This method cleans up the previous SwiftUI content and constraints to prevent visual artifacts.
    /// You typically don't need to override this method unless you have additional cleanup requirements.
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentView.subviews.forEach { view in
            let viewConstraints = view.constraints
            view.removeConstraints(viewConstraints)
            view.removeFromSuperview()
        }
    }
    
    /// Configures the cell with the provided data.
    ///
    /// This method should be called in your table view's `cellForRowAt` data source method after
    /// dequeuing the cell. It creates a `UIHostingController` with the SwiftUI content from the
    /// `body(with:)` method using the provided configuration data.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    ///     let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! MyConfigurableCell
    ///     let config = myDataArray[indexPath.row]
    ///     cell.configure(with: config) // Pass your configuration data
    ///     return cell
    /// }
    /// ```
    ///
    /// - Parameter configure: The configuration data to use for this cell instance.
    public final func configure(with configure: CellConfigure) {
        guard let uiView = UIHostingController(rootView: AnyView(body(with: configure))).view else { return }
        
        uiView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            uiView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            uiView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            uiView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    /// Override this method to provide the SwiftUI content for your cell based on the configuration data.
    ///
    /// The default implementation returns `EmptyView()`. Subclasses should override this method
    /// to return the SwiftUI view that will be displayed in the cell based on the provided
    /// configuration data.
    ///
    /// ## Example
    ///
    /// ```swift
    /// override func body(with configure: ProductConfig) -> any View {
    ///     VStack(alignment: .leading) {
    ///         Text(configure.name)
    ///             .font(.headline)
    ///         Text("$\(configure.price, specifier: "%.2f")")
    ///             .font(.subheadline)
    ///             .foregroundColor(.blue)
    ///         if configure.isOnSale {
    ///             Text("ON SALE")
    ///                 .font(.caption)
    ///                 .foregroundColor(.red)
    ///         }
    ///     }
    ///     .padding()
    /// }
    /// ```
    ///
    /// - Parameter configure: The configuration data of type `CellConfigure`.
    /// - Returns: A SwiftUI view that will be displayed in the cell.
    open func body(with configure: CellConfigure) -> any View {
        EmptyView()
    }
}

#endif

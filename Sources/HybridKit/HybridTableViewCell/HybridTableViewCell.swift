//
//  File.swift
//  
//
//  Created by 박종우 on 8/31/24.
//
#if !os(macOS)
import SwiftUI

/// A table view cell class that embeds SwiftUI views for custom cell content.
///
/// `HybridTableViewCell` allows you to create custom table view cells using SwiftUI's declarative syntax
/// while maintaining compatibility with UIKit's `UITableView`. This class handles the embedding of SwiftUI
/// views and manages the cell lifecycle automatically.
///
/// ## Usage
///
/// Subclass `HybridTableViewCell` and override the `body()` method to define your cell's SwiftUI content:
///
/// ```swift
/// class CustomTableViewCell: HybridTableViewCell {
///     override func body() -> any View {
///         HStack(spacing: 12) {
///             Image(systemName: "star.fill")
///                 .foregroundColor(.yellow)
///             VStack(alignment: .leading) {
///                 Text("Sample Title")
///                     .font(.headline)
///                 Text("Sample subtitle")
///                     .font(.caption)
///                     .foregroundColor(.secondary)
///             }
///             Spacer()
///         }
///         .padding()
///     }
/// }
///
/// // Usage in table view
/// func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
///     let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
///     cell.configure()
///     return cell
/// }
/// ```
///
/// ## Key Features
///
/// - **SwiftUI Content**: Create rich, dynamic cell layouts using SwiftUI
/// - **Automatic Layout**: Handles Auto Layout constraints automatically
/// - **Cell Reuse**: Properly manages view cleanup during cell reuse
/// - **UIKit Integration**: Works seamlessly with existing UITableView implementations
///
/// - Important: Always call `configure()` after dequeuing the cell to ensure the SwiftUI content is properly set up.
open class HybridTableViewCell: UITableViewCell {
    
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
    
    /// Configures the cell with its SwiftUI content.
    ///
    /// This method should be called in your table view's `cellForRowAt` data source method after
    /// dequeuing the cell. It creates a `UIHostingController` with the SwiftUI content from the
    /// `body()` method and sets up the necessary Auto Layout constraints.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    ///     let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! MyCustomCell
    ///     cell.configure() // Always call this
    ///     return cell
    /// }
    /// ```
    ///
    /// - Important: Always call this method to ensure the SwiftUI content is properly displayed.
    public final func configure() {
        guard let uiView = UIHostingController(rootView: AnyView(body())).view else { return }
        
        uiView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            uiView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            uiView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            uiView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    /// Override this method to provide the SwiftUI content for your cell.
    ///
    /// The default implementation returns `EmptyView()`. Subclasses should override this method
    /// to return the SwiftUI view that will be displayed in the cell.
    ///
    /// ## Example
    ///
    /// ```swift
    /// override func body() -> any View {
    ///     HStack {
    ///         Image(systemName: "envelope")
    ///         VStack(alignment: .leading) {
    ///             Text("Message Title")
    ///                 .font(.headline)
    ///             Text("Message preview...")
    ///                 .font(.body)
    ///                 .foregroundColor(.secondary)
    ///         }
    ///         Spacer()
    ///     }
    ///     .padding()
    /// }
    /// ```
    ///
    /// - Returns: A SwiftUI view that will be displayed in the cell.
    open func body() -> any View {
        EmptyView()
    }
}
#endif

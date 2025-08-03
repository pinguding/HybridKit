//
//  HybridTableHeaderFooterView.swift
//  HybridKit
//
//  Created by 박종우 on 10/20/24.
//
#if !os(macOS)
import SwiftUI

/// A table view header/footer view class that embeds SwiftUI views for custom section headers and footers.
///
/// `HybridTableHeaderFooterView` allows you to create custom table view section headers and footers using
/// SwiftUI's declarative syntax. This class provides the same embedding capabilities as `HybridTableViewCell`
/// but is specifically designed for `UITableViewHeaderFooterView` components.
///
/// ## Usage
///
/// Subclass `HybridTableHeaderFooterView` and override the `body()` method to define your header/footer content:
///
/// ```swift
/// class SectionHeaderView: HybridTableHeaderFooterView {
///     override func body() -> any View {
///         HStack {
///             Text("Section Header")
///                 .font(.headline)
///                 .fontWeight(.bold)
///             
///             Spacer()
///             
///             Image(systemName: "chevron.right")
///                 .font(.caption)
///                 .foregroundColor(.secondary)
///         }
///         .padding()
///         .background(Color(.systemGroupedBackground))
///     }
/// }
///
/// // Usage in table view delegate
/// func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
///     let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as! SectionHeaderView
///     headerView.configure()
///     return headerView
/// }
/// ```
///
/// ## Key Features
///
/// - **Custom Headers/Footers**: Create rich section headers and footers with SwiftUI
/// - **Automatic Layout**: Handles constraint setup and cleanup automatically
/// - **Reuse Support**: Properly manages view cleanup during header/footer reuse
/// - **UIKit Integration**: Works seamlessly with `UITableView` delegate methods
open class HybridTableHeaderFooterView: UITableViewHeaderFooterView {

    /// Automatically called by UIKit when the header/footer view is being reused.
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
    
    /// Configures the header/footer view with its SwiftUI content.
    ///
    /// This method should be called in your table view's delegate methods after dequeuing the
    /// header/footer view. It creates a `UIHostingController` with the SwiftUI content from the
    /// `body()` method and sets up the necessary Auto Layout constraints.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    ///     let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MyHeader") as! MyHeaderView
    ///     headerView.configure() // Always call this
    ///     return headerView
    /// }
    /// ```
    ///
    /// - Important: Always call this method to ensure the SwiftUI content is properly displayed.
    public final func configure() {
        guard let uiView = UIHostingController(rootView: AnyView(body())).view else {
            return
        }
        
        uiView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            uiView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            uiView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    /// Override this method to provide the SwiftUI content for your header or footer view.
    ///
    /// The default implementation returns `EmptyView()`. Subclasses should override this method
    /// to return the SwiftUI view that will be displayed in the header/footer.
    ///
    /// ## Example
    ///
    /// ```swift
    /// override func body() -> any View {
    ///     VStack(spacing: 8) {
    ///         HStack {
    ///             Text("Section Title")
    ///                 .font(.headline)
    ///                 .fontWeight(.bold)
    ///             Spacer()
    ///             Text("12 items")
    ///                 .font(.caption)
    ///                 .foregroundColor(.secondary)
    ///         }
    ///         Divider()
    ///     }
    ///     .padding()
    ///     .background(Color(.systemBackground))
    /// }
    /// ```
    ///
    /// - Returns: A SwiftUI view that will be displayed in the header/footer.
    open func body() -> any View {
        EmptyView()
    }
}

#endif


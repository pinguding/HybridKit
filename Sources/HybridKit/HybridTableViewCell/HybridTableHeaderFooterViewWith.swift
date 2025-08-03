//
//  File.swift
//  HybridKit
//
//  Created by 박종우 on 10/20/24.
//

#if !os(macOS)
import SwiftUI

/// A generic table view header/footer view class that embeds SwiftUI views with configurable data.
///
/// `HybridTableHeaderFooterViewWith` extends `HybridTableHeaderFooterView` by adding support for generic
/// configuration data. This enables you to create reusable section headers and footers that can be configured
/// with different data types while maintaining type safety.
///
/// ## Usage
///
/// Define your configuration data type and subclass `HybridTableHeaderFooterViewWith`:
///
/// ```swift
/// // 1. Define your configuration data
/// struct SectionConfig {
///     let title: String
///     let itemCount: Int
///     let isCollapsed: Bool
/// }
///
/// // 2. Create the header view
/// class ConfigurableSectionHeader: HybridTableHeaderFooterViewWith<SectionConfig> {
///     override func body(with configure: SectionConfig) -> any View {
///         HStack(spacing: 12) {
///             Image(systemName: configure.isCollapsed ? "chevron.right" : "chevron.down")
///                 .font(.caption)
///                 .foregroundColor(.secondary)
///             
///             VStack(alignment: .leading, spacing: 2) {
///                 Text(configure.title)
///                     .font(.headline)
///                     .fontWeight(.semibold)
///                 
///                 Text("\(configure.itemCount) items")
///                     .font(.caption)
///                     .foregroundColor(.secondary)
///             }
///             
///             Spacer()
///         }
///         .padding()
///         .background(Color(.systemBackground))
///     }
/// }
///
/// // 3. Use in table view delegate
/// func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
///     let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ConfigurableHeader") as! ConfigurableSectionHeader
///     let config = sectionConfigs[section]
///     headerView.configure(with: config)
///     return headerView
/// }
/// ```
///
/// ## Key Features
///
/// - **Type Safety**: Generic constraint ensures compile-time type safety for configuration data
/// - **Reusable**: Same header/footer class can be used with different data types
/// - **Data-Driven**: Content automatically updates based on configuration
/// - **Flexible**: Supports any data type as configuration
open class HybridTableHeaderFooterViewWith<HeaderFooterConfigurable>: UITableViewHeaderFooterView {
    
    /// Automatically called by UIKit when the header/footer view is being reused.
    ///
    /// This method cleans up the previous SwiftUI content and constraints to prevent visual artifacts.
    /// You typically don't need to override this method unless you have additional cleanup requirements.
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentView.subviews.forEach { view in
            let constraints = view.constraints
            view.removeConstraints(constraints)
            view.removeFromSuperview()
        }
    }
    
    /// Configures the header/footer view with the provided data.
    ///
    /// This method should be called in your table view's delegate methods after dequeuing the
    /// header/footer view. It creates a `UIHostingController` with the SwiftUI content from the
    /// `body(with:)` method using the provided configuration data.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    ///     let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MyHeader") as! MyConfigurableHeader
    ///     let config = sectionData[section]
    ///     headerView.configure(with: config) // Pass your configuration data
    ///     return headerView
    /// }
    /// ```
    ///
    /// - Parameter configure: The configuration data to use for this header/footer instance.
    public final func configure(with configure: HeaderFooterConfigurable) {
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
    
    /// Override this method to provide the SwiftUI content for your header/footer based on the configuration data.
    ///
    /// The default implementation returns `EmptyView()`. Subclasses should override this method
    /// to return the SwiftUI view that will be displayed in the header/footer based on the provided
    /// configuration data.
    ///
    /// ## Example
    ///
    /// ```swift
    /// override func body(with configure: CategoryConfig) -> any View {
    ///     HStack {
    ///         Image(systemName: configure.iconName)
    ///             .foregroundColor(configure.color)
    ///         
    ///         VStack(alignment: .leading) {
    ///             Text(configure.title)
    ///                 .font(.headline)
    ///             Text("\(configure.itemCount) items")
    ///                 .font(.caption)
    ///                 .foregroundColor(.secondary)
    ///         }
    ///         
    ///         Spacer()
    ///         
    ///         if configure.hasNotification {
    ///             Circle()
    ///                 .fill(Color.red)
    ///                 .frame(width: 8, height: 8)
    ///         }
    ///     }
    ///     .padding()
    /// }
    /// ```
    ///
    /// - Parameter configure: The configuration data of type `HeaderFooterConfigurable`.
    /// - Returns: A SwiftUI view that will be displayed in the header/footer.
    open func body(with configure: HeaderFooterConfigurable) -> any View {
        EmptyView()
    }
}

#endif

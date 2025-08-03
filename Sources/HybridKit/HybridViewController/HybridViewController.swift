//
//  HybridViewController.swift
//  
//
//  Created by 박종우 on 8/27/24.
//

#if !os(macOS)
import SwiftUI

/// A base view controller class that embeds SwiftUI views within UIKit view controllers.
///
/// `HybridController` allows you to create UIKit view controllers that display SwiftUI content.
/// It automatically handles the embedding of SwiftUI views using `UIHostingController` and manages the layout constraints.
///
/// ## Usage
///
/// Subclass `HybridController` and override the `body` property to define your SwiftUI content:
///
/// ```swift
/// class WelcomeViewController: HybridController {
///     override var body: any View {
///         VStack(spacing: 20) {
///             Text("Welcome to HybridKit!")
///                 .font(.title)
///             Button("Get Started") {
///                 // Handle button action
///             }
///         }
///         .padding()
///     }
/// }
/// ```
///
/// ## Key Features
///
/// - **Automatic Layout**: Constrains the SwiftUI view to fill the entire view controller
/// - **Simple Integration**: Just override the `body` property
/// - **UIKit Compatibility**: Works with navigation controllers, tab controllers, and other UIKit containers
open class HybridController: UIViewController {
        
    /// Creates a new hybrid view controller.
    ///
    /// The default implementation calls `super.init(nibName: nil, bundle: nil)`.
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Required initializer for loading from Interface Builder.
    ///
    /// - Parameter coder: An unarchiver object.
    /// - Note: This initializer is not implemented and will cause a fatal error if called.
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Override this property to provide your SwiftUI content.
    ///
    /// The default implementation returns `EmptyView()`. Subclasses should override this property
    /// to return the SwiftUI view that will be displayed in the view controller.
    ///
    /// ## Example
    ///
    /// ```swift
    /// override var body: any View {
    ///     VStack {
    ///         Text("Hello, World!")
    ///         Button("Tap me") {
    ///             print("Button tapped")
    ///         }
    ///     }
    ///     .padding()
    /// }
    /// ```
    ///
    /// - Returns: A SwiftUI view that will be displayed in the view controller.
    open var body: any View {
        EmptyView()
    }
    
    /// Called when the view controller's view needs to be created.
    ///
    /// This method automatically embeds the SwiftUI content from the `body` property.
    /// You typically don't need to override this method unless you have specific view setup requirements.
    override open func loadView() {
        super.loadView()
        
        addSwiftUIView(body)
    }
    
    /// Embeds a SwiftUI view into the view controller's view hierarchy.
    ///
    /// This private method handles the creation of a `UIHostingController` for the SwiftUI content
    /// and sets up the necessary Auto Layout constraints to make the SwiftUI view fill the entire
    /// view controller.
    ///
    /// - Parameter view: The SwiftUI view to embed.
    private func addSwiftUIView(_ view: some View) {
        let hostingController = UIHostingController(rootView: AnyView(body))
        
        guard let uiView = hostingController.view else { return }
        
        uiView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(hostingController)
        self.view.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: self.view.topAnchor),
            uiView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            uiView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}
#endif

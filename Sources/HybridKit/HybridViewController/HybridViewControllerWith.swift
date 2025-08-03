//
//  HybridControllerWith.swift
//
//
//  Created by 박종우 on 8/27/24.
//
#if !os(macOS)

import SwiftUI

/// A view controller class that embeds SwiftUI views and provides data binding through an `ObservableObject`.
///
/// `HybridControllerWith` extends the capabilities of `HybridController` by adding support for SwiftUI's
/// `@ObservableObject` data binding. This enables reactive UI updates and seamless communication between
/// UIKit and SwiftUI components.
///
/// ## Usage
///
/// Create a view model conforming to `ObservableObject` and subclass `HybridControllerWith`:
///
/// ```swift
/// // 1. Create a view model
/// class ProfileViewModel: ObservableObject {
///     @Published var name: String = ""
///     @Published var email: String = ""
///     @Published var isLoading: Bool = false
/// }
///
/// // 2. Create the view controller
/// class ProfileViewController: HybridControllerWith<ProfileViewModel> {
///     override var body: any View {
///         Form {
///             TextField("Name", text: $observedObject.name)
///             TextField("Email", text: $observedObject.email)
///             if observedObject.isLoading {
///                 ProgressView("Loading...")
///             }
///         }
///     }
/// }
///
/// // 3. Initialize and use
/// let viewModel = ProfileViewModel()
/// let profileVC = ProfileViewController(observedObject: viewModel)
/// ```
///
/// ## Key Features
///
/// - **Data Binding**: Full support for SwiftUI's `$` binding syntax
/// - **Reactive Updates**: UI automatically updates when the observed object changes
/// - **Type Safety**: Generic constraint ensures compile-time type safety
/// - **UIKit Integration**: Seamlessly integrate with UIKit navigation and presentation
open class HybridControllerWith<Object>: UIViewController where Object: ObservableObject {
    
    /// The observed object that provides data to the view controller.
    ///
    /// This property is read-only from outside the class and is automatically bound to SwiftUI's
    /// observation system. Changes to this object's `@Published` properties will automatically
    /// trigger UI updates.
    @ObservedObject public private(set) var observedObject: Object
    
    /// Creates a new hybrid view controller with the specified observed object.
    ///
    /// - Parameter observedObject: The `ObservableObject` instance that will provide data to the view controller.
    public init(observedObject: Object) {
        self.observedObject = observedObject
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Required initializer for loading from Interface Builder.
    ///
    /// - Parameter coder: An unarchiver object.
    /// - Note: This initializer is not implemented and will cause a fatal error if called.
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Override this property to provide your SwiftUI content with data binding.
    ///
    /// The default implementation returns `EmptyView()`. Subclasses should override this property
    /// to return the SwiftUI view that will be displayed in the view controller. You can access
    /// the observed object through the `observedObject` property and use `$observedObject` for bindings.
    ///
    /// ## Example
    ///
    /// ```swift
    /// override var body: any View {
    ///     VStack {
    ///         Text("Hello, \(observedObject.username)!")
    ///         TextField("Enter name", text: $observedObject.username)
    ///         Button("Save") {
    ///             observedObject.save()
    ///         }
    ///         .disabled(observedObject.isSaving)
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
    /// This method automatically embeds the SwiftUI content from the `body` property with proper
    /// data binding support. You typically don't need to override this method unless you have
    /// specific view setup requirements.
    override open func loadView() {
        super.loadView()
        
        addSwiftUIView(body)
    }
    
    /// Embeds a SwiftUI view with data binding into the view controller's view hierarchy.
    ///
    /// This private method handles the creation of a `UIHostingController` for the SwiftUI content
    /// with proper `ObservableObject` binding and sets up the necessary Auto Layout constraints.
    ///
    /// - Parameter view: The SwiftUI view to embed.
    private func addSwiftUIView(_ view: some View) {
        let hostingController = UIHostingController(rootView: HybridViewWith(observedObject, content: { [unowned self] in
            self.body
        }))
        
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

/// A private SwiftUI view that wraps the content with an observed object for data binding.
///
/// This internal view ensures that the SwiftUI content receives proper updates when the
/// observed object's published properties change.
private struct HybridViewWith<ViewModel>: View where ViewModel: ObservableObject {
    
    /// The content closure that returns the SwiftUI view to display.
    private let content: () -> any View
    
    /// The observed view model that provides data binding.
    @ObservedObject private var viewModel: ViewModel
    
    /// Creates a new hybrid view with data binding.
    ///
    /// - Parameters:
    ///   - viewModel: The observable object to bind to.
    ///   - content: A view builder closure that returns the content to display.
    init(_ viewModel: ViewModel, @ViewBuilder content: @escaping () -> any View) {
        self.viewModel = viewModel
        self.content = content
    }
    
    /// The body of the SwiftUI view.
    var body: some View {
        AnyView(content())
    }
}
#endif

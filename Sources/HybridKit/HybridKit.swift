/// # HybridKit
///
/// A Swift package that enables seamless integration between UIKit and SwiftUI components.
///
/// ## Overview
///
/// HybridKit is a powerful framework that bridges UIKit and SwiftUI, allowing developers to embed
/// SwiftUI views within UIKit components. This enables gradual migration from UIKit to SwiftUI or
/// the use of SwiftUI's declarative syntax within existing UIKit-based applications.
///
/// The framework provides hybrid versions of common UIKit components:
/// - View Controllers (`HybridController`, `HybridControllerWith`)
/// - Table View Cells (`HybridTableViewCell`, `HybridTableViewCellWith`)
/// - Table View Header/Footer Views (`HybridTableHeaderFooterView`, `HybridTableHeaderFooterViewWith`)
///
/// ## Getting Started
///
/// ### Basic View Controller
///
/// ```swift
/// import HybridKit
/// import SwiftUI
///
/// class MyViewController: HybridController {
///     override var body: any View {
///         VStack {
///             Text("Hello, HybridKit!")
///             Button("Tap me") {
///                 // Handle button tap
///             }
///         }
///         .padding()
///     }
/// }
/// ```
///
/// ### View Controller with Data Binding
///
/// ```swift
/// class MyViewModel: ObservableObject {
///     @Published var text: String = "Hello"
/// }
///
/// class DataViewController: HybridControllerWith<MyViewModel> {
///     override var body: any View {
///         VStack {
///             Text(observedObject.text)
///             TextField("Enter text", text: $observedObject.text)
///         }
///         .padding()
///     }
/// }
/// ```
///
/// ## Platform Support
///
/// - **iOS**: ✅ Supported
/// - **macOS**: ❌ Not supported (UIKit dependency)
/// - **watchOS**: ❌ Not supported (UIKit dependency)
/// - **tvOS**: ✅ Should work (UIKit available)
///
/// ## Requirements
///
/// - iOS 13.0+
/// - Swift 5.0+
/// - Xcode 11.0+


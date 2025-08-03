# HybridControllerWith

A view controller class that embeds SwiftUI views and provides data binding through an `ObservableObject`.

## Overview

`HybridControllerWith` extends the capabilities of ``HybridController`` by adding support for SwiftUI's `@ObservableObject` data binding. This enables reactive UI updates and seamless communication between UIKit and SwiftUI components.

## Declaration

```swift
open class HybridControllerWith<Object>: UIViewController where Object: ObservableObject
```

## Generic Parameters

- `Object`: An `ObservableObject` that serves as the data source for the view controller

## Usage

Create a view model conforming to `ObservableObject` and subclass `HybridControllerWith`:

```swift
// 1. Create a view model
class ProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func saveProfile() {
        isLoading = true
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            // Handle success or error
        }
    }
}

// 2. Create the view controller
class ProfileViewController: HybridControllerWith<ProfileViewModel> {
    override var body: any View {
        Form {
            Section("Personal Information") {
                TextField("Name", text: $observedObject.name)
                TextField("Email", text: $observedObject.email)
                    .keyboardType(.emailAddress)
            }
            
            Section {
                Button("Save Profile") {
                    observedObject.saveProfile()
                }
                .disabled(observedObject.isLoading)
            }
            
            if observedObject.isLoading {
                ProgressView("Saving...")
            }
            
            if let error = observedObject.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
    }
}

// 3. Initialize and use
let viewModel = ProfileViewModel()
let profileVC = ProfileViewController(observedObject: viewModel)
```

## Key Features

- **Data Binding**: Full support for SwiftUI's `$` binding syntax
- **Reactive Updates**: UI automatically updates when the observed object changes
- **Type Safety**: Generic constraint ensures compile-time type safety
- **UIKit Integration**: Seamlessly integrate with UIKit navigation and presentation

## Properties

### observedObject

```swift
@ObservedObject public private(set) var observedObject: Object
```

The observed object that provides data to the view controller. This property is read-only from outside the class and is automatically bound to SwiftUI's observation system.

## Initialization

```swift
public init(observedObject: Object)
```

Creates a new hybrid view controller with the specified observed object.

**Parameters:**
- `observedObject`: The `ObservableObject` instance that will provide data to the view controller

## Advanced Usage Examples

### Complex Data Flow

```swift
class ShoppingCartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var totalPrice: Double = 0.0
    @Published var isCheckedOut: Bool = false
    
    func addItem(_ item: CartItem) {
        items.append(item)
        calculateTotal()
    }
    
    func removeItem(at index: Int) {
        items.remove(at: index)
        calculateTotal()
    }
    
    private func calculateTotal() {
        totalPrice = items.reduce(0) { $0 + $1.price }
    }
    
    func checkout() {
        // Handle checkout logic
        isCheckedOut = true
    }
}

class ShoppingCartViewController: HybridControllerWith<ShoppingCartViewModel> {
    override var body: any View {
        NavigationView {
            List {
                ForEach(observedObject.items.indices, id: \.self) { index in
                    HStack {
                        Text(observedObject.items[index].name)
                        Spacer()
                        Text("$\(observedObject.items[index].price, specifier: "%.2f")")
                    }
                    .swipeActions {
                        Button("Delete") {
                            observedObject.removeItem(at: index)
                        }
                        .tint(.red)
                    }
                }
                
                Section {
                    HStack {
                        Text("Total:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(observedObject.totalPrice, specifier: "%.2f")")
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationTitle("Shopping Cart")
            .toolbar {
                Button("Checkout") {
                    observedObject.checkout()
                }
                .disabled(observedObject.items.isEmpty)
            }
        }
    }
}
```

### UIKit Integration with Combine

```swift
import Combine

class NetworkingViewModel: ObservableObject {
    @Published var isConnected: Bool = true
    @Published var data: [String] = []
    @Published var errorAlert: AlertModel? = nil
    
    func fetchData() {
        // Simulate network request
    }
}

struct AlertModel {
    let title: String
    let message: String
}

class DataViewController: HybridControllerWith<NetworkingViewModel> {
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observe error alerts and present UIKit alerts
        observedObject.$errorAlert
            .compactMap { $0 }
            .sink { [weak self] alertModel in
                self?.presentAlert(alertModel)
            }
            .store(in: &cancellables)
        
        // Observe network status
        observedObject.$isConnected
            .sink { [weak self] isConnected in
                self?.updateNavigationTitle(isConnected: isConnected)
            }
            .store(in: &cancellables)
    }
    
    override var body: any View {
        List(observedObject.data, id: \.self) { item in
            Text(item)
        }
        .refreshable {
            observedObject.fetchData()
        }
        .overlay {
            if !observedObject.isConnected {
                VStack {
                    Image(systemName: "wifi.slash")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("No Internet Connection")
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private func presentAlert(_ alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.observedObject.errorAlert = nil
        })
        present(alert, animated: true)
    }
    
    private func updateNavigationTitle(isConnected: Bool) {
        navigationItem.title = isConnected ? "Data" : "Offline"
    }
}
```

### Form Validation

```swift
class RegistrationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    var isFormValid: Bool {
        !username.isEmpty &&
        !email.isEmpty &&
        email.contains("@") &&
        password.count >= 6 &&
        password == confirmPassword
    }
    
    var passwordMismatch: Bool {
        !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword
    }
}

class RegistrationViewController: HybridControllerWith<RegistrationViewModel> {
    override var body: any View {
        Form {
            Section("Account Information") {
                TextField("Username", text: $observedObject.username)
                    .textInputAutocapitalization(.never)
                
                TextField("Email", text: $observedObject.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            
            Section("Password") {
                SecureField("Password", text: $observedObject.password)
                SecureField("Confirm Password", text: $observedObject.confirmPassword)
                
                if observedObject.passwordMismatch {
                    Text("Passwords do not match")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            Section {
                Button("Register") {
                    // Handle registration
                }
                .disabled(!observedObject.isFormValid)
            }
        }
        .navigationTitle("Register")
    }
}
```

## Best Practices

### 1. View Model Design
- Keep view models focused and single-purpose
- Use `@Published` for properties that should trigger UI updates
- Implement business logic in the view model, not the view

### 2. Memory Management
- Store Combine subscriptions in `cancellables` set
- Use `[weak self]` in closures to prevent retain cycles
- Clean up subscriptions in `deinit` if needed

### 3. Error Handling
- Use published properties for error states
- Present UIKit alerts for errors that require user interaction
- Consider using enums for different error types

### 4. Performance
- Avoid expensive computations in computed properties that depend on `@Published` values
- Use debouncing for text input validation
- Consider using `@StateObject` vs `@ObservedObject` appropriately

## Testing

```swift
import XCTest
@testable import YourApp

class ProfileViewModelTests: XCTestCase {
    var viewModel: ProfileViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ProfileViewModel()
    }
    
    func testNameBinding() {
        // Given
        let expectation = XCTestExpectation(description: "Name updated")
        
        // When
        let cancellable = viewModel.$name
            .dropFirst()
            .sink { name in
                XCTAssertEqual(name, "John Doe")
                expectation.fulfill()
            }
        
        viewModel.name = "John Doe"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        cancellable.cancel()
    }
}
```

## See Also

- ``HybridController``
- [ObservableObject Documentation](https://developer.apple.com/documentation/combine/observableobject)
- [Combine Framework](https://developer.apple.com/documentation/combine)
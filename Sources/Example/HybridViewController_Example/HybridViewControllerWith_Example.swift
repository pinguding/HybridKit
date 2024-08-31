//
//  File.swift
//  
//
//  Created by 박종우 on 8/31/24.
//
#if !os(macOS)
import UIKit

class HomeViewController: HybridControllerWith<HomeViewModel> {
    
    private var cancellable: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observedObject.$presentError
            .sink { [weak self] optionalError in
                guard let error = optionalError else { return }
                
                let alertController = UIAlertController(title: "Error Occured", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Confirmed", style: .default) { _ in
                    self?.observedObject.presentError = nil
                }
                alertController.addAction(alertAction)
                
                self?.present(alertController, animated: true)
            }
            .store(in: &cancellable)
    }
    
    override var body: any View {
        List {
            Section(header: Text("Navigation")) {
                Button(action: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }, label: {
                    Text("Pop back")
                })
                
                Button(action: { [weak self] in
                    self?.navigationController?.popToRootViewController(animated: true)
                }, label: {
                    Text("Pop to Root")
                })
                
                Button(action: { [weak self] in
                    let viewController = HomeViewController(observedObject: .init())
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }, label: {
                    Text("Self Push")
                })
            }
            
            Section(header: Text("Text Input")) {
                TextField("Text Field", text: $observedObject.textFieldInput)
            }
            
            Section(header: Text("Send data to ViewController")) {
                Button(action: { [weak self] in
                    self?.observedObject.presentError = URLError(.badURL)
                }, label: {
                    Text("Present Alert Controller")
                })
            }
        }
    }
}
#endif

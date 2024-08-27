//
//  HybridControllerWith.swift
//
//
//  Created by 박종우 on 8/27/24.
//

import SwiftUI

open class HybridControllerWith<ViewModel>: UIViewController where ViewModel: ObservableObject {
    
    @ObservedObject public private(set) var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open var body: any View {
        EmptyView()
    }
    
    override open func loadView() {
        super.loadView()
        
        addSwiftUIView(body)
    }
    
    private func addSwiftUIView(_ view: some View) {
        let hostingController = UIHostingController(rootView: HybridViewWith(viewModel, content: { [unowned self] in
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

private struct HybridViewWith<ViewModel>: View where ViewModel: ObservableObject {
    
    private let content: () -> any View
    
    @ObservedObject private var viewModel: ViewModel
    
    init(_ viewModel: ViewModel, @ViewBuilder content: @escaping () -> any View) {
        self.viewModel = viewModel
        self.content = content
    }
    
    var body: some View {
        AnyView(content())
    }
}

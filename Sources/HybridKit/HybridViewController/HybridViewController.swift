//
//  HybridViewController.swift
//  
//
//  Created by 박종우 on 8/27/24.
//

import SwiftUI

open class HybridController: UIViewController {
        
    public init() {
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

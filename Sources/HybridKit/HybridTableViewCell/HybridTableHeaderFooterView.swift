//
//  HybridTableHeaderFooterView.swift
//  HybridKit
//
//  Created by 박종우 on 10/20/24.
//
#if !os(macOS)
import SwiftUI

open class HybridTableHeaderFooterView: UITableViewHeaderFooterView {

    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentView.subviews.forEach { view in
            let viewConstraints = view.constraints
            view.removeConstraints(viewConstraints)
            view.removeFromSuperview()
        }
    }
    
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
    
    open func body() -> any View {
        EmptyView()
    }
}

#endif


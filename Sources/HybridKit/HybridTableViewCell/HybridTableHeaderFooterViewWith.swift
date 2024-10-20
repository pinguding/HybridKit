//
//  File.swift
//  HybridKit
//
//  Created by 박종우 on 10/20/24.
//

#if !os(macOS)
import SwiftUI

open class HybridTableHeaderFooterViewWith<HeaderFooterConfigurable>: UITableViewHeaderFooterView {
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentView.subviews.forEach { view in
            let constraints = view.constraints
            view.removeConstraints(constraints)
            view.removeFromSuperview()
        }
    }
    
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
    
    open func body(with configure: HeaderFooterConfigurable) -> any View {
        EmptyView()
    }
}

#endif

//
//  File.swift
//  HybridKit
//
//  Created by 박종우 on 10/8/24.
//
#if !os(macOS)
import SwiftUI

open class HybridTableViewCellWith<CellConfigure>: UITableViewCell {
    
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentView.subviews.forEach { view in
            let viewConstraints = view.constraints
            view.removeConstraints(viewConstraints)
            view.removeFromSuperview()
        }
    }
    
    public final func configure(with configure: CellConfigure) {
        guard let uiView = UIHostingController(rootView: AnyView(body(with: configure))).view else { return }
        
        self.contentView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            uiView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            uiView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            uiView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    open func body(with configure: CellConfigure) -> any View {
        EmptyView()
    }
}

#endif

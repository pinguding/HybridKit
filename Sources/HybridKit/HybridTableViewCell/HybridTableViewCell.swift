//
//  File.swift
//  
//
//  Created by 박종우 on 8/31/24.
//
#if !os(macOS)
import SwiftUI

open class HybridTableViewCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        guard let uiView = UIHostingController(rootView: AnyView(body)).view else { return }
        
        uiView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: contentView.topAnchor),
            uiView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open var body: any View {
        EmptyView()
    }
}
#endif

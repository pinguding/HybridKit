//
//  File.swift
//  HybridKit
//
//  Created by 박종우 on 10/8/24.
//
#if !os(macOS)
import SwiftUI

open class HybridTableViewCellWith<CellConfigure>: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        guard let uiView = UIHostingController(rootView: AnyView(body())).view else { return }
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func body(with configure: CellConfigure) -> any View {
        EmptyView()
    }
}

#endif

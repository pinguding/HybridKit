//
//  HybridTableViewCellWith_Example.swift
//  HybridKit
//
//  Created by 박종우 on 10/20/24.
//

#if !os(macOS)
import SwiftUI

class SampleHybridTableViewCell: HybridTableViewCellWith<String> {
    
    override func body(with configure: String) -> any View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    Color.green
                        .frame(width: 100,height: 100)
                    Color.red
                        .frame(width: 100,height: 100)
                    Color.blue
                        .frame(width: 100,height: 100)
                    Color.black
                        .frame(width: 100,height: 100)
                    Color.gray
                        .frame(width: 100,height: 100)
                }
            }
            
            HStack(spacing: 0) {
                Image(systemName: "house.fill")
                    .resizable()
                    .frame(width: 16, height: 16, alignment: .center)
                
                Spacer()
                
                Text(configure)
                    .font(.system(size: 20, weight: .bold))
            }
        }
        .padding(16)
    }
}


#endif

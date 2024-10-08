//
//  File.swift
//  
//
//  Created by 박종우 on 8/31/24.
//
#if !os(macOS)

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var textFieldInput: String = ""
    
    @Published var presentError: Error? = nil
}
#endif

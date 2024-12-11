//
//  Environment++.swift
//


import SwiftUI

extension EnvironmentValues {
    @Entry var searchText = ""
    @Entry var codeBlockFontSize: CGFloat = 14
    @Entry var highlightCode: Bool = true
}

public extension View {
    func searchText(_ text: String) -> some View {
        environment(\.searchText, text)
    }
    
    func codeBlockFontSize(_ size: CGFloat) -> some View {
        environment(\.codeBlockFontSize, size)
    }
    
    func highlightCode(_ highlight: Bool) -> some View {
        environment(\.highlightCode, highlight)
    }
}

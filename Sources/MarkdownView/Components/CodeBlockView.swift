//
//  CodeBlockView.swift
//

import SwiftUI
import HighlightSwift

struct CodeBlockView: View {
    @Environment(\.highlightCode) var highlightCode
    @Environment(\.codeBlockFontSize) var codeBlockFontSize
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.searchText) private var searchText
    
    let language: String?
    let sourceCode: String
    
    init(language: String? = nil, sourceCode: String) {
        self.sourceCode = sourceCode.trimmingCharacters(in: .whitespacesAndNewlines)
        self.language = language
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {

            Group {
                if highlightCode {
                    CodeText(sourceCode)
                        .codeTextColors(.theme(.atomOne))
                        .highlightedString(searchText)
                } else {
                    Text(sourceCode)
                }
            }
            .font(.system(size: codeBlockFontSize, weight: .regular, design: .monospaced))
            .padding()
                
            CustomCopyButton(content: sourceCode)
                .padding(5)
                .offset(y: -30) // Adjust this value as needed
                .padding(.bottom, -30) // This counteracts the offset to prevent extra space
            
        }
        .roundedRectangleOverlay(radius: 6)
        .background(color.opacity(0.05), in: RoundedRectangle(cornerRadius: 6))
    }
    
    
    var color: Color {
        colorScheme == .dark ? .black : .gray
    }
}

struct CustomCopyButton: View {
    @State var clicked = false
    var content: String
    
    var body: some View {
        Button {
            withAnimation {
                clicked = true
            }
            content.copyToPasteboard()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    clicked = false
                }
            }
        } label: {
            Image(systemName: clicked ? "checkmark" : "square.on.square")
                .imageScale(.medium)
                .bold()
                .frame(width: 12, height: 12)
                .padding(7)
                .contentShape(Rectangle())
        }
        .contentTransition(.symbolEffect(.replace))
        .buttonStyle(.borderless)
    }
}


extension View {
    func roundedRectangleOverlay(radius: CGFloat = 20, opacity: CGFloat = 0.8) -> some View {
        self.modifier(RoundedRectangleOverlayModifier(radius: radius, opacity: opacity))
    }
}


struct RoundedRectangleOverlayModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    var radius: CGFloat = 20
    var opacity: CGFloat = 0.8
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                #if os(macOS)
                    .stroke(.tertiary, lineWidth: 0.6)
                #elseif os(visionOS)
                    .stroke(Color(.quaternaryLabel), lineWidth: 1)
                #else
                    .stroke(colorScheme == .dark ? Color(.tertiarySystemGroupedBackground) : Color(.tertiaryLabel), lineWidth: 1)
                #endif
                    .opacity(opacity)
            )
    }
}


extension String {
    func copyToPasteboard() {
        #if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(self, forType: .string)
        #else
        UIPasteboard.general.string = self
        #endif
    }
}

//
//  MarkdownView.swift
//

import Markdown
import SwiftUI


public struct MarkdownView: View {
    public let contents: [MarkupContent]
    
    public init(content: String) {
        let document = Document(
            parsing: content,
            options: [.parseBlockDirectives]
        )
        self.contents = MarkdownViewParser.parse(document: document)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(contents.enumerated()), id: \.offset) { _, content in
                MarkupContentView(content: content)
            }
        }
    }
}

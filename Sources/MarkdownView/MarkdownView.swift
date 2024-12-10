//
//  MarkdownView.swift
//

import Markdown
import SwiftUI


public struct MarkdownView: View {
    public let contents: [MarkupContent]
    public let searchText: String
    
    public init(content: String, searchText: String = "") {
        let document = Document(
            parsing: content,
            options: [.parseBlockDirectives]
        )
        self.contents = MarkdownViewParser.parse(document: document)
        self.searchText = searchText
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(contents.enumerated()), id: \.offset) { _, content in
                MarkupContentView(content: content, searchText: searchText)
            }
        }
    }
}

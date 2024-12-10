//
//  MarkupContentView.swift
//

import SwiftUI

public struct MarkupContentView: View {
    public let content: MarkupContent
    public let searchText: String

    public init(
        content: MarkupContent,
        searchText: String = ""
    ) {
        self.content = content
        self.searchText = searchText
    }


  public var body: some View {
    switch content {
    case .text(let text):
      SwiftUI.Text(text)
    case .thematicBreak:
      Divider()
    case .inlineCode(let code):
      InlineCodeView(code: code)
    case .strong(let children):
        InlineMarkupContentView(inlineContents: children, searchText: searchText)
        .bold()
    case .strikethrough(let children):
        InlineMarkupContentView(inlineContents: children, searchText: searchText)
        .strikethrough(pattern: .dash, color: .secondary)
    case .emphasis(let children):
        InlineMarkupContentView(inlineContents: children, searchText: searchText)
        .italic()
    case .doxygenParameter(let name, let children):
      DoxygenParameterView(name: name, children: children)
    case .doxygenReturns(let children):
      DoxygenReturnsView(children: children)
    case .blockDirective(let name, let arguments, let children):
      BlockDirectiveView(name: name, arguments: arguments, children: children)
    case .htmlBlock(let html):
      HTMLView(html: html)
    case .codeBlock(let language, let sourceCode):
      CodeBlockView(language: language, sourceCode: sourceCode, searchText: searchText)
        .id(sourceCode)
    case .link(let destination, let title, let children):
      LinkView(destination: destination, title: title, children: children)
    case .heading(let level, let children):
      HeadingView(level: level, children: children)
    case .paragraph(let children):
        InlineMarkupContentView(inlineContents: children, searchText: searchText)
    case .blockQuote(let kind, let children):
      BlockQuoteView(kind: kind, children: children)
    case .orderedList(let startIndex, let items):
      OrderedListView(startIndex: startIndex, items: items)
    case .unorderedList(let items):
      UnorderedListView(items: items)
    case .table(let head, let body):
      TableView(headItems: head, bodyItems: body)
    case .softBreak:
      EmptyView()
    }
  }
}

//
//  InlineMarkupContentView.swift
//

import SwiftUI
import LaTeXSwiftUI

public struct InlineMarkupContentView: View {
    @Environment(\.font) var font
    @Environment(\.searchText) var searchText
    public let inlineContents: [InlineMarkupContent]

    public init(inlineContents: [InlineMarkupContent]) {
        self.inlineContents = inlineContents
    }

  var contents: [[MultiContent]] {
    var container = AttributeContainer()
    container.font = font
    let contents = inlineContents.split { content in
      return content == .softBreak || content == .lineBreak
    }

    return contents.map { content in
        let multiContents = MultiContentParser.multiContents(
            contents: content,
            container: container,
            searchText: searchText
        ) { _, container in return container }
      let compressedMultiContents = MultiContentParser.compressMultiContents(
        multiContents: multiContents)
      return compressedMultiContents
    }
  }

  public var body: some View {
      ForEach(contents, id: \.self) { element in
        ForEach(element, id: \.self) { content in
        switch content {
        case .attributedString(let string):
          Text(string)
        case .latex(let latex):
            LaTeX(latex)
                .renderingStyle(.original)
                .renderingAnimation(.easeIn)
                .frame(height: 45)
                .scrollDisabled(true)
                .padding(.top, -10)
//                .border(.red)
        case .image(let title, let source, let link):
          if let imageURL = source.map({ URL(string: $0) }),
            let imageURL
          {
            if let link {
              Link(destination: link) {
                AsyncImage(url: imageURL) { image in
                  image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 100)
                } placeholder: {
                  Text(title)
                }
              }
            } else {
              AsyncImage(url: imageURL) { image in
                image
                  .resizable()
                  .scaledToFit()
                  .frame(maxWidth: 100)
              } placeholder: {
                Text(title)
              }
            }
          }
        case .inlineHTML(let html, let link):
          if let link {
            SwiftUI.Link(destination: link) {
              HTMLView(html: html)
            }
          } else {
            HTMLView(html: html)
          }
        }
      }
    }
  }
}

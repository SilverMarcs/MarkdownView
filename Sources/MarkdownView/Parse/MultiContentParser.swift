//
//  MultiContentParser.swift
//

import Foundation

public enum MultiContent: Hashable, Sendable {
  case attributedString(AttributedString)
  case latex(String)
  case image(title: String, source: String?, link: URL?)
  case inlineHTML(html: String, link: URL?)
}
public enum MultiContentParser {
    public static func multiContents(
        contents: some Sequence<InlineMarkupContent>,
        container: AttributeContainer,
        searchText: String = "",
        customAttribute: (String, AttributeContainer) -> AttributeContainer
    ) -> [MultiContent] {
        var multiContents: [MultiContent] = []

        for content in contents {
            switch content {
        case .text(let text):
            let attributedString = createHighlightedString(
                text: text,
                highlightedText: searchText,
                baseContainer: container
            )
            multiContents.append(.attributedString(attributedString))
      case .strong(let children):
        var container = container
        container.font = .bold(container.font ?? .body)()
        let contents = self.multiContents(
          contents: children,
          container: container,
          customAttribute: customAttribute
        )
        multiContents.append(contentsOf: contents)
      case .emphasis(let children):
        var container = container
        container.font = .italic(container.font ?? .body)()
        let contents = self.multiContents(
          contents: children,
          container: container,
          customAttribute: customAttribute
        )
        multiContents.append(contentsOf: contents)
      case .strikethrough(let children):
        var container = container
        container.strikethroughStyle = .single
        let contents = self.multiContents(
          contents: children,
          container: container,
          customAttribute: customAttribute
        )
        multiContents.append(contentsOf: contents)
      case .link(let destination, let title, let children):
        var container = container
        if let url = destination.map({ URL(string: $0) }) {
          container.link = url
          container.alternateDescription = title
        }

        let contents = self.multiContents(
          contents: children,
          container: container,
          customAttribute: customAttribute
        )
        multiContents.append(contentsOf: contents)
      case .inlineCode(let code):
        var container = container
        container.backgroundColor = .code
                // monospaced font
                container.font = .monospaced(container.font ?? .body)().width(.compressed)
        let attributedString = AttributedString(code, attributes: container)
        multiContents.append(.attributedString(attributedString))
      case .symbolLink(let destination):
        if let destination {
          var container = container
          container.backgroundColor = .symbolLink
          let attributedString = AttributedString(destination, attributes: container)
          multiContents.append(.attributedString(attributedString))
        }
      case .image(let title, let source):
        multiContents.append(.image(title: title, source: source, link: container.link))
      case .inlineAttributes(let attributes, let children):
        let container = customAttribute(attributes, container)
        let contents = self.multiContents(
          contents: children,
          container: container,
          customAttribute: customAttribute
        )
        multiContents.append(contentsOf: contents)
      case .softBreak, .lineBreak:
        continue
      case .inlineHTML(let html):
        multiContents.append(.inlineHTML(html: html, link: container.link))
        case .segments(let segments):
            for segment in segments {
                switch segment {
                case .text(let text):
                    let attributedString = createHighlightedString(
                        text: text,
                        highlightedText: searchText,
                        baseContainer: container
                    )
                    multiContents.append(.attributedString(attributedString))
                case .latex(let text):
                    multiContents.append(.latex(text))
                }
            }
      }
    }

    return multiContents
  }

  public static func compressMultiContents(multiContents: [MultiContent]) -> [MultiContent] {
    var multiContents = multiContents

    for i in (0..<multiContents.count).reversed() {
      let content1 = multiContents[i]
      guard let content2 = multiContents[safe: i - 1] else { continue }

      if case .attributedString(let attributedString1) = content1 {
        if case .attributedString(var attributedString2) = content2 {
          attributedString2.append(attributedString1)
          multiContents[i - 1] = .attributedString(attributedString2)
          multiContents.remove(at: i)
        }
      }
    }

    return multiContents
  }
    
    private static func createHighlightedString(
        text: String,
        highlightedText: String,
        baseContainer: AttributeContainer
    ) -> AttributedString {
        var attributedString = AttributedString(text, attributes: baseContainer)
        
        if !highlightedText.isEmpty {
            let lowercasedHighlight = highlightedText.lowercased()
            var searchRange = attributedString.startIndex..<attributedString.endIndex
            
            while let range = attributedString[searchRange].range(of: lowercasedHighlight, options: .caseInsensitive) {
                attributedString[range].backgroundColor = .yellow
                attributedString[range].foregroundColor = .black
                
                if range.upperBound >= searchRange.upperBound {
                    break
                }
                searchRange = range.upperBound..<searchRange.upperBound
            }
        }
        
        return attributedString
    }
}

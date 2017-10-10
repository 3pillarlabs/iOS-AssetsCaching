//
//  XMLParser.swift
//  3PGImageCacheLibrary
//
//  Created by Liliana Bulgaru on 26/08/16.
//  Copyright © 2016 Liliana Bulgaru. All rights reserved.
//

import UIKit

@objc protocol XMLParserDelegate {
    func parserDidFinishParsing()
}

class XMLParser: NSObject, Foundation.XMLParserDelegate {
    weak var delegate: XMLParserDelegate?

    private (set) var arrParsedData = [URL]()
    private var parser: Foundation.XMLParser?

    func startParsingWithContentsOfURL(_ rssURL: URL) {
        self.parser = Foundation.XMLParser(contentsOf: rssURL) ?? Foundation.XMLParser()
        self.parser?.delegate = self
        self.parser?.parse()
    }

    // MARK: NSXMLParserDelegate

    func parserDidEndDocument(_ parser: Foundation.XMLParser) {
        delegate?.parserDidFinishParsing()
    }

    func parser(_ parser: Foundation.XMLParser, foundCDATA CDATABlock: Data) {
        if let datastring = String(data: CDATABlock, encoding: String.Encoding.utf8) {
            let types: NSTextCheckingResult.CheckingType = .link
            do {
                let detector = try NSDataDetector(types: types.rawValue)
                let matches = detector.matches(in: datastring, options: .reportCompletion,
                                               range: NSRange(location: 0, length: datastring.characters.count))
                if let url = matches.first?.url, url.absoluteString.range(of: ".jpg") != nil,
                    !url.absoluteString.isEmpty, UIApplication.shared.canOpenURL(url) {
                    arrParsedData.append(url)
                }
            } catch {
                // none found or some other issue
            }
        }
    }
}

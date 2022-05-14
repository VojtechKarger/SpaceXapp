//
//  HighlightText.swift
//  SpaceXapp
//
//  Created by vojta on 13.05.2022.
//

import UIKit

func highlight(_ text: String, in word: String) -> NSMutableAttributedString? {
    if text.replacingOccurrences(of: " ", with: "") == "" {
        return nil
    }
    
    guard let range = word.lowercased().range(of: text.lowercased())?.nsRange(in: text) else { return nil }
    
    let attributedStr = NSMutableAttributedString(string: word)
    attributedStr.addAttributes([.foregroundColor: UIColor.red], range: range)
    return attributedStr
}


extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}

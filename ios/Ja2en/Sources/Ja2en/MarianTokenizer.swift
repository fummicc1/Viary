//
//  MarianTokenizer.swift
//  
//
//  Created by Fumiya Tanaka on 2023/04/24.
//

import Foundation

class MarianTokenizer {
    let vocab: [String: Int]
    let bosTokenId: Int
    let eosTokenId: Int

    init(vocab: [String: Int], bosTokenId: Int = 0, eosTokenId: Int = 0) {
        self.vocab = vocab
        self.bosTokenId = bosTokenId
        self.eosTokenId = eosTokenId
    }

    func tokenize(text: String) -> [String] {
        let tokens = text.components(separatedBy: " ")
        return tokens
    }

    func convertTokensToIds(tokens: [String]) -> [Int] {
        return tokens.compactMap { vocab[$0] }
    }

    func encode(text: String, maxLength: Int) -> [Int] {
        var ids = [bosTokenId]
        let tokens = tokenize(text: text)
        let tokenIds = convertTokensToIds(tokens: tokens)

        ids.append(contentsOf: tokenIds)
        ids.append(eosTokenId)

        if ids.count > maxLength {
            ids = Array(ids.prefix(maxLength))
        }

        return ids
    }
}

// Based on https://github.com/fummicc1/swift-coreml-transformers/blob/master/Sources/BertTokenizer.swift

import Foundation

enum TokenizerError: Error {
    case tooLong(String)
}

final class BertTokenizer: Sendable {
    private let basicTokenizer = BasicTokenizer()
    private let wordpieceTokenizer: WordpieceTokenizer
    private let maxLen = 512

    private let vocab: [String: Int]
    private let ids_to_tokens: [Int: String]

    init() {
        guard let bundle = Bundle.allBundles.first(where: { $0.bundleIdentifier == "Viary-Resources-resources" }) else {
            fatalError("Bundle (Viary-Resources-resources) does not exist.")
        }
        let url = bundle.url(forResource: "vocab", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let vocab = try! JSONSerialization.jsonObject(with: data) as! [String: Int]
        var ids_to_tokens: [Int: String] = [:]
        vocab.forEach { (key, val) in
            ids_to_tokens[val] = key
        }
        self.vocab = vocab
        self.ids_to_tokens = ids_to_tokens
        self.wordpieceTokenizer = WordpieceTokenizer(vocab: self.vocab)
    }


    func tokenize(text: String) -> [String] {
        var tokens: [String] = ["<s>"]
        for token in basicTokenizer.tokenize(text: text) {
            for subToken in wordpieceTokenizer.tokenize(word: token) {
                tokens.append(subToken)
            }
        }
        tokens.append("</s>")
        return tokens
    }

    private func convertTokensToIds(tokens: [String]) throws -> [Int] {
        if tokens.count > maxLen {
            throw TokenizerError.tooLong(
                """
                Token indices sequence length is longer than the specified maximum
                sequence length for this BERT model (\(tokens.count) > \(maxLen). Running this
                sequence through BERT will result in indexing errors".format(len(ids), self.max_len)
                """
            )
        }
        return tokens.map { vocab[$0]! }
    }

    /// Main entry point
    func tokenizeToIds(text: String) -> [Int] {
        return try! convertTokensToIds(
            tokens: tokenize(text: text)
        )
    }

    func tokenToId(token: String) -> Int {
        return vocab[token]!
    }

    /// Un-tokenization: get tokens from tokenIds
    func unTokenize(tokens: [Int]) -> [String] {
        return tokens.map { ids_to_tokens[$0]! }
    }

    /// Un-tokenization:
    func convertWordpieceToBasicTokenList(_ wordpieceTokenList: [String]) -> String {
        var tokenList: [String] = []
        var individualToken: String = ""

        for token in wordpieceTokenList {
            if token.starts(with: "##") {
                individualToken += String(token.suffix(token.count - 2))
            } else {
                if individualToken.count > 0 {
                    tokenList.append(individualToken)
                }

                individualToken = token
            }
        }

        tokenList.append(individualToken)

        return tokenList.joined(separator: " ")
    }
}



final class BasicTokenizer: Sendable {
    let neverSplit = [
        "<unk>", "<s>", "<pad>", "</s>"
    ]

    func tokenize(text: String) -> [String] {
        let splitTokens = text.folding(options: .diacriticInsensitive, locale: nil)
            .components(separatedBy: NSCharacterSet.whitespaces)
        var tokens = splitTokens.flatMap({ (token: String) -> [String] in
            if neverSplit.contains(token) {
                return [token]
            }
            var toks: [String] = []
            var currentTok = ""
            for c in token {
                if c.isLetter || c.isNumber || c == "°" {
                    currentTok += String(c)
                } else if currentTok.count > 0 {
                    toks.append(currentTok)
                    toks.append(String(c))
                    currentTok = ""
                } else {
                    toks.append(String(c))
                }
            }
            if currentTok.count > 0 {
                toks.append(currentTok)
            }
            return toks
        })
        var first = true
        tokens = tokens.map {
            defer {
                first = false
            }
            if !first {
                return " \($0)"
            }
            return $0
        }
        return tokens
    }
}


final class WordpieceTokenizer: Sendable {
    private let unkToken = "<unk>"
    private let maxInputCharsPerWord = 100
    private let vocab: [String: Int]

    init(vocab: [String: Int]) {
        self.vocab = vocab
    }

    /// `word`: A single token.
    /// Warning: this differs from the `pytorch-transformers` implementation.
    /// This should have already been passed through `BasicTokenizer`.
    func tokenize(word: String) -> [String] {
        if word.count > maxInputCharsPerWord {
            return [unkToken]
        }
        var outputTokens: [String] = []
        var isBad = false
        var start = 0
        var subTokens: [String] = []
        while start < word.count {
            var end = word.count
            var cur_substr: String? = nil
            while start < end {
                var substr = Utils.substr(word, start..<end)!
                if start > 0 {
                    substr = "##\(substr)"
                }
                if vocab[substr] != nil {
                    cur_substr = substr
                    break
                }
                end -= 1
            }
            if cur_substr == nil {
                isBad = true
                break
            }
            subTokens.append(cur_substr!)
            start = end
        }
        if isBad {
            outputTokens.append(unkToken)
        } else {
            outputTokens.append(contentsOf: subTokens)
        }
        return outputTokens
    }
}

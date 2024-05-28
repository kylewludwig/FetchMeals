//
//  RecipeParser.swift
//  FetchMeals
//
//  Created by Kyle Ludwig on 5/27/24.
//

import Foundation
import RegexBuilder

final class RecipeParser {
    static func parseInstructions(_ instructions: String) -> [String] {
        let separators = CharacterSet(charactersIn: ".!?") // Separate by ending punctuation
        let invalidInstructionRegexPatterns = [
            Regex {                     // Matches step + digit steps, e.g. "Step 1" (in any case combination)
                "Step "
                OneOrMore(.digit)
            },
            Regex {                     // Matches digit only steps, e.g. "1"
                OneOrMore(.digit)
            },
        ]
        return instructions
            .components(separatedBy: separators)
            .map { $0.replacingOccurrences(of: "\n", with: " ") }   // Remove newline characters
            .map { $0.replacingOccurrences(of: "\r", with: " ") }   // Remove carriage return characters
            .map { $0.trimmingCharacters(in: .whitespaces) }        // Remove starting and ending whitespace
            .filter { !$0.isEmpty }                                 // Remove empty strings
            .filter {                                               // Remove strings containing only step number, e.g. "STEP 1" or "1"
                for invalidPattern in invalidInstructionRegexPatterns {
                    if let _ = $0.wholeMatch(of: invalidPattern) {
                        return false
                    }
                }
                return true
            }
            .map { $0.trimmingCharacters(in: .decimalDigits) }      // Remove starting and ending digits
            .map { $0 + "."}                                        // Add "." to end of each instruction
    }
    
    static func parseIngredients(_ ingredients: [String]) -> [String] {
        return ingredients
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    
    static func parseMeasurements(_ measurements: [String]) -> [String] {
        return measurements
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}

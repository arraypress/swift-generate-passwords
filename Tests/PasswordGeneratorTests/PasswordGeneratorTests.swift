//
//  PasswordGeneratorTests.swift
//  SwiftGeneratePasswords
//
//  Comprehensive test suite for password generation
//  Created on 27/07/2025.
//

import XCTest
@testable import PasswordGenerator

final class PasswordGeneratorTests: XCTestCase {
    
    // MARK: - Bulk Generation Tests
    
    func testGenerateMultipleDefault() {
        let passwords = PasswordGenerator.generateMultiple(count: 5)
        
        XCTAssertEqual(passwords.count, 5, "Should generate 5 passwords")
        
        // All passwords should be 16 characters
        for password in passwords {
            XCTAssertEqual(password.count, 16, "Each password should be 16 characters")
        }
        
        // All passwords should be unique
        let uniquePasswords = Set(passwords)
        XCTAssertEqual(uniquePasswords.count, 5, "All passwords should be unique")
    }
    
    func testGenerateMultipleCustom() {
        let passwords = PasswordGenerator.generateMultiple(
            count: 3,
            length: 12,
            includeSymbols: false
        )
        
        XCTAssertEqual(passwords.count, 3, "Should generate 3 passwords")
        
        for password in passwords {
            XCTAssertEqual(password.count, 12, "Each password should be 12 characters")
            XCTAssertFalse(password.hasSymbols, "Should not contain symbols")
        }
    }
    
    func testGenerateMultipleCustomCharacterSet() {
        let hexPasswords = PasswordGenerator.generateMultiple(
            count: 4,
            length: 8,
            characterSet: "0123456789ABCDEF"
        )
        
        XCTAssertEqual(hexPasswords.count, 4, "Should generate 4 passwords")
        
        for password in hexPasswords {
            XCTAssertEqual(password.count, 8, "Each password should be 8 characters")
            XCTAssertTrue(password.allSatisfy { $0.isHexDigit }, "Should only contain hex characters")
        }
    }
    
    func testGenerateMultiplePronounceables() {
        let passwords = PasswordGenerator.generateMultiplePronounceables(
            count: 3,
            length: 10
        )
        
        XCTAssertEqual(passwords.count, 3, "Should generate 3 passwords")
        
        for password in passwords {
            XCTAssertEqual(password.count, 10, "Each password should be 10 characters")
            // Should end with 2 digits by default
            let lastTwoChars = String(password.suffix(2))
            XCTAssertTrue(lastTwoChars.allSatisfy { $0.isNumber }, "Should end with 2 digits")
        }
    }
    
    func testGenerateMultipleCountBounds() {
        // Test minimum bound (should clamp to 1)
        let tooFew = PasswordGenerator.generateMultiple(count: 0)
        XCTAssertEqual(tooFew.count, 1, "Count should be clamped to minimum of 1")
        
        // Test maximum bound (should clamp to 1000)
        let tooMany = PasswordGenerator.generateMultiple(count: 1500)
        XCTAssertEqual(tooMany.count, 1000, "Count should be clamped to maximum of 1000")
        
        // Test negative count (should clamp to 1)
        let negative = PasswordGenerator.generateMultiple(count: -5)
        XCTAssertEqual(negative.count, 1, "Negative count should be clamped to 1")
    }
    
    func testGenerateMultipleUniqueness() {
        // Generate 50 passwords and ensure they're all unique
        let passwords = PasswordGenerator.generateMultiple(count: 50)
        let uniquePasswords = Set(passwords)
        
        XCTAssertEqual(uniquePasswords.count, 50, "All 50 passwords should be unique")
    }
    
    // MARK: - Basic Generation Tests
    
    func testDefaultGeneration() {
        let password = PasswordGenerator.generate()
        
        // Should be 16 characters by default
        XCTAssertEqual(password.count, 16, "Default password should be 16 characters")
        
        // Should only contain valid characters (no spaces, control chars, etc.)
        XCTAssertTrue(password.allSatisfy { char in
            char.isLetter || char.isNumber || "!@#$%^&*()_+-=[]{}|;:,.<>?".contains(char)
        }, "Should only contain valid password characters")
        
        // Test that over multiple generations, we get character diversity
        var hasFoundAllTypes = false
        for _ in 0..<50 { // Try multiple times to find a password with all types
            let testPassword = PasswordGenerator.generate()
            if testPassword.hasUppercase && testPassword.hasLowercase &&
                testPassword.hasNumbers && testPassword.hasSymbols {
                hasFoundAllTypes = true
                break
            }
        }
        XCTAssertTrue(hasFoundAllTypes, "Should be able to generate passwords with all character types")
    }
    
    func testCustomLength() {
        let testLengths = [4, 8, 12, 16, 24, 32, 64, 128]
        
        for length in testLengths {
            let password = PasswordGenerator.generate(length: length)
            XCTAssertEqual(password.count, length, "Password should be \(length) characters")
        }
    }
    
    func testLengthBounds() {
        // Test minimum bound (should clamp to 4)
        let tooShort = PasswordGenerator.generate(length: 1)
        XCTAssertEqual(tooShort.count, 4, "Length should be clamped to minimum of 4")
        
        // Test maximum bound (should clamp to 128)
        let tooLong = PasswordGenerator.generate(length: 200)
        XCTAssertEqual(tooLong.count, 128, "Length should be clamped to maximum of 128")
        
        // Test negative length (should clamp to 4)
        let negative = PasswordGenerator.generate(length: -5)
        XCTAssertEqual(negative.count, 4, "Negative length should be clamped to 4")
    }
    
    // MARK: - Character Set Tests
    
    func testUppercaseOnly() {
        let password = PasswordGenerator.generate(
            length: 20,
            includeUppercase: true,
            includeLowercase: false,
            includeNumbers: false,
            includeSymbols: false
        )
        
        XCTAssertEqual(password.count, 20, "Should generate correct length")
        XCTAssertTrue(password.hasUppercase, "Should contain uppercase")
        XCTAssertFalse(password.hasLowercase, "Should not contain lowercase")
        XCTAssertFalse(password.hasNumbers, "Should not contain numbers")
        XCTAssertFalse(password.hasSymbols, "Should not contain symbols")
    }
    
    func testLowercaseOnly() {
        let password = PasswordGenerator.generate(
            length: 20,
            includeUppercase: false,
            includeLowercase: true,
            includeNumbers: false,
            includeSymbols: false
        )
        
        XCTAssertTrue(password.hasLowercase, "Should contain lowercase")
        XCTAssertFalse(password.hasUppercase, "Should not contain uppercase")
        XCTAssertFalse(password.hasNumbers, "Should not contain numbers")
        XCTAssertFalse(password.hasSymbols, "Should not contain symbols")
    }
    
    func testNumbersOnly() {
        let password = PasswordGenerator.generate(
            length: 15,
            includeUppercase: false,
            includeLowercase: false,
            includeNumbers: true,
            includeSymbols: false
        )
        
        XCTAssertTrue(password.hasNumbers, "Should contain numbers")
        XCTAssertFalse(password.hasUppercase, "Should not contain uppercase")
        XCTAssertFalse(password.hasLowercase, "Should not contain lowercase")
        XCTAssertFalse(password.hasSymbols, "Should not contain symbols")
        
        // All characters should be digits
        XCTAssertTrue(password.allSatisfy { $0.isNumber }, "All characters should be digits")
    }
    
    func testSymbolsOnly() {
        let password = PasswordGenerator.generate(
            length: 10,
            includeUppercase: false,
            includeLowercase: false,
            includeNumbers: false,
            includeSymbols: true
        )
        
        XCTAssertTrue(password.hasSymbols, "Should contain symbols")
        XCTAssertFalse(password.hasUppercase, "Should not contain uppercase")
        XCTAssertFalse(password.hasLowercase, "Should not contain lowercase")
        XCTAssertFalse(password.hasNumbers, "Should not contain numbers")
    }
    
    func testNoCharacterTypesSelected() {
        // Should fallback to alphanumeric when no types selected
        let password = PasswordGenerator.generate(
            length: 12,
            includeUppercase: false,
            includeLowercase: false,
            includeNumbers: false,
            includeSymbols: false
        )
        
        XCTAssertEqual(password.count, 12, "Should still generate correct length")
        // Should fallback to alphanumeric
        XCTAssertTrue(password.hasUppercase || password.hasLowercase || password.hasNumbers,
                      "Should contain alphanumeric characters as fallback")
    }
    
    // MARK: - Custom Character Set Tests
    
    func testCustomCharacterSet() {
        let customChars = "ABC123"
        let password = PasswordGenerator.generate(length: 20, characterSet: customChars)
        
        XCTAssertEqual(password.count, 20, "Should generate correct length")
        
        // All characters should be from the custom set
        for char in password {
            XCTAssertTrue(customChars.contains(char), "Character '\(char)' should be from custom set")
        }
    }
    
    func testHexCharacterSet() {
        let hexChars = "0123456789ABCDEF"
        let password = PasswordGenerator.generate(length: 16, characterSet: hexChars)
        
        // Should look like a hex string
        XCTAssertTrue(password.allSatisfy { $0.isHexDigit }, "All characters should be valid hex digits")
    }
    
    func testEmptyCustomCharacterSet() {
        // Should fallback to default generation
        let password = PasswordGenerator.generate(length: 10, characterSet: "")
        
        XCTAssertEqual(password.count, 10, "Should still generate password with fallback")
        XCTAssertTrue(password.hasUppercase || password.hasLowercase || password.hasNumbers || password.hasSymbols,
                      "Should contain some character types from fallback")
    }
    
    // MARK: - Pronounceable Password Tests
    
    func testPronounceablePassword() {
        let password = PasswordGenerator.generatePronounceablePassword(length: 12)
        
        XCTAssertEqual(password.count, 12, "Should generate correct length")
        
        // Should end with 2 digits by default
        let lastTwoChars = String(password.suffix(2))
        XCTAssertTrue(lastTwoChars.allSatisfy { $0.isNumber }, "Should end with 2 digits")
        
        // First part should be letters only
        let letterPart = String(password.dropLast(2))
        XCTAssertTrue(letterPart.allSatisfy { $0.isLetter }, "Letter part should contain only letters")
    }
    
    func testPronounceablePasswordWithoutNumbers() {
        let password = PasswordGenerator.generatePronounceablePassword(length: 10, includeNumbers: false)
        
        XCTAssertEqual(password.count, 10, "Should generate correct length")
        XCTAssertTrue(password.allSatisfy { $0.isLetter }, "Should contain only letters")
        XCTAssertFalse(password.hasNumbers, "Should not contain numbers")
    }
    
    func testPronounceablePasswordLengthBounds() {
        // Test minimum bound
        let tooShort = PasswordGenerator.generatePronounceablePassword(length: 3)
        XCTAssertEqual(tooShort.count, 6, "Should be clamped to minimum of 6")
        
        // Test maximum bound
        let tooLong = PasswordGenerator.generatePronounceablePassword(length: 100)
        XCTAssertEqual(tooLong.count, 64, "Should be clamped to maximum of 64")
    }
    
    // MARK: - Entropy Calculation Tests
    
    func testEntropyCalculation() {
        // Test known entropy values
        let entropy1 = PasswordGenerator.entropy(length: 1, characterSetSize: 2)
        XCTAssertEqual(entropy1, 1.0, accuracy: 0.01, "1 char from 2 should be 1 bit")
        
        let entropy2 = PasswordGenerator.entropy(length: 8, characterSetSize: 26)
        let expected2 = 8.0 * log2(26.0) // ~37.6 bits
        XCTAssertEqual(entropy2, expected2, accuracy: 0.1, "Entropy calculation should be accurate")
        
        let entropy3 = PasswordGenerator.entropy(length: 16, characterSetSize: 95)
        let expected3 = 16.0 * log2(95.0) // ~105.3 bits
        XCTAssertEqual(entropy3, expected3, accuracy: 0.1, "Full character set entropy should be accurate")
    }
    
    func testEntropyEdgeCases() {
        // Zero length should return 0
        XCTAssertEqual(PasswordGenerator.entropy(length: 0, characterSetSize: 95), 0.0)
        
        // Zero character set size should return 0
        XCTAssertEqual(PasswordGenerator.entropy(length: 16, characterSetSize: 0), 0.0)
        
        // Negative values should return 0
        XCTAssertEqual(PasswordGenerator.entropy(length: -1, characterSetSize: 95), 0.0)
        XCTAssertEqual(PasswordGenerator.entropy(length: 16, characterSetSize: -10), 0.0)
    }
    
    // MARK: - Character Set Info Tests
    
    func testCharacterSetInfo() {
        let info = PasswordGenerator.characterSetInfo()
        
        XCTAssertEqual(info.uppercaseSize, 26, "Should have 26 uppercase letters")
        XCTAssertEqual(info.lowercaseSize, 26, "Should have 26 lowercase letters")
        XCTAssertEqual(info.numbersSize, 10, "Should have 10 numbers")
        XCTAssertGreaterThan(info.symbolsSize, 10, "Should have multiple symbols")
        XCTAssertEqual(info.fullSetSize, 26 + 26 + 10 + info.symbolsSize, "Full set should be sum of all")
        XCTAssertGreaterThan(info.entropyPerCharacterFull, 6.0, "Should have reasonable entropy per character")
    }
    
    // MARK: - Password Analysis Tests
    
    func testPasswordAnalysisStrong() {
        let strongPassword = "Kj9#mP$2vX@z"
        let analysis = PasswordGenerator.analyzePassword(strongPassword)
        
        XCTAssertEqual(analysis.length, 12)
        XCTAssertTrue(analysis.hasUppercase)
        XCTAssertTrue(analysis.hasLowercase)
        XCTAssertTrue(analysis.hasNumbers)
        XCTAssertTrue(analysis.hasSymbols)
        XCTAssertGreaterThan(analysis.entropy, 60, "Should have high entropy")
        XCTAssertEqual(analysis.strengthLevel, .strong)
        XCTAssertEqual(analysis.diversityScore, 1.0, "Should have maximum diversity")
    }
    
    func testPasswordAnalysisWeak() {
        let weakPassword = "password"
        let analysis = PasswordGenerator.analyzePassword(weakPassword)
        
        XCTAssertEqual(analysis.length, 8)
        XCTAssertFalse(analysis.hasUppercase)
        XCTAssertTrue(analysis.hasLowercase)
        XCTAssertFalse(analysis.hasNumbers)
        XCTAssertFalse(analysis.hasSymbols)
        XCTAssertLessThan(analysis.entropy, 40, "Should have relatively low entropy")
        XCTAssertTrue([.veryWeak, .weak].contains(analysis.strengthLevel), "Should be weak or very weak")
        XCTAssertLessThan(analysis.diversityScore, 0.5, "Should have low diversity")
        XCTAssertFalse(analysis.suggestions.isEmpty, "Should have improvement suggestions")
    }
    
    func testPasswordAnalysisEmpty() {
        let analysis = PasswordGenerator.analyzePassword("")
        
        XCTAssertEqual(analysis.length, 0)
        XCTAssertEqual(analysis.entropy, 0.0)
        XCTAssertEqual(analysis.strengthLevel, .veryWeak)
        XCTAssertEqual(analysis.diversityScore, 0.0)
    }
    
    // MARK: - Randomness and Uniqueness Tests
    
    func testRandomnessAndUniqueness() {
        var generatedPasswords = Set<String>()
        let iterations = 100
        
        // Generate many passwords and ensure they're unique
        for _ in 0..<iterations {
            let password = PasswordGenerator.generate()
            generatedPasswords.insert(password)
        }
        
        // Should have generated all unique passwords
        let uniqueCount = generatedPasswords.count
        XCTAssertEqual(uniqueCount, iterations, "All generated passwords should be unique")
    }
    
    func testRandomnessDistribution() {
        var characterCounts: [Character: Int] = [:]
        let iterations = 10000 // Increased for better distribution
        
        // Generate many single-character passwords and check distribution
        for _ in 0..<iterations {
            let password = PasswordGenerator.generate(length: 1)
            let char = password.first!
            characterCounts[char, default: 0] += 1
        }
        
        // Should have a reasonable number of unique characters
        let uniqueCharacters = characterCounts.keys.count
        XCTAssertGreaterThan(uniqueCharacters, 50, "Should generate a good variety of characters")
        
        // No single character should dominate (appear more than 5% of the time)
        let maxCount = characterCounts.values.max() ?? 0
        let maxPercentage = Double(maxCount) / Double(iterations)
        XCTAssertLessThan(maxPercentage, 0.05, "No character should appear more than 5% of the time")
        
        // Should use characters from different character sets
        let hasUppercase = characterCounts.keys.contains { $0.isUppercase }
        let hasLowercase = characterCounts.keys.contains { $0.isLowercase }
        let hasNumbers = characterCounts.keys.contains { $0.isNumber }
        let hasSymbols = characterCounts.keys.contains { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) }
        
        XCTAssertTrue(hasUppercase, "Should generate uppercase characters")
        XCTAssertTrue(hasLowercase, "Should generate lowercase characters")
        XCTAssertTrue(hasNumbers, "Should generate number characters")
        XCTAssertTrue(hasSymbols, "Should generate symbol characters")
    }
    
    // MARK: - Performance Tests
    
    func testGenerationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = PasswordGenerator.generate()
            }
        }
    }
    
    func testLongPasswordPerformance() {
        measure {
            for _ in 0..<100 {
                _ = PasswordGenerator.generate(length: 128)
            }
        }
    }
    
    func testBulkGenerationPerformance() {
        measure {
            _ = PasswordGenerator.generateMultiple(count: 100)
        }
    }
    
    func testCustomCharacterSetPerformance() {
        let customChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()"
        
        measure {
            for _ in 0..<1000 {
                _ = PasswordGenerator.generate(length: 16, characterSet: customChars)
            }
        }
    }
    
    // MARK: - Edge Cases
    
    func testVeryLongCustomCharacterSet() {
        let longCharSet = String(repeating: "ABC123!@#", count: 100)
        let password = PasswordGenerator.generate(length: 20, characterSet: longCharSet)
        
        XCTAssertEqual(password.count, 20, "Should handle very long character sets")
    }
    
    func testSingleCharacterSet() {
        let password = PasswordGenerator.generate(length: 10, characterSet: "A")
        
        XCTAssertEqual(password.count, 10, "Should generate correct length")
        XCTAssertEqual(password, "AAAAAAAAAA", "Should repeat single character")
    }
    
    func testUnicodeCharacterSet() {
        let unicodeChars = "αβγδε123🎯🚀"
        let password = PasswordGenerator.generate(length: 8, characterSet: unicodeChars)
        
        XCTAssertEqual(password.count, 8, "Should handle Unicode characters")
        
        for char in password {
            XCTAssertTrue(unicodeChars.contains(char), "Should only use Unicode characters from set")
        }
    }
}

// MARK: - Helper Extensions for Testing

private extension String {
    var hasUppercase: Bool {
        return rangeOfCharacter(from: .uppercaseLetters) != nil
    }
    
    var hasLowercase: Bool {
        return rangeOfCharacter(from: .lowercaseLetters) != nil
    }
    
    var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    var hasSymbols: Bool {
        let symbolSet = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,.<>?")
        return rangeOfCharacter(from: symbolSet) != nil
    }
}

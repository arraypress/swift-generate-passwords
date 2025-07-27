//
//  PasswordGenerator.swift
//  SwiftGeneratePasswords
//
//  Cryptographically secure password generation
//  Created on 27/07/2025.
//

import Foundation
import Security

// MARK: - Main Public API

public struct PasswordGenerator {
    
    /// Generate a secure password with default settings.
    ///
    /// Creates a 16-character password containing uppercase letters, lowercase
    /// letters, numbers, and symbols. Uses cryptographically secure randomness
    /// suitable for all security applications.
    ///
    /// ## Example
    /// ```swift
    /// let password = PasswordGenerator.generate()
    /// // Result: "K7#mN9$pQ2@vX8!z"
    /// ```
    ///
    /// - Returns: A 16-character password with ~95 bits of entropy
    public static func generate() -> String {
        return generate(
            length: 16,
            includeUppercase: true,
            includeLowercase: true,
            includeNumbers: true,
            includeSymbols: true
        )
    }
    
    /// Generate multiple passwords with default settings.
    ///
    /// Efficiently generates multiple passwords using the same configuration.
    /// Each password is independently generated with fresh randomness.
    ///
    /// ## Example
    /// ```swift
    /// let passwords = PasswordGenerator.generateMultiple(count: 5)
    /// // Result: ["K7#mN9$pQ2@vX8!z", "F3&rL5^wM1@nP4!y", ...]
    /// ```
    ///
    /// - Parameter count: Number of passwords to generate (1-1000, defaults to 10)
    /// - Returns: Array of generated passwords
    public static func generateMultiple(count: Int = 10) -> [String] {
        return generateMultiple(
            count: count,
            length: 16,
            includeUppercase: true,
            includeLowercase: true,
            includeNumbers: true,
            includeSymbols: true
        )
    }
    
    /// Generate multiple passwords with custom character set options.
    ///
    /// Creates multiple passwords using the specified character types. Count is
    /// automatically clamped between 1 and 1000 for performance and memory usage.
    ///
    /// ## Example
    /// ```swift
    /// let passwords = PasswordGenerator.generateMultiple(
    ///     count: 3,
    ///     length: 12,
    ///     includeSymbols: false
    /// )
    /// // Result: ["K7mN9pQ2vX8z", "F3rL5wM1nP4y", "B8kG2jS6eA9c"]
    /// ```
    ///
    /// - Parameters:
    ///   - count: Number of passwords to generate (1-1000, defaults to 10)
    ///   - length: Desired password length (4-128, defaults to 16)
    ///   - includeUppercase: Include A-Z characters (defaults to true)
    ///   - includeLowercase: Include a-z characters (defaults to true)
    ///   - includeNumbers: Include 0-9 characters (defaults to true)
    ///   - includeSymbols: Include special symbols (defaults to true)
    /// - Returns: Array of generated passwords
    public static func generateMultiple(
        count: Int = 10,
        length: Int = 16,
        includeUppercase: Bool = true,
        includeLowercase: Bool = true,
        includeNumbers: Bool = true,
        includeSymbols: Bool = true
    ) -> [String] {
        
        let clampedCount = max(1, min(1000, count))
        
        return (0..<clampedCount).map { _ in
            generate(
                length: length,
                includeUppercase: includeUppercase,
                includeLowercase: includeLowercase,
                includeNumbers: includeNumbers,
                includeSymbols: includeSymbols
            )
        }
    }
    
    /// Generate multiple passwords using a custom character set.
    ///
    /// Creates multiple passwords using a completely custom character set.
    /// Useful for generating many passwords with the same character restrictions.
    ///
    /// ## Example
    /// ```swift
    /// let hexPasswords = PasswordGenerator.generateMultiple(
    ///     count: 5,
    ///     length: 16,
    ///     characterSet: "0123456789ABCDEF"
    /// )
    /// // Result: ["A3F90BCE172D64A0", "7B2E8F1C9A4D5E6F", ...]
    /// ```
    ///
    /// - Parameters:
    ///   - count: Number of passwords to generate (1-1000, defaults to 10)
    ///   - length: Desired password length (4-128, defaults to 16)
    ///   - characterSet: String containing all allowed characters
    /// - Returns: Array of generated passwords
    public static func generateMultiple(
        count: Int = 10,
        length: Int = 16,
        characterSet: String
    ) -> [String] {
        
        let clampedCount = max(1, min(1000, count))
        
        return (0..<clampedCount).map { _ in
            generate(length: length, characterSet: characterSet)
        }
    }
    
    /// Generate multiple pronounceable passwords.
    ///
    /// Creates multiple pronounceable passwords using alternating consonants
    /// and vowels. Each password is independently generated.
    ///
    /// ## Example
    /// ```swift
    /// let passwords = PasswordGenerator.generateMultiplePronounceables(
    ///     count: 3,
    ///     length: 10
    /// )
    /// // Result: ["mebakitu47", "kolivesu23", "ribafeno85"]
    /// ```
    ///
    /// - Parameters:
    ///   - count: Number of passwords to generate (1-1000, defaults to 10)
    ///   - length: Desired password length (6-64, defaults to 12)
    ///   - includeNumbers: Append random numbers (defaults to true)
    /// - Returns: Array of pronounceable passwords
    public static func generateMultiplePronounceables(
        count: Int = 10,
        length: Int = 12,
        includeNumbers: Bool = true
    ) -> [String] {
        
        let clampedCount = max(1, min(1000, count))
        
        return (0..<clampedCount).map { _ in
            generatePronounceablePassword(length: length, includeNumbers: includeNumbers)
        }
    }
    
    /// Generate a password with custom character set options.
    ///
    /// Creates a password using the specified character types. Length is
    /// automatically clamped between 4 and 128 characters for security
    /// and usability. At least one character type must be enabled.
    ///
    /// ## Example
    /// ```swift
    /// let password = PasswordGenerator.generate(
    ///     length: 12,
    ///     includeUppercase: true,
    ///     includeLowercase: true,
    ///     includeNumbers: true,
    ///     includeSymbols: false
    /// )
    /// // Result: "K7mN9pQ2vX8z"
    /// ```
    ///
    /// - Parameters:
    ///   - length: Desired password length (4-128, defaults to 16)
    ///   - includeUppercase: Include A-Z characters (defaults to true)
    ///   - includeLowercase: Include a-z characters (defaults to true)
    ///   - includeNumbers: Include 0-9 characters (defaults to true)
    ///   - includeSymbols: Include special symbols (defaults to true)
    /// - Returns: Generated password string
    public static func generate(
        length: Int = 16,
        includeUppercase: Bool = true,
        includeLowercase: Bool = true,
        includeNumbers: Bool = true,
        includeSymbols: Bool = true
    ) -> String {
        
        // Clamp length to safe bounds
        let clampedLength = max(4, min(128, length))
        
        // Build character pool
        let characterPool = buildCharacterPool(
            includeUppercase: includeUppercase,
            includeLowercase: includeLowercase,
            includeNumbers: includeNumbers,
            includeSymbols: includeSymbols
        )
        
        guard !characterPool.isEmpty else {
            // Fallback to alphanumeric if no character types selected
            return generateFromPool(
                length: clampedLength,
                characterPool: CharacterSets.alphanumeric
            )
        }
        
        return generateFromPool(length: clampedLength, characterPool: characterPool)
    }
    
    /// Generate a password using a custom character set.
    ///
    /// Advanced method that allows complete control over which characters
    /// can appear in the generated password. Useful for systems with
    /// specific character requirements or restrictions.
    ///
    /// ## Example
    /// ```swift
    /// let customChars = "ABCDEF0123456789" // Hex-like passwords
    /// let password = PasswordGenerator.generate(
    ///     length: 20,
    ///     characterSet: customChars
    /// )
    /// // Result: "A3F90BCE172D64A0B531"
    /// ```
    ///
    /// - Parameters:
    ///   - length: Desired password length (4-128, defaults to 16)
    ///   - characterSet: String containing all allowed characters
    /// - Returns: Generated password string
    public static func generate(
        length: Int = 16,
        characterSet: String
    ) -> String {
        let clampedLength = max(4, min(128, length))
        
        guard !characterSet.isEmpty else {
            // Fallback to default generation if empty character set
            return generate(length: clampedLength)
        }
        
        return generateFromPool(length: clampedLength, characterPool: characterSet)
    }
    
    /// Generate a pronounceable password using alternating consonants and vowels.
    ///
    /// Creates passwords that are easier to remember and pronounce while
    /// maintaining good security. Uses cryptographically secure randomness
    /// to select from consonant and vowel pools.
    ///
    /// ## Example
    /// ```swift
    /// let password = PasswordGenerator.generatePronounceablePassword(length: 12)
    /// // Result: "mebakitulo47"
    /// ```
    ///
    /// - Parameters:
    ///   - length: Desired password length (6-64, defaults to 12)
    ///   - includeNumbers: Append random numbers (defaults to true)
    /// - Returns: Pronounceable password string
    public static func generatePronounceablePassword(
        length: Int = 12,
        includeNumbers: Bool = true
    ) -> String {
        let clampedLength = max(6, min(64, length))
        let baseLength = includeNumbers ? clampedLength - 2 : clampedLength
        
        var password = ""
        
        for i in 0..<baseLength {
            if i % 2 == 0 {
                // Add consonant
                password += String(selectRandomCharacter(from: CharacterSets.consonants))
            } else {
                // Add vowel
                password += String(selectRandomCharacter(from: CharacterSets.vowels))
            }
        }
        
        if includeNumbers {
            // Add 2 random digits at the end
            let digits = generateFromPool(length: 2, characterPool: CharacterSets.numbers)
            password += digits
        }
        
        return password
    }
    
    /// Calculate the entropy (in bits) for a password configuration.
    ///
    /// Entropy measures the theoretical strength of a password based on
    /// the character set size and password length. Higher entropy values
    /// indicate stronger passwords that are harder to crack.
    ///
    /// ## Example
    /// ```swift
    /// let entropy = PasswordGenerator.entropy(length: 16, characterSetSize: 95)
    /// // Result: ~105.3 bits
    /// ```
    ///
    /// ## Entropy Guidelines
    /// - 40-50 bits: Minimum for low-risk applications
    /// - 50-60 bits: Good for personal accounts
    /// - 60-80 bits: Strong for business applications
    /// - 80+ bits: Excellent for high-security requirements
    ///
    /// - Parameters:
    ///   - length: Password length
    ///   - characterSetSize: Size of the character set used
    /// - Returns: Entropy value in bits
    public static func entropy(length: Int, characterSetSize: Int) -> Double {
        guard length > 0 && characterSetSize > 0 else { return 0.0 }
        return Double(length) * log2(Double(characterSetSize))
    }
    
    /// Get information about available character sets.
    ///
    /// Returns metadata about the built-in character sets including
    /// their sizes and entropy contribution per character.
    ///
    /// ## Example
    /// ```swift
    /// let info = PasswordGenerator.characterSetInfo()
    /// print("Full character set size: \(info.fullSetSize)")
    /// // Result: "Full character set size: 95"
    /// ```
    ///
    /// - Returns: CharacterSetInfo containing metadata
    public static func characterSetInfo() -> CharacterSetInfo {
        return CharacterSetInfo(
            uppercaseSize: CharacterSets.uppercase.count,
            lowercaseSize: CharacterSets.lowercase.count,
            numbersSize: CharacterSets.numbers.count,
            symbolsSize: CharacterSets.symbols.count,
            fullSetSize: CharacterSets.all.count,
            entropyPerCharacterFull: log2(Double(CharacterSets.all.count))
        )
    }
    
    /// Analyze the strength of an existing password.
    ///
    /// Evaluates a password's character diversity, length, and estimated
    /// entropy to provide a strength assessment and improvement suggestions.
    ///
    /// ## Example
    /// ```swift
    /// let analysis = PasswordGenerator.analyzePassword("mypassword123")
    /// print("Strength: \(analysis.strengthLevel)")
    /// print("Entropy: \(analysis.entropy) bits")
    /// ```
    ///
    /// - Parameter password: Password to analyze
    /// - Returns: PasswordAnalysis containing strength metrics
    public static func analyzePassword(_ password: String) -> PasswordAnalysis {
        let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasNumbers = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSymbols = password.rangeOfCharacter(from: CharacterSet(charactersIn: CharacterSets.symbols)) != nil
        
        var characterSetSize = 0
        if hasUppercase { characterSetSize += 26 }
        if hasLowercase { characterSetSize += 26 }
        if hasNumbers { characterSetSize += 10 }
        if hasSymbols { characterSetSize += CharacterSets.symbols.count }
        
        let calculatedEntropy = entropy(length: password.count, characterSetSize: characterSetSize)
        
        let strengthLevel: PasswordStrength
        switch calculatedEntropy {
        case 0..<30: strengthLevel = .veryWeak
        case 30..<40: strengthLevel = .weak
        case 40..<60: strengthLevel = .fair
        case 60..<80: strengthLevel = .strong
        default: strengthLevel = .veryStrong
        }
        
        var suggestions: [String] = []
        if password.count < 8 { suggestions.append("Use at least 8 characters") }
        if password.count < 12 { suggestions.append("Consider 12+ characters for better security") }
        if !hasUppercase { suggestions.append("Add uppercase letters") }
        if !hasLowercase { suggestions.append("Add lowercase letters") }
        if !hasNumbers { suggestions.append("Add numbers") }
        if !hasSymbols { suggestions.append("Add special symbols") }
        if calculatedEntropy < 50 { suggestions.append("Increase overall complexity") }
        
        return PasswordAnalysis(
            length: password.count,
            hasUppercase: hasUppercase,
            hasLowercase: hasLowercase,
            hasNumbers: hasNumbers,
            hasSymbols: hasSymbols,
            entropy: calculatedEntropy,
            strengthLevel: strengthLevel,
            suggestions: suggestions
        )
    }
}

// MARK: - Supporting Types

/// Password strength levels based on entropy analysis
public enum PasswordStrength: String, CaseIterable {
    case veryWeak = "Very Weak"
    case weak = "Weak"
    case fair = "Fair"
    case strong = "Strong"
    case veryStrong = "Very Strong"
    
    /// Minimum entropy threshold for this strength level
    public var entropyThreshold: Double {
        switch self {
        case .veryWeak: return 0
        case .weak: return 30
        case .fair: return 40
        case .strong: return 60
        case .veryStrong: return 80
        }
    }
}

/// Analysis results for password strength evaluation
public struct PasswordAnalysis {
    /// Password length in characters
    public let length: Int
    
    /// Whether password contains uppercase letters
    public let hasUppercase: Bool
    
    /// Whether password contains lowercase letters
    public let hasLowercase: Bool
    
    /// Whether password contains numeric digits
    public let hasNumbers: Bool
    
    /// Whether password contains special symbols
    public let hasSymbols: Bool
    
    /// Calculated entropy in bits
    public let entropy: Double
    
    /// Overall strength assessment
    public let strengthLevel: PasswordStrength
    
    /// Specific suggestions for improvement
    public let suggestions: [String]
    
    /// Character diversity score (0.0 to 1.0)
    public var diversityScore: Double {
        let typesUsed = [hasUppercase, hasLowercase, hasNumbers, hasSymbols].filter { $0 }.count
        return Double(typesUsed) / 4.0
    }
}

/// Information about character set sizes and entropy
public struct CharacterSetInfo {
    /// Number of uppercase letters (A-Z)
    public let uppercaseSize: Int
    
    /// Number of lowercase letters (a-z)
    public let lowercaseSize: Int
    
    /// Number of numeric digits (0-9)
    public let numbersSize: Int
    
    /// Number of special symbols
    public let symbolsSize: Int
    
    /// Total size when all character types are used
    public let fullSetSize: Int
    
    /// Entropy contribution per character when using full set
    public let entropyPerCharacterFull: Double
}

// MARK: - Internal Implementation

private extension PasswordGenerator {
    
    /// Build character pool based on selected character types
    static func buildCharacterPool(
        includeUppercase: Bool,
        includeLowercase: Bool,
        includeNumbers: Bool,
        includeSymbols: Bool
    ) -> String {
        var pool = ""
        
        if includeUppercase { pool += CharacterSets.uppercase }
        if includeLowercase { pool += CharacterSets.lowercase }
        if includeNumbers { pool += CharacterSets.numbers }
        if includeSymbols { pool += CharacterSets.symbols }
        
        return pool
    }
    
    /// Generate password from a character pool using cryptographically secure randomness
    static func generateFromPool(length: Int, characterPool: String) -> String {
        var password = ""
        
        for _ in 0..<length {
            let randomChar = selectRandomCharacter(from: characterPool)
            password.append(randomChar)
        }
        
        return password
    }
    
    /// Select a random character from a string using SecRandomCopyBytes
    static func selectRandomCharacter(from characterPool: String) -> Character {
        let characters = Array(characterPool)
        
        // Generate cryptographically secure random bytes
        var randomBytes = Data(count: 4)
        let status = randomBytes.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, 4, bytes.bindMemory(to: UInt8.self).baseAddress!)
        }
        
        guard status == errSecSuccess else {
            fatalError("Failed to generate cryptographically secure random bytes")
        }
        
        // Convert bytes to index
        let randomValue = randomBytes.withUnsafeBytes { bytes in
            bytes.bindMemory(to: UInt32.self).first ?? 0
        }
        
        let index = Int(randomValue % UInt32(characters.count))
        return characters[index]
    }
}

// MARK: - Character Sets

private struct CharacterSets {
    static let uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let lowercase = "abcdefghijklmnopqrstuvwxyz"
    static let numbers = "0123456789"
    
    // Safe symbols that work across most systems
    static let symbols = "!@#$%^&*()_+-=[]{}|;:,.<>?"
    
    // Combined sets for convenience
    static let alphanumeric = uppercase + lowercase + numbers
    static let all = uppercase + lowercase + numbers + symbols
    
    // For pronounceable passwords
    static let consonants = "bcdfghjklmnpqrstvwxyz"
    static let vowels = "aeiou"
}

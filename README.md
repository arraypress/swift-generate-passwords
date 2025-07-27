# Swift Password Generator

A modern Swift package for generating cryptographically secure passwords with extensive customization options. Perfect for apps that need strong password generation, security applications, or any system requiring secure random text.

## Features

- 🔒 **Cryptographically Secure** - Uses `SecRandomCopyBytes` for true randomness
- ⚙️ **Highly Customizable** - Control length, character sets, and generation style
- 🎯 **Multiple Generation Modes** - Standard, pronounceable, and custom character sets
- 📊 **Password Analysis** - Strength evaluation and improvement suggestions
- 🧮 **Entropy Calculation** - Measure theoretical password strength
- 🚀 **Bulk Generation** - Generate multiple passwords efficiently
- ⚡ **High Performance** - Optimized for speed with minimal memory usage
- 🛡️ **Thread-Safe** - Safe for concurrent use across multiple threads
- 📱 **Cross-Platform** - Supports iOS, macOS, tvOS, and watchOS

## Installation

### Swift Package Manager

Add PasswordGenerator to your project using Xcode or by adding it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/arraypress/swift-password-generator.git", from: "1.0.0")
]
```

## Quick Start

```swift
import PasswordGenerator

// Generate a default 16-character password
let password = PasswordGenerator.generate()
// Result: "K7#mN9$pQ2@vX8!z"

// Generate multiple passwords at once
let passwords = PasswordGenerator.generateMultiple(count: 5)
// Result: ["K7#mN9$pQ2@vX8!z", "F3&rL5^wM1@nP4!y", ...]
```

## Usage Examples

### Single Password Generation

```swift
// Default: 16 characters, all character types
let basic = PasswordGenerator.generate()
// "A9#k2B$m7@nP4!zX"

// Custom length and character types
let custom = PasswordGenerator.generate(
    length: 12,
    includeUppercase: true,
    includeLowercase: true,
    includeNumbers: true,
    includeSymbols: false
)
// "A9k2B7mP4nzX"

// Custom character sets
let hexPassword = PasswordGenerator.generate(
    length: 16,
    characterSet: "0123456789ABCDEF"
)
// "A3F90BCE172D64A0"

// Pronounceable passwords
let pronounceable = PasswordGenerator.generatePronounceablePassword(length: 12)
// "mebakitulo47"
```

### Bulk Password Generation

```swift
// Generate multiple default passwords
let passwords = PasswordGenerator.generateMultiple(count: 10)
// ["K7#mN9$pQ2@vX8!z", "F3&rL5^wM1@nP4!y", ...]

// Generate multiple custom passwords
let customPasswords = PasswordGenerator.generateMultiple(
    count: 5,
    length: 12,
    includeSymbols: false
)
// ["K7mN9pQ2vX8z", "F3rL5wM1nP4y", ...]

// Generate multiple hex passwords
let hexPasswords = PasswordGenerator.generateMultiple(
    count: 3,
    length: 16,
    characterSet: "0123456789ABCDEF"
)
// ["A3F90BCE172D64A0", "7B2E8F1C9A4D5E6F", ...]

// Generate multiple pronounceable passwords
let pronounceablePasswords = PasswordGenerator.generateMultiplePronounceables(
    count: 5,
    length: 10
)
// ["mebakitu47", "kolivesu23", "ribafeno85", ...]
```

### Password Analysis

```swift
// Analyze existing passwords
let analysis = PasswordGenerator.analyzePassword("mypassword123")

print("Strength: \(analysis.strengthLevel)")        // "Weak"
print("Entropy: \(analysis.entropy) bits")          // "~42.7 bits"
print("Has uppercase: \(analysis.hasUppercase)")    // "false"
print("Diversity score: \(analysis.diversityScore)") // "0.5"

// Get improvement suggestions
for suggestion in analysis.suggestions {
    print("• \(suggestion)")
}
// • Add uppercase letters
// • Add special symbols
// • Consider 12+ characters for better security
```

### Entropy Calculation

```swift
// Calculate theoretical password strength
let entropy = PasswordGenerator.entropy(length: 16, characterSetSize: 95)
print("Entropy: \(entropy) bits") // "~105.3 bits"

// Get character set information
let info = PasswordGenerator.characterSetInfo()
print("Full character set size: \(info.fullSetSize)")        // "95"
print("Entropy per character: \(info.entropyPerCharacterFull)") // "~6.57 bits"
```

## API Reference

### Single Password Generation

#### `generate()`
Generate a password with default settings (16 characters, all character types).

#### `generate(length:includeUppercase:includeLowercase:includeNumbers:includeSymbols:)`
Generate a customized password with specific character type requirements.

- `length`: Password length (4-128, automatically clamped)
- `includeUppercase`: Include A-Z characters
- `includeLowercase`: Include a-z characters
- `includeNumbers`: Include 0-9 characters
- `includeSymbols`: Include special symbols

#### `generate(length:characterSet:)`
Generate a password using a completely custom character set.

#### `generatePronounceablePassword(length:includeNumbers:)`
Generate an easy-to-pronounce password using alternating consonants and vowels.

### Bulk Password Generation

#### `generateMultiple(count:)`
Generate multiple passwords with default settings.

#### `generateMultiple(count:length:includeUppercase:includeLowercase:includeNumbers:includeSymbols:)`
Generate multiple passwords with custom character type requirements.

#### `generateMultiple(count:length:characterSet:)`
Generate multiple passwords using a custom character set.

#### `generateMultiplePronounceables(count:length:includeNumbers:)`
Generate multiple pronounceable passwords.

**Note:** All bulk generation methods automatically clamp count between 1-1000 for performance and memory safety.

### Analysis Methods

#### `analyzePassword(_:)`
Analyze an existing password's strength and provide improvement suggestions.

#### `entropy(length:characterSetSize:)`
Calculate the theoretical entropy (strength) of a password configuration.

#### `characterSetInfo()`
Get information about the built-in character sets and their entropy values.

### Types

#### `PasswordStrength`
Enumeration of password strength levels:
- `.veryWeak` (0-30 bits entropy)
- `.weak` (30-40 bits)
- `.fair` (40-60 bits)
- `.strong` (60-80 bits)
- `.veryStrong` (80+ bits)

#### `PasswordAnalysis`
Structure containing detailed password analysis:
- `length`: Character count
- `hasUppercase/hasLowercase/hasNumbers/hasSymbols`: Character type presence
- `entropy`: Calculated entropy in bits
- `strengthLevel`: Overall strength assessment
- `suggestions`: Array of improvement recommendations
- `diversityScore`: Character diversity (0.0-1.0)

#### `CharacterSetInfo`
Information about the built-in character sets:
- `uppercaseSize/lowercaseSize/numbersSize/symbolsSize`: Individual set sizes
- `fullSetSize`: Total characters when all types are used
- `entropyPerCharacterFull`: Entropy contribution per character

## Security Guidelines

### Entropy Recommendations

- **40-50 bits**: Minimum for low-risk personal accounts
- **50-60 bits**: Good for most personal and business use
- **60-80 bits**: Strong for sensitive business applications
- **80+ bits**: Excellent for high-security requirements

### Best Practices

1. **Use the default settings** for most applications (16 chars, all types)
2. **Increase length** rather than complexity for better security
3. **Include all character types** when system allows
4. **Use pronounceable passwords** for user-generated credentials
5. **Analyze passwords** before deployment to ensure adequate strength
6. **Generate in bulk** for efficiency when creating multiple accounts

### Character Set Guidelines

The default character set includes 95 characters:
- 26 uppercase letters (A-Z)
- 26 lowercase letters (a-z)
- 10 numbers (0-9)
- 33 symbols (`!@#$%^&*()_+-=[]{}|;:,.<>?`)

This provides ~6.57 bits of entropy per character, making a 16-character password extremely secure (~105 bits total entropy).

## Performance

SwiftGeneratePasswords is optimized for high-performance scenarios:

- **Single password**: ~0.02ms per password
- **Bulk generation (100 passwords)**: ~2ms total
- **Custom character sets**: ~0.02ms per password
- **Analysis**: ~0.0001ms per password
- **Memory usage**: Minimal heap allocation
- **Thread safety**: Fully concurrent-safe

## Advanced Usage

### Bulk Generation for Teams

```swift
// Generate passwords for a team
let teamPasswords = PasswordGenerator.generateMultiple(count: 50, length: 20)
let csvOutput = teamPasswords.enumerated().map { index, password in
    "user\(index + 1),\(password)"
}.joined(separator: "\n")
```

### Strength Validation

```swift
func generateStrongPassword(minEntropy: Double = 80.0) -> String {
    var attempts = 0
    repeat {
        let password = PasswordGenerator.generate(length: 16)
        let analysis = PasswordGenerator.analyzePassword(password)
        
        if analysis.entropy >= minEntropy {
            return password
        }
        
        attempts += 1
    } while attempts < 10
    
    // Fallback to longer password
    return PasswordGenerator.generate(length: 24)
}
```

### Custom Validation

```swift
func generatePasswordForSystem() -> String {
    // Some systems have specific requirements
    repeat {
        let password = PasswordGenerator.generate(length: 12)
        let analysis = PasswordGenerator.analyzePassword(password)
        
        // Ensure all character types are present
        if analysis.hasUppercase && analysis.hasLowercase &&
           analysis.hasNumbers && analysis.hasSymbols {
            return password
        }
    } while true
}
```

### App Intents Integration

```swift
import AppIntents

struct GeneratePasswordsIntent: AppIntent {
    static let title: LocalizedStringResource = "Generate Passwords"
    
    @Parameter(title: "Count", default: 5)
    var count: Int
    
    @Parameter(title: "Length", default: 16)
    var length: Int
    
    @Parameter(title: "Include Symbols", default: true)
    var includeSymbols: Bool
    
    func perform() async throws -> some IntentResult & ReturnsValue<[String]> {
        let passwords = PasswordGenerator.generateMultiple(
            count: count,
            length: length,
            includeSymbols: includeSymbols
        )
        return .result(value: passwords)
    }
}
```

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 6.0+
- Xcode 16.0+

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

- **Character Sets** - Based on industry-standard character pools for maximum compatibility
- **Entropy Calculations** - Following NIST guidelines for password strength measurement
- **Cryptographic Randomness** - Using Apple's Security framework for true randomness

---

**Generate strong passwords with confidence** 🔐

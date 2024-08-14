import Foundation

public protocol JSONModel: Codable {
    static var decoder: JSONDecoder { get }
    static var encoder: JSONEncoder { get }
}

public extension JSONModel {
    static var decoder: JSONDecoder {
        JSONDecoder()
    }
    
    static var encoder: JSONEncoder {
        JSONEncoder()
    }
}

public enum JSONModelError: Error {
    case StringDecodeToDataFailed
    case DataEncodeToStringFailed
}

// MARK: - Data Decode & Encode
public extension JSONModel {
    static func decode(jsonData: Data) throws -> Self {
        try decoder.decode(Self.self, from: jsonData)
    }
    
    func jsonData() throws -> Data {
        try Self.encoder.encode(self)
    }
    
    func jsonPrettySortedData() throws -> Data {
        let jsonObject = try JSONSerialization.jsonObject(with: self.jsonData(), options: [])
        return try JSONSerialization.data(withJSONObject: jsonObject, options: [.withoutEscapingSlashes, .sortedKeys, .prettyPrinted])
    }
}

// MARK: - String Decode & Encode
public extension JSONModel {
    static func decode(jsonString: String) throws -> Self {
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw JSONModelError.StringDecodeToDataFailed
        }
        return try decode(jsonData: jsonData)
    }
    
    func jsonString() throws -> String {
        guard let jsonString = try String(data: jsonData(), encoding: .utf8) else {
            throw JSONModelError.DataEncodeToStringFailed
        }
        return jsonString
    }
    
    func jsonPrettySortedString() throws -> String {
        guard let jsonPrettySortedString = try String(data: jsonPrettySortedData(), encoding: .utf8) else {
            throw JSONModelError.DataEncodeToStringFailed
        }
        return jsonPrettySortedString
    }
}

// MARK: - URL Decode & Encode
public extension JSONModel {
    static func decode(url: URL) throws -> Self {
        let jsonData = try Data(contentsOf: url)
        return try decode(jsonData: jsonData)
    }
    
    func encode(url: URL) throws {
        let jsonData = try jsonData()
        try jsonData.write(to: url)
    }
    
    func encodePrettySorted(url: URL) throws {
        let jsonData = try jsonPrettySortedData()
        try jsonData.write(to: url)
    }
}

import FluentPostgreSQL
import Vapor

enum ContainerType: Int, Codable {
    case spacer
    case image
    case grid
    case list
    case vStack
    case hStack
    case card
    case zStack
}

enum EmbeddedType: Int, Codable {
    case header
    case button
    case text
    case spacer
    case image
    case list
    case vStack
    case hStack
    case zStack
    case shape
}

enum SegmentType: Int, Codable {
    case spacer
    case header
    case image
    case button
    case card
    case empty
}

/// A single entry of a Segment list.
final class Segment: Codable {
    /// The unique identifier for this `Segment`.
    var id: Int?
    var cardID: Int
    var type: String
    var level: Int
    
    /// Attributes
    var layout: String?
    var alignment: String?
    var fillColor: String?
    var backgroundColor: String?
    var cornerRadius: Int?
    var verticalPadding: Int?
    var horizonatlPadding: Int?
    var height: Int?
    var width: Int?
    var font: String?
    var fontSize: Int?
    var size: Int?
    var shape: String?
    
    /// A title describing what this `Segment` entails.
    //var body: [String: String]
    
    /// Creates a new `Todo`.
    init(id: Int? = nil,
         cardID: Int,
         type: String,
         level: Int,
         layout: String? = nil,
         alignment: String? = nil,
         fillColor: String? = nil,
         backgroundColor: String? = nil,
         cornerRadius: Int? = nil,
         verticalPadding: Int? = nil,
         horizonatlPadding: Int? = nil,
         height: Int? = nil,
         width: Int? = nil,
         font: String? = nil,
         fontSize: Int? = nil,
         shape: String? = nil,
         size: Int? = nil) {
        self.id = id
        self.type = type
        self.cardID = cardID
        self.level = level
        self.layout = layout
        self.alignment = alignment
        self.fillColor = fillColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.verticalPadding = verticalPadding
        self.horizonatlPadding = horizonatlPadding
        self.height = height
        self.font = font
        self.fontSize = fontSize
        self.size = size
        self.shape = shape
    }
}

extension Segment: PostgreSQLModel { }

/// Allows `Todo` to be used as a dynamic migration.
extension Segment: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Segment: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Segment: Parameter { }

extension Segment {
    var card: Parent<Segment, Card> {
        return parent(\.cardID)
    }
    
    var pet: Parent<Segment, Pet> {
        return parent(\.cardID)
    }
}

extension Segment {
    var attributes: Children<Segment, Attribute> {
        return children(\.segmentID)
    }
}

final class Attribute: Codable {
    var id: Int?
    var alignment: String?
    var frameSize: Double?
    var text: String?
    var hasShadow: Bool?
    var segmentID: Int
    
    init(id: Int?, alignment: String?, segmentID: Int, frameSize: Double?, text: String?, hasShadow: Bool?) {
        self.id = id
        self.alignment = alignment
        self.segmentID = segmentID
        self.frameSize = frameSize
        self.text = text
        self.hasShadow = hasShadow
    }
}

extension Attribute: PostgreSQLModel { }

/// Allows `Attribute` to be used as a dynamic migration.
extension Attribute: Migration { }

/// Allows `Attribute` to be encoded to and decoded from HTTP messages.
extension Attribute: Content { }

/// Allows `Attribute` to be used as a dynamic parameter in route definitions.
extension Attribute: Parameter { }

extension Attribute {
    var segment: Parent<Attribute, Segment> {
        return parent(\.segmentID)
    }
}

//struct SegmentAndAttributes: Content {
//    let id: Int?
//    /// Details about what this `Pet` entails.
//    let cardID: Int
//    let type: SegmentType?
//    let containerType: ContainerType?
//    let embeddedTypes: [EmbeddedType]?
//    let attributes: [Attribute]
//    init(segment: Segment, attributes: [Attribute]) {
//        self.id = segment.id
//        self.cardID = segment.cardID
//        self.type = segment.type
//        self.containerType = segment.containerType
//        self.embeddedTypes = segment.embeddedTypes
//        self.attributes = attributes
//    }
//}

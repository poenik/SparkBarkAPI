import FluentSQLite
import Vapor

enum SegmentType: Int, Codable {
    case spacer
    case header
    case image
    case button
    case empty
}

/// A single entry of a Todo list.
final class Segment: Codable {
    /// The unique identifier for this `Todo`.
    var id: Int?
    var cardID: Int

    /// A title describing what this `Todo` entails.
    var type: SegmentType?
    //var body: [String: String]

    /// Creates a new `Todo`.
    init(id: Int? = nil, type: SegmentType? = .empty, cardID: Int) {
        self.id = id
        self.type = type
        self.cardID = cardID
    }
}

extension Segment: SQLiteModel { }

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
}

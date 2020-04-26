import FluentMySQL
import Fluent
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentMySQLProvider())
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure a SQLite database
    var databases = DatabasesConfig()
    // 3
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    let username = Environment.get("DATABASE_USER") ?? "nico"
    let databaseName = Environment.get("DATABASE_DB") ?? "vapor"
    let password = Environment.get("DATABASE_PASSWORD") ?? "password"
    let databaseConfig = MySQLDatabaseConfig(
        hostname: hostname,
        username: username,
        password: password,
        database: databaseName)
    let database = MySQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .mysql)
    services.register(databases)
    
    // Configure migrations
    var migrations = MigrationConfig()
    //migrations.add(model: Todo.self, database: .sqlite)
    migrations.add(model: Pet.self, database: .mysql)
    migrations.add(model: Segment.self, database: .mysql)
    migrations.add(model: PetSegmentPivot.self, database: .mysql)
    migrations.add(model: Card.self, database: .mysql)
    migrations.add(model: Attribute.self, database: .mysql)
    services.register(migrations)
}

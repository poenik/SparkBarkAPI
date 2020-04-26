import FluentPostgreSQL
import Fluent
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())
    
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
    let username = Environment.get("DATABASE_USER") ?? "vapor"
    let databaseName = Environment.get("DATABASE_DB") ?? "vapor"
    let password = Environment.get("DATABASE_PASSWORD") ?? "password"
    // 3
    let databaseConfig = PostgreSQLDatabaseConfig(
      hostname: hostname,
      username: username,
      database: databaseName,
      password: password)
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)
    
    // Configure migrations
    var migrations = MigrationConfig()
    //migrations.add(model: Todo.self, database: .sqlite)
    migrations.add(model: Pet.self, database: .psql)
    migrations.add(model: Segment.self, database: .psql)
    migrations.add(model: PetSegmentPivot.self, database: .psql)
    migrations.add(model: Card.self, database: .psql)
    migrations.add(model: Attribute.self, database: .psql)
    services.register(migrations)
}

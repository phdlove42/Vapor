import Vapor
import HTTP
import VaporPostgreSQL

final class BasicAcronym
{
    func addRoutes(drop: Droplet) {
        let basicAcronym = drop.grouped("acronym")
        basicAcronym.get("create", "test", handler: testCreate)
        basicAcronym.post("create", handler: create)
        basicAcronym.get("all", handler: all)
        basicAcronym.get("first", handler: first)
        basicAcronym.get("delete", "all", handler: deleteAll)
    }
    
    
    func testCreate(request: Request) throws -> ResponseRepresentable {
        var acronym = Acronym(short: "BRB", long: "Be Right Back")
        try acronym.save()
        return try JSON(node: "success")
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var acronym = try Acronym(node: request.json)
        try acronym.save()
        return acronym
    }
    
    func all(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Acronym.all().makeNode())
    }
    
    func first(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Acronym.query().first()?.makeNode())
    }
    
    func deleteAll(request: Request) throws -> ResponseRepresentable {
        let query = try Acronym.query().all()
        for acc in query {
            try acc.delete()
        }
        return try JSON(node: Acronym.all().makeNode())
    }
}

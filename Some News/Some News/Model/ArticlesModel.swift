//
//  ArticlesModel.swift
//  Some News
//
//  Created by Israel Manzo on 3/28/23.
//

import Foundation
import CoreData

struct ArticlesList: Decodable {
    let articles: [Articles]
}

struct Source: Codable {
    let id: String?
    let name: String?
}

struct Articles: Codable, Identifiable {
    /// Stable id used when `url` is missing (and for local persistence).
    var localId: String = UUID().uuidString
    var id: String { url ?? localId }
    
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    
    // Local-only metadata (not returned by NewsAPI).
    var matchedQuery: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
    }
    
    init(
        localId: String = UUID().uuidString,
        source: Source?,
        author: String?,
        title: String?,
        description: String?,
        url: String?,
        urlToImage: String?,
        publishedAt: String?,
        matchedQuery: String? = nil
    ) {
        self.localId = localId
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.matchedQuery = matchedQuery
    }
}

// MARK: - Core Data (local persistence)

@objc(ArticleEntity)
final class ArticleEntity: NSManagedObject {
    @NSManaged var localId: String
    @NSManaged var url: String?
    @NSManaged var title: String?
    @NSManaged var articleDescription: String?
    @NSManaged var author: String?
    @NSManaged var publishedAt: String?
    @NSManaged var urlToImage: String?
    @NSManaged var sourceId: String?
    @NSManaged var sourceName: String?
    @NSManaged var matchedQuery: String?
    @NSManaged var cachedAt: Date?
}

extension ArticleEntity {
    @nonobjc static func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
    }
}

extension Articles {
    init(entity: ArticleEntity) {
        let source = Source(id: entity.sourceId, name: entity.sourceName)
        self.init(
            localId: entity.localId,
            source: (entity.sourceId == nil && entity.sourceName == nil) ? nil : source,
            author: entity.author,
            title: entity.title,
            description: entity.articleDescription,
            url: entity.url,
            urlToImage: entity.urlToImage,
            publishedAt: entity.publishedAt,
            matchedQuery: entity.matchedQuery
        )
    }
}

final class PersistenceController {
    static let shared = PersistenceController()
    static let preview: PersistenceController = PersistenceController(inMemory: true)
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        let model = Self.makeManagedObjectModel()
        container = NSPersistentContainer(name: "SomeNews", managedObjectModel: model)
        
        let description = NSPersistentStoreDescription()
        if inMemory {
            description.type = NSInMemoryStoreType
            description.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let url = NSPersistentContainer.defaultDirectoryURL()
                .appendingPathComponent("SomeNews.sqlite")
            description.type = NSSQLiteStoreType
            description.url = url
        }
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error {
                // Fail fast: local persistence is a core app feature.
                fatalError("Unresolved Core Data error: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
    }
    
    private static func makeManagedObjectModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        let entity = NSEntityDescription()
        entity.name = "ArticleEntity"
        entity.managedObjectClassName = NSStringFromClass(ArticleEntity.self)
        
        func stringAttr(_ name: String, optional: Bool = true) -> NSAttributeDescription {
            let a = NSAttributeDescription()
            a.name = name
            a.attributeType = .stringAttributeType
            a.isOptional = optional
            return a
        }
        
        func dateAttr(_ name: String, optional: Bool = true) -> NSAttributeDescription {
            let a = NSAttributeDescription()
            a.name = name
            a.attributeType = .dateAttributeType
            a.isOptional = optional
            return a
        }
        
        let localId = stringAttr("localId", optional: false)
        let url = stringAttr("url")
        let title = stringAttr("title")
        let articleDescription = stringAttr("articleDescription")
        let author = stringAttr("author")
        let publishedAt = stringAttr("publishedAt")
        let urlToImage = stringAttr("urlToImage")
        let sourceId = stringAttr("sourceId")
        let sourceName = stringAttr("sourceName")
        let matchedQuery = stringAttr("matchedQuery")
        let cachedAt = dateAttr("cachedAt")
        
        entity.properties = [
            localId,
            url,
            title,
            articleDescription,
            author,
            publishedAt,
            urlToImage,
            sourceId,
            sourceName,
            matchedQuery,
            cachedAt
        ]
        
        // De-dupe within a category: (url, matchedQuery) when url exists; otherwise fallback to localId.
        // This preserves offline category browsing even if the same article appears across multiple queries.
        entity.uniquenessConstraints = [["url", "matchedQuery"], ["localId"]]
        
        model.entities = [entity]
        return model
    }
}

protocol ArticlesStore {
    func fetchArticles(matchedQuery: String?) async throws -> [Articles]
    func upsertArticles(_ articles: [Articles]) async throws
}

final class CoreDataArticlesStore: ArticlesStore {
    private let persistence: PersistenceController
    
    init(persistence: PersistenceController = .shared) {
        self.persistence = persistence
    }
    
    func fetchArticles(matchedQuery: String?) async throws -> [Articles] {
        let context = persistence.container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
        
        return try await context.perform {
            let request = ArticleEntity.fetchRequest()
            if let q = matchedQuery?.trimmingCharacters(in: .whitespacesAndNewlines), !q.isEmpty {
                request.predicate = NSPredicate(format: "matchedQuery == %@", q)
            }
            let entities = try context.fetch(request)
            return entities.map(Articles.init(entity:))
        }
    }
    
    func upsertArticles(_ articles: [Articles]) async throws {
        guard !articles.isEmpty else { return }
        
        let context = persistence.container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
        
        try await context.perform {
            for article in articles {
                let urlKey = article.url?.trimmingCharacters(in: .whitespacesAndNewlines)
                let queryKey = article.matchedQuery?.trimmingCharacters(in: .whitespacesAndNewlines)
                let localKey = article.localId
                
                let request = ArticleEntity.fetchRequest()
                if let urlKey, !urlKey.isEmpty {
                    if let queryKey, !queryKey.isEmpty {
                        request.predicate = NSPredicate(format: "url == %@ AND matchedQuery == %@", urlKey, queryKey)
                    } else {
                        request.predicate = NSPredicate(format: "url == %@ AND matchedQuery == nil", urlKey)
                    }
                } else {
                    request.predicate = NSPredicate(format: "localId == %@", localKey)
                }
                request.fetchLimit = 1
                
                let existing = try context.fetch(request).first
                let entity = existing ?? ArticleEntity(context: context)
                
                entity.localId = localKey
                entity.url = urlKey
                entity.title = article.title
                entity.articleDescription = article.description
                entity.author = article.author
                entity.publishedAt = article.publishedAt
                entity.urlToImage = article.urlToImage
                entity.sourceId = article.source?.id
                entity.sourceName = article.source?.name
                entity.matchedQuery = article.matchedQuery
                entity.cachedAt = Date()
            }
            
            if context.hasChanges {
                try context.save()
            }
        }
    }
}

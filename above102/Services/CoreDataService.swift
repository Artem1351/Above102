import CoreData
import Foundation

class CoreDataService {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getAppState() -> AppStateEntity? {
        let request: NSFetchRequest<AppStateEntity> = AppStateEntity.fetchRequest()
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching app state: \(error)")
            return nil
        }
    }
    
    func saveAppState(_ appState: AppState) {
        let entity = getAppState() ?? AppStateEntity(context: context)
        entity.hasCompletedOnboarding = appState.hasCompletedOnboarding
        entity.hasSeenPaywall = appState.hasSeenPaywall
        entity.isPremium = appState.isPremium
        entity.userName = appState.userName.isEmpty ? "User" : appState.userName
        entity.firstName = appState.firstName
        entity.lastName = appState.lastName
        entity.profilePhotoData = appState.profilePhotoData
        saveContext()
    }
    
    func updateUserProfile(firstName: String?, lastName: String?, photoData: Data?) {
        let entity = getAppState() ?? AppStateEntity(context: context)
        entity.firstName = firstName
        entity.lastName = lastName
        entity.profilePhotoData = photoData
        
        if let firstName = firstName, !firstName.isEmpty {
            entity.userName = firstName
        } else {
            entity.userName = "User"
        }
        saveContext()
    }
    
    func updateOnboardingStatus(_ completed: Bool) {
        let entity = getAppState() ?? AppStateEntity(context: context)
        entity.hasCompletedOnboarding = completed
        saveContext()
    }
    
    func updatePremiumStatus(_ isPremium: Bool) {
        let entity = getAppState() ?? AppStateEntity(context: context)
        entity.isPremium = isPremium
        saveContext()
    }
    
    func saveDestinations(_ destinations: [Destination]) {
        for destination in destinations {
            let request: NSFetchRequest<DestinationEntity> = DestinationEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", destination.id)
            
            let entity = (try? context.fetch(request).first) ?? DestinationEntity(context: context)
            entity.id = destination.id
            entity.title = destination.title
            entity.location = destination.location
            entity.imageURL = destination.imageURL
            entity.rating = destination.rating
            entity.price = destination.price
            entity.duration = destination.duration
            entity.temperature = destination.temperature
            entity.overview = destination.overview
            entity.details = destination.details
            entity.isFavorite = destination.isFavorite
            entity.viewCount = Int32(destination.viewCount)
            entity.createdAt = Date()
        }
        saveContext()
    }
    
    func fetchDestinations() -> [Destination] {
        let request: NSFetchRequest<DestinationEntity> = DestinationEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                Destination(
                    id: entity.id ?? "",
                    title: entity.title ?? "",
                    location: entity.location ?? "",
                    imageURL: entity.imageURL ?? "",
                    rating: entity.rating,
                    price: entity.price,
                    duration: entity.duration ?? "",
                    temperature: entity.temperature ?? "",
                    overview: entity.overview ?? "",
                    details: entity.details ?? "",
                    isFavorite: entity.isFavorite,
                    viewCount: Int(entity.viewCount)
                )
            }
        } catch {
            print("Error fetching destinations: \(error)")
            return []
        }
    }
    
    func toggleFavorite(for destinationId: String) {
        let request: NSFetchRequest<DestinationEntity> = DestinationEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", destinationId)
        
        if let entity = try? context.fetch(request).first {
            entity.isFavorite.toggle()
            saveContext()
        }
    }
    
    func incrementViewCount(for destinationId: String) {
        let request: NSFetchRequest<DestinationEntity> = DestinationEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", destinationId)
        
        if let entity = try? context.fetch(request).first {
            entity.viewCount += 1
            saveContext()
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

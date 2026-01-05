import Foundation
import SwiftUI
import Combine

@MainActor
class DetailViewModel: ObservableObject {
    @Published var destination: Destination
    @Published var selectedTab: DetailTab = .overview
    
    let coreDataService: CoreDataService
    
    init(destination: Destination, coreDataService: CoreDataService) {
        self.destination = destination
        self.coreDataService = coreDataService
        incrementViewCount()
    }
    
    func toggleFavorite() {
        coreDataService.toggleFavorite(for: destination.id)
        destination.isFavorite.toggle()
    }
    
    private func incrementViewCount() {
        coreDataService.incrementViewCount(for: destination.id)
        destination.viewCount += 1
    }
}

enum DetailTab {
    case overview
    case details
}

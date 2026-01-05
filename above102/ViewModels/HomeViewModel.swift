import Foundation
import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var destinations: [Destination] = []
    @Published var filteredDestinations: [Destination] = []
    @Published var selectedFilter: FilterType = .mostViewed
    @Published var searchText: String = ""
    @Published var isPremium: Bool = false
    @Published var userName: String = "User"
    @Published var profileImage: UIImage?
    @Published var showFavoritesOnly: Bool = false
    
    let coreDataService: CoreDataService
    private let destinationDataService = DestinationDataService.shared
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        loadData()
    }
    
    func loadData() {
        if let appState = coreDataService.getAppState() {
            isPremium = appState.isPremium
            userName = appState.userName ?? "User"
            
            let state = AppState(
                hasCompletedOnboarding: appState.hasCompletedOnboarding,
                hasSeenPaywall: appState.hasSeenPaywall,
                isPremium: appState.isPremium,
                userName: appState.userName ?? "User",
                firstName: appState.firstName,
                lastName: appState.lastName,
                profilePhotoData: appState.profilePhotoData
            )
            userName = state.displayName
            
            if let photoData = appState.profilePhotoData {
                profileImage = UIImage(data: photoData)
            } else {
                profileImage = nil
            }
        }
        
        let savedDestinations = coreDataService.fetchDestinations()
        
        if savedDestinations.isEmpty {
            let sampleDestinations = destinationDataService.getSampleDestinations()
            coreDataService.saveDestinations(sampleDestinations)
            destinations = sampleDestinations
        } else {
            destinations = savedDestinations
        }
        
        applyFilter()
    }
    
    func applyFilter() {
        var filtered = destinations
        
        if showFavoritesOnly {
            filtered = filtered.filter { $0.isFavorite }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { destination in
                destination.title.localizedCaseInsensitiveContains(searchText) ||
                destination.location.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch selectedFilter {
        case .mostViewed:
            filtered = filtered.sorted { $0.viewCount > $1.viewCount }
        case .nearby:
            filtered = filtered.shuffled()
        case .latest:
            filtered = filtered.reversed()
        case .popular:
            filtered = filtered.sorted { $0.rating > $1.rating }
        }
        
        filteredDestinations = filtered
    }
    
    func toggleFavoritesFilter() {
        withAnimation(.spring(response: 0.3)) {
            showFavoritesOnly.toggle()
            applyFilter()
        }
    }
    
    func toggleFavorite(for destination: Destination) {
        coreDataService.toggleFavorite(for: destination.id)
        loadData()
    }
    
    func selectFilter(_ filter: FilterType) {
        withAnimation(.spring(response: 0.3)) {
            selectedFilter = filter
            applyFilter()
        }
    }
}

import Foundation
import SwiftUI
import Combine

@MainActor
class PaywallViewModel: ObservableObject {
    @Published var selectedPlan: PremiumPlan = .monthly
    @Published var showSuccessAlert: Bool = false
    @Published var isLoading: Bool = false
    
    let plans: [PremiumPlan] = [.monthly, .yearly]
    let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func purchasePremium() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        coreDataService.updatePremiumStatus(true)
        
        var appState = AppState()
        if let savedState = coreDataService.getAppState() {
            appState = AppState(
                hasCompletedOnboarding: savedState.hasCompletedOnboarding,
                hasSeenPaywall: true,
                isPremium: true,
                userName: savedState.userName ?? "User",
                firstName: savedState.firstName,
                lastName: savedState.lastName,
                profilePhotoData: savedState.profilePhotoData
            )
        } else {
            appState.hasSeenPaywall = true
            appState.isPremium = true
        }
        coreDataService.saveAppState(appState)
        isLoading = false
        showSuccessAlert = true
    }
    
    func skipPaywall() {
        var appState = AppState()
        if let savedState = coreDataService.getAppState() {
            appState = AppState(
                hasCompletedOnboarding: savedState.hasCompletedOnboarding,
                hasSeenPaywall: true,
                isPremium: savedState.isPremium,
                userName: savedState.userName ?? "User",
                firstName: savedState.firstName,
                lastName: savedState.lastName,
                profilePhotoData: savedState.profilePhotoData
            )
        } else {
            appState.hasSeenPaywall = true
        }
        coreDataService.saveAppState(appState)
    }
}

enum PremiumPlan: String, Identifiable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    var id: String { rawValue }
    
    var price: String {
        switch self {
        case .monthly: return "$9.99"
        case .yearly: return "$79.99"
        }
    }
    
    var savings: String? {
        switch self {
        case .monthly: return nil
        case .yearly: return "Save 33%"
        }
    }
}

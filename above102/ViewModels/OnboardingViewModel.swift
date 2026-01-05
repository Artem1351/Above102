import Foundation
import SwiftUI
import Combine

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Explore the World",
            description: "Discover amazing destinations and plan your perfect trip",
            imageURL: "https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&h=600&fit=crop"
        ),
        OnboardingPage(
            title: "Start Your Journey",
            description: "Save your favorite destinations and start planning your dream vacation",
            imageURL: "https://images.unsplash.com/photo-1526392060635-9d6019884377?w=800&h=600&fit=crop"
        )
    ]
    
    let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func nextPage() {
        if currentPage < pages.count - 1 {
            withAnimation(.spring(response: 0.5)) {
                currentPage += 1
            }
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            withAnimation(.spring(response: 0.5)) {
                currentPage -= 1
            }
        }
    }
    
    func completeOnboarding() {
        var appState = AppState()
        if let savedState = coreDataService.getAppState() {
            appState = AppState(
                hasCompletedOnboarding: true,
                hasSeenPaywall: savedState.hasSeenPaywall,
                isPremium: savedState.isPremium,
                userName: savedState.userName ?? "User"
            )
        } else {
            appState.hasCompletedOnboarding = true
        }
        coreDataService.saveAppState(appState)
        NotificationCenter.default.post(name: .onboardingCompleted, object: nil)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageURL: String
}

extension Notification.Name {
    static let onboardingCompleted = Notification.Name("onboardingCompleted")
}

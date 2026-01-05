import SwiftUI

struct RootView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showOnboarding = false
    @State private var hasCheckedOnboarding = false
    
    var body: some View {
        Group {
            if !hasCheckedOnboarding {
                ProgressView()
                    .onAppear {
                        checkOnboardingStatus()
                    }
            } else if showOnboarding {
                OnboardingView(coreDataService: coreDataService)
                    .onReceive(NotificationCenter.default.publisher(for: .onboardingCompleted)) { _ in
                        DispatchQueue.main.async {
                            checkOnboardingStatus()
                        }
                    }
            } else {
                HomeView(coreDataService: coreDataService)
            }
        }
    }
    
    private var coreDataService: CoreDataService {
        CoreDataService(context: viewContext)
    }
    
    private func checkOnboardingStatus() {
        let service = coreDataService
        if let appState = service.getAppState() {
            showOnboarding = !appState.hasCompletedOnboarding
        } else {
            showOnboarding = true
        }
        hasCheckedOnboarding = true
    }
}

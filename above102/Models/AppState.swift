import Foundation

struct AppState {
    var hasCompletedOnboarding: Bool
    var hasSeenPaywall: Bool
    var isPremium: Bool
    var userName: String
    var firstName: String?
    var lastName: String?
    var profilePhotoData: Data?
    
    init(hasCompletedOnboarding: Bool = false,
         hasSeenPaywall: Bool = false,
         isPremium: Bool = false,
         userName: String = "User",
         firstName: String? = nil,
         lastName: String? = nil,
         profilePhotoData: Data? = nil) {
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.hasSeenPaywall = hasSeenPaywall
        self.isPremium = isPremium
        self.userName = userName
        self.firstName = firstName
        self.lastName = lastName
        self.profilePhotoData = profilePhotoData
    }
    
    var displayName: String {
        if let firstName = firstName, !firstName.isEmpty {
            if let lastName = lastName, !lastName.isEmpty {
                return "\(firstName) \(lastName)"
            }
            return firstName
        }
        return userName
    }
}

import Foundation
import SwiftUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var profileImage: UIImage?
    @Published var showImagePicker = false
    @Published var showActionSheet = false
    @Published var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var isPremium: Bool = false
    
    let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        loadProfile()
    }
    
    func loadProfile() {
        if let appState = coreDataService.getAppState() {
            firstName = appState.firstName ?? ""
            lastName = appState.lastName ?? ""
            isPremium = appState.isPremium
            
            if let photoData = appState.profilePhotoData {
                profileImage = UIImage(data: photoData)
            }
        }
    }
    
    func saveProfile() {
        let photoData = profileImage?.jpegData(compressionQuality: 0.8)
        coreDataService.updateUserProfile(
            firstName: firstName.isEmpty ? nil : firstName,
            lastName: lastName.isEmpty ? nil : lastName,
            photoData: photoData
        )
    }
    
    func showImageSourceOptions() {
        showActionSheet = true
    }
    
    func selectImageSource(_ sourceType: UIImagePickerController.SourceType) {
        imageSourceType = sourceType
        showImagePicker = true
    }
}

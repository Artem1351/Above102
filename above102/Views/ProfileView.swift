import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showUnsavedChangesAlert = false
    
    init(coreDataService: CoreDataService) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(coreDataService: coreDataService))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        profilePhotoSection
                            .padding(.top, 30)
                        
                        subscriptionStatusSection
                            .padding(.horizontal, 20)
                        
                        nameFieldsSection
                            .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveProfile()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(
                    selectedImage: $viewModel.profileImage,
                    isPresented: $viewModel.showImagePicker,
                    sourceType: viewModel.imageSourceType
                )
            }
            .confirmationDialog("Select Photo", isPresented: $viewModel.showActionSheet, titleVisibility: .visible) {
                Button("Camera") {
                    if PhotoPermissionChecker.checkPermission(for: .camera) {
                        viewModel.selectImageSource(.camera)
                    }
                }
                Button("Photo Library") {
                    if PhotoPermissionChecker.checkPermission(for: .photoLibrary) {
                        viewModel.selectImageSource(.photoLibrary)
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .onAppear {
                viewModel.loadProfile()
            }
        }
    }
    
    private var profilePhotoSection: some View {
        VStack(spacing: 20) {
            Button(action: {
                viewModel.showImageSourceOptions()
            }) {
                ZStack {
                    if let image = viewModel.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 50))
                            }
                    }
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.1), lineWidth: 2)
                )
                .overlay(
                    Circle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        )
                        .offset(x: 40, y: 40)
                )
            }
            
            Text("Tap to change photo")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.gray)
        }
    }
    
    private var subscriptionStatusSection: some View {
        HStack {
            Image(systemName: viewModel.isPremium ? "crown.fill" : "crown")
                .foregroundColor(viewModel.isPremium ? .yellow : .gray)
                .font(.system(size: 20))
            
            Text(viewModel.isPremium ? "Premium Subscription" : "Free Plan")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(16)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var nameFieldsSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("First Name")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                
                TextField("Enter first name", text: $viewModel.firstName)
                    .font(.system(size: 16))
                    .padding(16)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Last Name")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                
                TextField("Enter last name", text: $viewModel.lastName)
                    .font(.system(size: 16))
                    .padding(16)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }
        }
    }
}

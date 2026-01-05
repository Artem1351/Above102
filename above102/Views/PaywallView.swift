import SwiftUI

struct PaywallView: View {
    @StateObject private var viewModel: PaywallViewModel
    @Environment(\.dismiss) var dismiss
    
    init(coreDataService: CoreDataService) {
        _viewModel = StateObject(wrappedValue: PaywallViewModel(coreDataService: coreDataService))
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .padding(8)
                            .background(Color.white.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 60))
                            
                            Text("Unlock Premium")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("Get access to all premium features and exclusive destinations")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            FeatureRow(icon: "star.fill", text: "Access to all destinations")
                            FeatureRow(icon: "heart.fill", text: "Unlimited favorites")
                            FeatureRow(icon: "crown.fill", text: "Premium badge")
                            FeatureRow(icon: "sparkles", text: "Ad-free experience")
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 16)
                        
                        VStack(spacing: 16) {
                            ForEach(viewModel.plans) { plan in
                                PlanCard(
                                    plan: plan,
                                    isSelected: viewModel.selectedPlan == plan
                                ) {
                                    withAnimation(.spring(response: 0.3)) {
                                        viewModel.selectedPlan = plan
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        Button(action: {
                            Task {
                                await viewModel.purchasePremium()
                            }
                        }) {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.9)
                                }
                                Text(viewModel.isLoading ? "Processing..." : "Continue with \(viewModel.selectedPlan.rawValue)")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(viewModel.isLoading ? Color.gray : Color.black)
                            .cornerRadius(28)
                        }
                        .disabled(viewModel.isLoading)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .overlay {
            if viewModel.showSuccessAlert {
                SuccessAlertView {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        viewModel.showSuccessAlert = false
                    }
                    dismiss()
                }
                .transition(.opacity.combined(with: .scale(scale: 0.8)))
                .zIndex(1)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.showSuccessAlert)
    }
}

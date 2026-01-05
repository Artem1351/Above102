import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    init(coreDataService: CoreDataService) {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(coreDataService: coreDataService))
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            TabView(selection: $viewModel.currentPage) {
                ForEach(0..<viewModel.pages.count, id: \.self) { index in
                    OnboardingPageView(
                        page: viewModel.pages[index],
                        pageIndex: index,
                        currentPage: viewModel.currentPage
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            VStack {
                HStack(spacing: 8) {
                    ForEach(0..<viewModel.pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == viewModel.currentPage ? Color.black : Color.gray.opacity(0.3))
                            .frame(width: index == viewModel.currentPage ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.3), value: viewModel.currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                Spacer()
                
                Button(action: {
                    if viewModel.currentPage < viewModel.pages.count - 1 {
                        viewModel.nextPage()
                    } else {
                        viewModel.completeOnboarding()
                    }
                }) {
                    ZStack {
                        if viewModel.currentPage < viewModel.pages.count - 1 {
                            Text("Next")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .transition(.opacity.combined(with: .scale(scale: 0.8)))
                        } else {
                            Text("Get Started")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .transition(.opacity.combined(with: .scale(scale: 0.8)))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.black)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.currentPage)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let pageIndex: Int
    let currentPage: Int
    @State private var imageScale: CGFloat = 0.7
    @State private var imageOpacity: Double = 0.0
    
    var isActive: Bool {
        pageIndex == currentPage
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            AsyncImageLoader(urlString: page.imageURL)
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.horizontal, 40)
                .scaleEffect(imageScale)
                .opacity(imageOpacity)
                .task(id: currentPage) {
                    if isActive {
                        await animateImage()
                    }
                }
                .onDisappear {
                    imageScale = 0.7
                    imageOpacity = 0.0
                }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
    
    @MainActor
    private func animateImage() async {
        imageScale = 0.7
        imageOpacity = 0.0
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        withAnimation(.easeOut(duration: 0.6)) {
            imageScale = 1.05
            imageOpacity = 1.0
        }
        
        try? await Task.sleep(nanoseconds: 600_000_000)
        withAnimation(.easeInOut(duration: 0.4)) {
            imageScale = 1.0
        }
    }
}

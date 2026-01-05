import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showPaywall = false
    @State private var pulseScale: CGFloat = 1.0
    
    init(destination: Destination, coreDataService: CoreDataService) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(
            destination: destination,
            coreDataService: coreDataService
        ))
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    heroImageView
                    contentCard
                        .padding(.top, -30)
                }
            }
        }
        .navigationBarHidden(true)
        .overlay(alignment: .topLeading) {
            backButton
        }
        .overlay(alignment: .topTrailing) {
            favoriteButton
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(coreDataService: CoreDataService(context: viewContext))
        }
    }
    
    private var heroImageView: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImageLoader(urlString: viewModel.destination.imageURL)
                .frame(height: 400)
                .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.destination.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    Text(viewModel.destination.location)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 4) {
                    Text("Price")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                    Text("$\(Int(viewModel.destination.price))")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 45)
        }
    }
    
    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            tabsView
                .padding(.horizontal, 20)
                .padding(.top, 24)
            
            quickInfoView
                .padding(.horizontal, 20)
                .padding(.top, 24)
            
            contentView
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
    
    private var tabsView: some View {
        HStack(spacing: 30) {
            TabButton(
                title: "Overview",
                isSelected: viewModel.selectedTab == .overview
            ) {
                withAnimation(.spring(response: 0.3)) {
                    viewModel.selectedTab = .overview
                }
            }
            
            TabButton(
                title: "Details",
                isSelected: viewModel.selectedTab == .details
            ) {
                withAnimation(.spring(response: 0.3)) {
                    viewModel.selectedTab = .details
                }
            }
        }
    }
    
    private var quickInfoView: some View {
        HStack(spacing: 0) {
            Spacer()
            InfoIcon(icon: "clock.fill", text: viewModel.destination.duration)
            Spacer()
            InfoIcon(icon: "cloud.fill", text: viewModel.destination.temperature)
            Spacer()
            InfoIcon(icon: "star.fill", text: String(format: "%.1f", viewModel.destination.rating))
            Spacer()
        }
    }
    
    private var contentView: some View {
        Group {
            if viewModel.selectedTab == .overview {
                Text(viewModel.destination.overview)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .lineSpacing(4)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(label: "Duration", value: viewModel.destination.duration)
                    DetailRow(label: "Price", value: "$\(Int(viewModel.destination.price))")
                    DetailRow(label: "Rating", value: String(format: "%.1f", viewModel.destination.rating))
                    DetailRow(label: "Location", value: viewModel.destination.location)
                    DetailRow(label: "Temperature", value: viewModel.destination.temperature)
                }
                .transition(.opacity.combined(with: .move(edge: .trailing)))
            }
        }
        .animation(.spring(response: 0.3), value: viewModel.selectedTab)
    }
    
    private var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold))
                .padding(12)
                .background(Color.white.opacity(0.3))
                .clipShape(Circle())
        }
        .padding(.leading, 20)
        .padding(.top, 40)
    }
    
    private var favoriteButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                pulseScale = 1.3
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    pulseScale = 1.0
                }
            }
            viewModel.toggleFavorite()
        }) {
            Image(systemName: viewModel.destination.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(viewModel.destination.isFavorite ? .red : .white)
                .font(.system(size: 18))
                .padding(12)
                .background(Color.white.opacity(0.3))
                .clipShape(Circle())
        }
        .scaleEffect(pulseScale)
        .padding(.trailing, 20)
        .padding(.top, 40)
    }
}

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var showPaywall = false
    @State private var showProfile = false
    @State private var showAllDestinations = false
    @State private var selectedDestination: Destination?
    @Environment(\.managedObjectContext) private var viewContext
    
    init(coreDataService: CoreDataService) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(coreDataService: coreDataService))
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    headerView
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    searchBarWithActionsView
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    popularPlacesSection
                        .padding(.top, 30)
                    
                    filterButtonsView
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    destinationGrid
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showPaywall) {
                PaywallView(coreDataService: CoreDataService(context: viewContext))
                    .onDisappear {
                        viewModel.loadData()
                    }
            }
            .sheet(isPresented: $showProfile) {
                ProfileView(coreDataService: CoreDataService(context: viewContext))
                    .onDisappear {
                        viewModel.loadData()
                    }
            }
            .sheet(isPresented: $showAllDestinations) {
                AllDestinationsView(coreDataService: CoreDataService(context: viewContext))
            }
            .sheet(item: $selectedDestination) { destination in
                DetailView(
                    destination: destination,
                    coreDataService: CoreDataService(context: viewContext)
                )
            }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hi, \(viewModel.userName)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                + Text(" 👋")
                    .font(.system(size: 24))
                
                Text("Explore the world")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                showProfile = true
            }) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 24))
                            }
                    }
                    
                    if viewModel.isPremium {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 16))
                            .rotationEffect(.degrees(40))
                            .offset(x: 18, y: -22)
                            .transition(.scale(scale: 0.5).combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: viewModel.isPremium)
            }
        }
    }
    
    private var searchBarWithActionsView: some View {
        HStack(spacing: 6) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
                
                TextField("Search places", text: $viewModel.searchText)
                    .onChange(of: viewModel.searchText) { _ in
                        viewModel.applyFilter()
                    }
                    .padding(.trailing, 16)
            }
            .frame(height: 50)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 30)
            
            HStack(spacing: 6) {
                Button(action: {
                    showPaywall = true
                }) {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 20))
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                Button(action: {
                    viewModel.toggleFavoritesFilter()
                }) {
                    Image(systemName: viewModel.showFavoritesOnly ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.showFavoritesOnly ? .red : .gray)
                        .font(.system(size: 20))
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
    
    private var popularPlacesSection: some View {
        HStack {
            Text("Popular places")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Button("View all") {
                showAllDestinations = true
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
    }
    
    private var filterButtonsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(FilterType.allCases, id: \.self) { filter in
                    FilterButton(
                        title: filter.rawValue,
                        isSelected: viewModel.selectedFilter == filter
                    ) {
                        viewModel.selectFilter(filter)
                    }
                }
            }
        }
    }
    
    private var destinationGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(viewModel.filteredDestinations) { destination in
                Button(action: {
                    let isLocked = destinationNeedsPremium(destination) && !viewModel.isPremium
                    if isLocked {
                        showPaywall = true
                    } else {
                        selectedDestination = destination
                    }
                }) {
                    DestinationCard(
                        destination: destination,
                        isLocked: destinationNeedsPremium(destination) && !viewModel.isPremium,
                        onFavoriteToggle: {
                            viewModel.toggleFavorite(for: destination)
                        }
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func destinationNeedsPremium(_ destination: Destination) -> Bool {
        let freeDestinationIds = ["1", "2", "3"]
        return !freeDestinationIds.contains(destination.id)
    }
}

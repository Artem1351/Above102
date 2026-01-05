import SwiftUI

struct AllDestinationsView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var selectedDestination: Destination?
    @State private var showPaywall = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    init(coreDataService: CoreDataService) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(coreDataService: coreDataService))
    }
    
    private func destinationNeedsPremium(_ destination: Destination) -> Bool {
        let freeDestinationIds = ["1", "2", "3"]
        return !freeDestinationIds.contains(destination.id)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(viewModel.destinations) { destination in
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
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("All Destinations")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(coreDataService: CoreDataService(context: viewContext))
                    .onDisappear {
                        viewModel.loadData()
                    }
            }
            .sheet(item: $selectedDestination) { destination in
                DetailView(
                    destination: destination,
                    coreDataService: CoreDataService(context: viewContext)
                )
            }
        }
    }
}

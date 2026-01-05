import SwiftUI

struct DestinationCard: View {
    let destination: Destination
    let isLocked: Bool
    let onFavoriteToggle: () -> Void
    @State private var isFavorite: Bool
    @State private var pulseScale: CGFloat = 1.0
    
    init(destination: Destination, isLocked: Bool = false, onFavoriteToggle: @escaping () -> Void) {
        self.destination = destination
        self.isLocked = isLocked
        self.onFavoriteToggle = onFavoriteToggle
        _isFavorite = State(initialValue: destination.isFavorite)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImageLoader(urlString: destination.imageURL)
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )
                    .overlay {
                        if isLocked {
                            ZStack {
                                Color.black.opacity(0.5)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                
                                VStack(spacing: 8) {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 32))
                                    
                                    Text("Premium")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        pulseScale = 1.3
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            pulseScale = 1.0
                        }
                    }
                    isFavorite.toggle()
                    onFavoriteToggle()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .white)
                        .font(.system(size: 18))
                        .padding(8)
                        .background(Color.white.opacity(0.3))
                        .clipShape(Circle())
                }
                .scaleEffect(pulseScale)
                .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(destination.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    Text(destination.location)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                    Text(String(format: "%.1f", destination.rating))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black)
                }
            }
            .padding(.top, 8)
        }
    }
}

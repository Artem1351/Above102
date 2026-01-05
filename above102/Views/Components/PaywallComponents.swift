import SwiftUI

struct SuccessAlertView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(
                    Rectangle()
                        .fill(Color.white.opacity(0.4))
                )
                .ignoresSafeArea()
                .onTapGesture {}
            
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 60))
                
                Text("Purchase Successful!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("You now have access to all premium features")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button(action: onDismiss) {
                    Text("Great")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.black)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.top, 8)
            }
            .padding(32)
            .background(Color.white)
            .cornerRadius(24)
            .padding(.horizontal, 40)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.yellow)
                .font(.system(size: 20))
            
            Text(text)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black)
            
            Spacer()
        }
    }
}

struct PlanCard: View {
    let plan: PremiumPlan
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan.rawValue)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        if let savings = plan.savings {
                            Text(savings)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                    }
                    
                    Text(plan.price)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .black : .gray)
                    .font(.system(size: 24))
            }
            .padding(20)
            .background(isSelected ? Color.black.opacity(0.05) : Color.gray.opacity(0.1))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
            )
        }
    }
}

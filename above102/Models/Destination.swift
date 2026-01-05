import Foundation

struct Destination: Identifiable, Codable {
    let id: String
    let title: String
    let location: String
    let imageURL: String
    let rating: Double
    let price: Double
    let duration: String
    let temperature: String
    let overview: String
    let details: String
    var isFavorite: Bool
    var viewCount: Int
    
    init(id: String = UUID().uuidString,
         title: String,
         location: String,
         imageURL: String,
         rating: Double,
         price: Double,
         duration: String,
         temperature: String,
         overview: String,
         details: String,
         isFavorite: Bool = false,
         viewCount: Int = 0) {
        self.id = id
        self.title = title
        self.location = location
        self.imageURL = imageURL
        self.rating = rating
        self.price = price
        self.duration = duration
        self.temperature = temperature
        self.overview = overview
        self.details = details
        self.isFavorite = isFavorite
        self.viewCount = viewCount
    }
}

enum FilterType: String, CaseIterable {
    case mostViewed = "Most Viewed"
    case nearby = "Nearby"
    case latest = "Latest"
    case popular = "Popular"
}

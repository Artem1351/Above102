import Foundation

class DestinationDataService {
    static let shared = DestinationDataService()
    
    func getSampleDestinations() -> [Destination] {
        return [
            Destination(
                id: "1",
                title: "Swiss Alps",
                location: "Switzerland, Switzerland",
                imageURL: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop",
                rating: 4.9,
                price: 250,
                duration: "8 hours",
                temperature: "5 °C",
                overview: "The Swiss Alps offer breathtaking mountain views, pristine lakes, and charming alpine villages. Experience world-class skiing, hiking, and the iconic Matterhorn.",
                details: "The Swiss Alps are a mountain range in Switzerland, known for their stunning beauty and world-class resorts. The region offers activities year-round, from skiing in winter to hiking and mountaineering in summer.",
                viewCount: 1250
            ),
            Destination(
                id: "2",
                title: "Mount Fuji",
                location: "Tokyo, Japan",
                imageURL: "https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=800&h=600&fit=crop",
                rating: 4.8,
                price: 180,
                duration: "6 hours",
                temperature: "18 °C",
                overview: "Mount Fuji is Japan's highest peak, standing at 3,776 meters. This iconic volcano is a UNESCO World Heritage Site and a symbol of Japan. The mountain offers stunning views, especially during sunrise and cherry blossom season.",
                details: "Mount Fuji is an active stratovolcano located on Honshu Island. It's one of Japan's Three Holy Mountains and has been a source of inspiration for artists and poets for centuries.",
                viewCount: 980
            ),
            Destination(
                id: "3",
                title: "Machu Picchu",
                location: "Peru, Peru",
                imageURL: "https://images.unsplash.com/photo-1526392060635-9d6019884377?w=800&h=600&fit=crop",
                rating: 4.8,
                price: 320,
                duration: "10 hours",
                temperature: "15 °C",
                overview: "Machu Picchu is an ancient Incan citadel set high in the Andes Mountains. This archaeological wonder offers breathtaking views and a glimpse into the Incan civilization.",
                details: "Built in the 15th century, Machu Picchu is one of the New Seven Wonders of the World. The site features sophisticated stone structures and terraces that showcase Incan engineering.",
                viewCount: 1100
            ),
            Destination(
                id: "4",
                title: "Grand Canyon",
                location: "Arizona, USA",
                imageURL: "https://images.unsplash.com/photo-1474044159687-1ee9f3a51722?w=800&h=600&fit=crop",
                rating: 4.7,
                price: 150,
                duration: "5 hours",
                temperature: "22 °C",
                overview: "The Grand Canyon is one of the world's most spectacular natural wonders. Carved by the Colorado River, it offers stunning vistas and incredible geological formations.",
                details: "The Grand Canyon is 277 miles long, up to 18 miles wide, and over a mile deep. It's a UNESCO World Heritage Site and attracts millions of visitors each year.",
                viewCount: 850
            ),
            Destination(
                id: "5",
                title: "Santorini",
                location: "Greece, Greece",
                imageURL: "https://images.unsplash.com/photo-1613395877344-13d4a8e0d49e?w=800&h=600&fit=crop",
                rating: 4.9,
                price: 280,
                duration: "7 hours",
                temperature: "25 °C",
                overview: "Santorini is a stunning Greek island known for its white-washed buildings, blue domes, and spectacular sunsets. The island offers beautiful beaches and rich history.",
                details: "Santorini is a volcanic island in the Aegean Sea. It's famous for its dramatic cliffs, unique architecture, and the ancient city of Akrotiri, preserved by volcanic ash.",
                viewCount: 1400
            ),
            Destination(
                id: "6",
                title: "Banff National Park",
                location: "Alberta, Canada",
                imageURL: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop",
                rating: 4.8,
                price: 200,
                duration: "9 hours",
                temperature: "12 °C",
                overview: "Banff National Park is Canada's oldest national park, featuring turquoise lakes, snow-capped peaks, and abundant wildlife. It's a paradise for outdoor enthusiasts.",
                details: "Located in the Canadian Rockies, Banff offers world-class hiking, skiing, and wildlife viewing. The park is home to Lake Louise and Moraine Lake, two of the most photographed lakes in the world.",
                viewCount: 920
            )
        ]
    }
}

//create by sejal
import Foundation
struct Roots:Decodable {
    var products: [Product]
    
}
struct Product:Decodable {
    var id: Int
    var title: String
    var description: String
    var price: Int
    var discountPercentage:Int
    var rating: Double
    var stock: Int
    var brand: String
    var thumbnail: String
    var category : String
}
        

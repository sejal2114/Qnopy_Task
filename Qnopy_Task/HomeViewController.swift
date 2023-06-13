import UIKit
import Foundation
import SDWebImage

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var productArray: [Product] = []
    //var protocolProductData: ProtocolProductData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchApi(url:"https://dummyjson.com/products", methodOfHttp: "GET")

        let nib = UINib(nibName: "ProductsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProductsTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
     
    func fetchApi(url: String, methodOfHttp: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = methodOfHttp
        
        let urlSession = URLSession(configuration: .default)
        
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let responseData = data else {
                print("Data is nil")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let root = try! decoder.decode(Roots.self, from: responseData)
                self.productArray = root.products
              //  self.protocolProductData?.reloadView()
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        dataTask.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell", for: indexPath) as! ProductsTableViewCell
        let product = productArray[indexPath.row]
        cell.titleLabel.text = product.title
        cell.brandLabel.text = product.brand
        cell.categoryLabel.text = product.category
        cell.priceLabel.text = "Price: \(product.price)"
        cell.ratingLabel.text = "Rating: \(product.rating)"
        cell.DiscountLabel.text = "discountPercentage: \(product.discountPercentage)"
        cell.descriptionLabel.text = product.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension HomeViewController: ProtocolProductData {
    func reloadView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

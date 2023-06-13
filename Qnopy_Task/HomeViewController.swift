import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var productArray: [Product] = []
    var protocolProductData: ProtocolProductData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
        // Fetch products
     fetchApi(url: "https://dummyjson.com/products", methodOfHttp: "GET")
        tableView.delegate = self
        tableView.dataSource = self
    }
    func registerNib(){
        let nib = UINib(nibName: "ProductsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProductsTableViewCell")
        
    }
    func fetchApi(url:String, methodOfHttp:String) {
        //Create a URL object
        guard let url = URL(string: url) else {
            return
        }
        // create a URLRequest object and pass it to the dataTask(with:) method.
        var request = URLRequest(url: url)
        request.httpMethod = methodOfHttp
        //create object of urlsession
        let urlSession = URLSession(configuration: .default)
        
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            guard let responseData = data else {
              print("Data Nil")
              return
            }
            print(String(data: responseData, encoding: .utf8)!)
             
            let decoder = JSONDecoder()
            let root:Roots = try!decoder.decode(Roots.self, from: responseData) // decoding responce data wicha are coming from webservice n converting into specific typ i.e.Roots and storing in variable root
            
            self.productArray = root.products
            
            self.protocolProductData?.reloadView()
            
        }
        dataTask.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell", for: indexPath)as! ProductsTableViewCell
        let product = productArray[indexPath.row]
        cell.titleLabel.text = product.title
        cell.brandLabel.text = "brand: \(product.brand)"
        cell.categoryLabel.text = "Category : \(product.category)"
        cell.priceLabel.text = "Price : \(product.price)"
        cell.ratingLabel.text = "Rating :\(product.rating)"
        cell.DiscountLabel.text = "discountPercentage : \(product.discountPercentage)"
        
        
        
       
        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension HomeViewController : ProtocolProductData {
        func reloadView() {
                DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    
}


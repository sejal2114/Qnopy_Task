import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailidTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        sendLoginRequest()
    }

    // Define the API URL
    let apiUrlString = "http://restapi.adequateshop.com/api/authaccount/login"

    // Define the request parameters as a dictionary
    let parameters = [
        "email": "Developer5@gmail.com",
        "password": "123456"
    ]

    // Function to create and send the request
    func sendLoginRequest() {
        // Create the request URL from the API URL string
        guard let url = URL(string: apiUrlString) else {
            print("Invalid URL")
            return
        }

        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Set the request body
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }

        // Set the request headers if necessary
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the data task to send the request
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            // Handle the response
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            // Parse the response data as JSON
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Handle the JSON response
                    print(json)
                    // Extract the necessary data from the response
                    if let code = json["code"] as? Int, let message = json["message"] as? String {
                        if code == 0 {
                            if let userData = json["data"] as? [String: Any], let name = userData["Name"] as? String {
                                // User data and name extraction
                                print("Name: \(name)")
                                DispatchQueue.main.async {
                                    self?.userNameLabel.text = "Welcome \(name)"
                                }
                            }
                        } else {
                            print("Error: \(message)")
                        }
                    }
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }

        // Start the data task
        task.resume()
    }
}

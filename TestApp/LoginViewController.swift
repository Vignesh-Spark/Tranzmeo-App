//
//  ViewController.swift
//  TestApp
//
//  Created by VIGNESH on 16/12/21.
//

import UIKit

struct constants {
    
    static let loginApi = "https://dapi.quikdr.com/authentication"
    static let doctorListApi = "https://dapi.quikdr.com/search?limit=50&skip=0"
    static let timeSlotApi = "https://dapi.quikdr.com/schedules?doctorsId=89&organisationsId=2&date[$gte]=2021-11-04&date[$lte]=2021-11-10&$skip=0&$limit=500&$sort[date]=1&$sort[time]=1"
    
    static let headers = "C1kxIHN1D81zT7DXFQINoiQKDRXIMLCWTugbg9CorYg5SIxHsBBLNvNbebCxoC1qWhtx"
}


class tokenManager  {
    var token :String?
    static let sharedInstance = tokenManager()
}

func showLoader(view: UIView) -> UIActivityIndicatorView {


       let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
       spinner.backgroundColor = UIColor.black.withAlphaComponent(0.7)
       spinner.layer.cornerRadius = 3.0
       spinner.clipsToBounds = true
       spinner.hidesWhenStopped = true
        spinner.style = UIActivityIndicatorView.Style.white;
       spinner.center = view.center
       view.addSubview(spinner)
       spinner.startAnimating()
       UIApplication.shared.beginIgnoringInteractionEvents()

       return spinner
   }

extension UIActivityIndicatorView {
     func dismissLoader() {
        DispatchQueue.main.async {
        
            self.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
 }

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var passwordField : UITextField!
    
    var email : String!
    var password : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        
//        self.emailField.text = "benjamin.benny1995@outlook.com"
//        self.passwordField.text = "12345678"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func fetchApi(params : Dictionary<String, String>){
        
        let spinner = showLoader(view: self.view)
        var request = URLRequest(url: URL(string: constants.loginApi)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.allHTTPHeaderFields = [ "Content-Type": "application/json",
                                        "api-header-security" : constants.headers
        ]

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
//            print(response!)
            spinner.dismissLoader()
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                if let dictionary = json as? [String: Any] {
                    if let token = dictionary["accessToken"] as? String {                   
                        
                        tokenManager.sharedInstance.token = token
                        let doctorVc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorListViewController") as! DoctorListViewController
                        
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(doctorVc, animated: true)
                        }
                    }
                    else if let msg = dictionary["message"] as? String {
                        self.showAlert(message: msg)
                    }
                }
                
            } catch {
                print("error")
                self.showAlert(message: "Login Failed!")
            }
        })

        task.resume()
        
    }
    func showAlert(message : String)  {
        DispatchQueue.main.async {
      
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func loginTapped(_ sender: UIButton) {
        
        self.email = self.emailField.text
        self.password = self.passwordField.text
        
        if self.email != "" && self.password != ""{
            let params = ["strategy":"local","email":self.email, "password":self.password] as! Dictionary<String, String>
            self.fetchApi(params: params)
        }
        else{
            self.showAlert(message: "Invalid Entry")
        }
    }
}


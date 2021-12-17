//
//  DoctorListViewController.swift
//  TestApp
//
//  Created by VIGNESH on 16/12/21.
//

import UIKit

struct doctorData: Decodable {
    
    var initials: String?
    var firstName: String?
    var lastName: String?
    var orgname: String?
    var profilephotourl: String?
    var descriptions: String?
    var experience: Float?
    var specialization: String?
    var isQuikdr: Bool
}

class DoctorListViewController: UIViewController {
    
    @IBOutlet weak var doctorListTableview : UITableView!

    var doctorList : [doctorData]!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.doctorList = []
        self.doctorListTableview.delegate = self
        self.doctorListTableview.dataSource = self
        
        self.fetchApi()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Doctors"
    }
    
    func fetchApi(){
        
        let params = ["city":"","name": "","location": "","startdate": "2021-11-04","enddate": "2021-11-10","consult": "[1,3,2,4]","rating": "","gender": "","orgfeelow": 0,"spec": "[]","orgfeehigh": 5000] as [String : Any]

        
        var request = URLRequest(url: URL(string: constants.doctorListApi)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.allHTTPHeaderFields = [ "Content-Type": "application/json",
                                        "api-header-security" : constants.headers,
                                        "Authorization" : tokenManager.sharedInstance.token!
        ]

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
//            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! [Dictionary<String, AnyObject>]
//                print(json)
                
                do{
                    let jsonModel = try JSONDecoder().decode([doctorData].self, from: data!)
                    self.doctorList = jsonModel
                    
                    DispatchQueue.main.async {
                        self.doctorListTableview.reloadData()
                    }
                    
                    
                }catch{
                    print("--- Json model error ---",error)
                }
                
            } catch {
                print("respons error")
            }
        })
        task.resume()
    }
    
}
extension DoctorListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorTableViewCell") as! DoctorTableViewCell
        cell.setData(data: doctorList[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let timeSlotVc = self.storyboard?.instantiateViewController(withIdentifier: "TimeSlotViewController") as! TimeSlotViewController
        
        self.navigationController?.pushViewController(timeSlotVc, animated: true)
    }
}


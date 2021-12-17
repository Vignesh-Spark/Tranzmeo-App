//
//  TimeSlotViewController.swift
//  TestApp
//
//  Created by VIGNESH on 16/12/21.
//

import UIKit


struct responseData: Codable {
    
    let total, limit, skip: Int
    let data: [neededData]
}

struct neededData: Codable {
    
    let id: Int
    let isVacant: Bool
    let duration: Int
    let date, time: String
    let createdAt, updatedAt: String
    let doctorsID, createdByID, createdByTypeID, organisationsID: Int
    let orgFeesID, consultationTypeID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, isVacant, duration, date, time, createdAt, updatedAt
        case doctorsID = "doctorsId"
        case createdByID = "createdById"
        case createdByTypeID = "createdByTypeId"
        case organisationsID = "organisationsId"
        case orgFeesID = "orgFeesId"
        case consultationTypeID = "consultationTypeId"
    }
}
struct date {
    
    var index : Int
    var dateValue : String
    var isSelected : Bool
    
}

class TimeSlotViewController: UIViewController {
    
    
    @IBOutlet weak var segmentCollectionView: UICollectionView!
    @IBOutlet weak var morningTimeCollectionView : UICollectionView!
    @IBOutlet weak var noonTimeCollectionView : UICollectionView!
    
    var data : [neededData]!
    var segmentDate :[date]!
    var morningTime : [String]!
    var noonTime : [String]!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
//        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Select Schedule"
        
        self.morningTime = [String]()
        self.noonTime = [String]()
        self.segmentDate = []
        
        self.segmentCollectionView.tag = -1
        self.morningTimeCollectionView.tag = 0
        self.noonTimeCollectionView.tag = 1
        
        self.segmentCollectionView.delegate = self
        self.segmentCollectionView.dataSource = self
        
        self.morningTimeCollectionView.delegate = self
        self.morningTimeCollectionView.dataSource = self
        
        self.noonTimeCollectionView.delegate = self
        self.noonTimeCollectionView.dataSource = self
        
        let layout1: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout1.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout1.itemSize = CGSize(width: 100, height: 40)
        layout1.minimumInteritemSpacing = 0
        layout1.minimumLineSpacing = 20

        
        self.morningTimeCollectionView!.collectionViewLayout = layout1
        
        let layout2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout2.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout2.itemSize = CGSize(width: 100, height: 40)
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 20

        self.noonTimeCollectionView.collectionViewLayout = layout2
       
        self.fetchApi()
        
    }
    
    func fetchApi(){

        var request = URLRequest(url: URL(string: constants.timeSlotApi)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [ "Content-Type": "application/json",
                                        "api-header-security" : constants.headers,
                                        "Authorization" : tokenManager.sharedInstance.token!
        ]

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
//            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
//                print(json)

                    let jsonModel = try JSONDecoder().decode(responseData.self, from: data!)
                    self.data = jsonModel.data
                
                    self.sortTime()
                
            } catch {
                print("error")
            }
        })

        task.resume()

    }
    
    func sortTime()  {
        
        var duplicateDate = [""]
        
        for data in self.data {
            
            if !duplicateDate.contains(data.date){
                self.segmentDate.append(date(index: 0, dateValue: data.date, isSelected: false))
                duplicateDate.append(data.date)
            }
        }
        
        if self.segmentDate.count >= 1 {
            print("Total dates",segmentDate.count)
            self.segmentDate[0].isSelected = true
            self.findTimeSlot(index: 0)
        }
    }
    func findTimeSlot(index : Int)  {
        
        self.morningTime = [String]()
        self.noonTime = [String]()
        
        for data in self.data {
            
            if data.date == self.segmentDate[index].dateValue {
                let formattedStr = self.formatTime(time: data.time)
//                print(formattedStr)
                if formattedStr.contains("AM") {
                    self.morningTime.append(formattedStr)
                }else if formattedStr.contains("PM"){
                    self.noonTime.append(formattedStr)
                }
            }
        }

               
        DispatchQueue.main.async {
            
            self.morningTimeCollectionView.reloadData()
            self.noonTimeCollectionView.reloadData()
            self.segmentCollectionView.reloadData()
            
            
        }
    }
    
    func formatTime(time : String) -> String{
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        inFormatter.dateFormat = "HH:mm:ss"

        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        outFormatter.dateFormat = "hh:mm a"

//        let inStr = "16:50"
        let date = inFormatter.date(from: time)!
        let outStr = outFormatter.string(from: date)
        
        return outStr
 
    }
}

extension TimeSlotViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                
        if collectionView.tag == 0 {
            return self.morningTime.count
        }else if collectionView.tag == 1{
            return self.noonTime.count
        }
        else{
            return self.segmentDate.count
        }
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCVCell", for: indexPath) as! TimeCVCell
            cell.timeLabel.text = self.morningTime[indexPath.item]
            return cell
        }else if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCVCell", for: indexPath) as! TimeCVCell
            cell.timeLabel.text = self.noonTime[indexPath.item]
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSelectorCell", for: indexPath) as! TimeSelectorCell
            
            cell.dateDate = self.segmentDate[indexPath.item]
            self.segmentDate[indexPath.item].index = indexPath.item
            cell.configure()
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == -1 {
            
            for dates in self.segmentDate {
                self.segmentDate[dates.index].isSelected = false
            }
            self.segmentDate[indexPath.item].isSelected = true
            
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            self.findTimeSlot(index: indexPath.item)
            
        }
    }
    
}

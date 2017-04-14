//
//  ViewController.swift
//  CurrentWeather
//
//  Created by Louis Curty on 15/02/2017.
//  Copyright © 2017 Louis Curty. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var textCityName: UITextField!
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Prediction: UIButton!
    @IBOutlet weak var imageMeteo: UIImageView!
    @IBOutlet weak var Temperature: UILabel!
    var resList: NSArray = [];
   
    @IBAction func Prediction(_ sender: UIButton) {
        if tableView.isHidden == false{
            tableView.isHidden = true
        }else{
            tableView.isHidden = false
        }
    }
    
    //MARK: UITextFieldDelegate
    @IBOutlet weak var tableView: UITableView!

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resList.count - 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:TableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cellID") as UITableViewCell! as! TableViewCell
        
        let resTemps = resList[indexPath.row + 1] as? NSDictionary
        let resTemp = resTemps?["temp"] as?NSDictionary
        let resWeathers = resTemps?["weather"] as?NSArray
        let resWeather = resWeathers?[0] as? NSDictionary
        let tempEve = resTemp?["eve"] as? Double
        let tempMorn = resTemp?["morn"] as? Double
        let tempNight = resTemp?["night"] as? Double
        let dt = resTemps?["dt"] as? Double
        let date = NSDate(timeIntervalSince1970: dt!) as? Date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        
        let Rdate = dateFormatter.string(from: date!)
        
        // set the text from the data model
        cell.Day.text = String(describing: Rdate)
        cell.tempEve.text = String(format: "%.0f", tempEve!) + "°C"
        cell.tempMorn.text = String(format: "%.0f", tempMorn!) + "°C"
        cell.tempNight.text = String(format: "%.0f", tempNight!) + "°C"
        switch resWeather?["main"] as? String ?? "" {
        case "Clear" : cell.imagePred.image = #imageLiteral(resourceName: "Soleil")
        case "Rain" : cell.imagePred.image = #imageLiteral(resourceName: "Pluie")
        case "Drizzle" : cell.imagePred.image = #imageLiteral(resourceName: "Pluie")
        case "Thunderstorm" : cell.imagePred.image = #imageLiteral(resourceName: "Orage")
        case "Extreme" : cell.imagePred.image = #imageLiteral(resourceName: "Orage")
        case "Snow" : cell.imagePred.image = #imageLiteral(resourceName: "Neige")
        case "Hail" : cell.imagePred.image = #imageLiteral(resourceName: "Grele")
        default : cell.imagePred.image = #imageLiteral(resourceName: "Nuage")
        }

        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // self.tableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        searchCity(citySearch: textCityName.text!)
    }
    
    //MARK: Private Methode
    func searchCity(citySearch: String){
        let todoEndpoint: String = "http://api.openweathermap.org/data/2.5/forecast/daily?q="+citySearch+"&APPID=31abd5886e38d7cc2413358ed529f9ec&units=metric&cnt=16"
        guard let url = URL(string: todoEndpoint) else {
            print("Error can't create URL")
            let alert = UIAlertController(title: "Erreur", message: "Assurez vous de ne pas avoir mis d'espace ou que la ville existe bien", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest){
            data, response, error in
            //check for any errors
            guard error == nil else {
                print("error calling GET on search")
                print(error!)
                return
            }
            //make sure we got data
            guard let responseData = data else {
                print("error did not receive data")
                return
            }
            //parse the result as JSON, since that's what the API provides
            do {
                guard let res = try JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                let resCity = res["city"] as? NSDictionary
                self.resList = (res["list"] as? NSArray)!
                
                let resTemps = self.resList[0] as? NSDictionary
                let resTemp = resTemps?["temp"] as?NSDictionary
                let resWeathers = resTemps?["weather"] as?NSArray
                let resWeather = resWeathers?[0] as? NSDictionary
                let temp = resTemp?["day"] as? Double
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.labelCityName.text = resCity?["name"] as? String ?? ""
                    self.Temperature.isHidden = false
                    self.Description.isHidden = false
                    self.labelTemperature.isHidden = false
                    self.Prediction.isHidden = false
                    self.labelTemperature.text = String(format: "%.0f", temp!) + "°C"
                    self.imageMeteo.isHidden = false
                    switch resWeather?["main"] as? String ?? "" {
                    case "Clear" : self.imageMeteo.image = #imageLiteral(resourceName: "Soleil")
                    case "Rain" : self.imageMeteo.image = #imageLiteral(resourceName: "Pluie")
                    case "Drizzle" : self.imageMeteo.image = #imageLiteral(resourceName: "Pluie")
                    case "Thunderstorm" : self.imageMeteo.image = #imageLiteral(resourceName: "Orage")
                    case "Extreme" : self.imageMeteo.image = #imageLiteral(resourceName: "Orage")
                    case "Snow" : self.imageMeteo.image = #imageLiteral(resourceName: "Neige")
                    case "Hail" : self.imageMeteo.image = #imageLiteral(resourceName: "Grele")
                    default : self.imageMeteo.image = #imageLiteral(resourceName: "Nuage")
                    }
                    
                }
                
                //print(self.resList)
            } catch {
                print("error parsing response from")
            }
            
        }
        task.resume()
        
    }


}


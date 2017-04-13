//
//  ViewController.swift
//  CurrentWeather
//
//  Created by Louis Curty on 15/02/2017.
//  Copyright © 2017 Louis Curty. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var textCityName: UITextField!
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var imageMeteo: UIImageView!
    @IBOutlet weak var Temperature: UILabel!
   
    @IBAction func Prediction(_ sender: UIButton) {
        if tableView.isHidden == false{
            tableView.isHidden = true
        }else{
            tableView.isHidden = false
        }
    }
    
    //MARK: UITextFieldDelegate
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tempNight: UITextField!
    @IBOutlet weak var tempEve: UITextField!
    @IBOutlet weak var tempMorn: UITextField!
    @IBOutlet weak var day: UITextField!
    @IBOutlet weak var imageMeteoPred: UIImageView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //imageMeteo.isHidden = true
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
                let resList = res["list"] as? NSArray
                
                let resTemps = resList?[0] as? NSDictionary
                let resTemp = resTemps?["temp"] as?NSDictionary
                let resWeathers = resTemps?["weather"] as?NSArray
                let resWeather = resWeathers?[0] as? NSDictionary
                let temp = resTemp?["day"] as? Double
                
                
                DispatchQueue.main.async {
                    self.labelCityName.text = resCity?["name"] as? String ?? ""
                    self.Temperature.isHidden = false
                    self.Description.isHidden = false
                    self.labelTemperature.isHidden = false
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
                    
                    for i in 0..<16{
                        
                    }
                }
                
                print(res)
            } catch {
                print("error parsing response from")
            }
            
        }
        task.resume()
        
    }


}


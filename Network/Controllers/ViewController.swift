//
//  ViewController.swift
//  Network
//
//  Created by Christopher Smith on 11/13/17.
//  Copyright © 2017 Christopher Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //  MARK: - Properties
    
    let urlString = "https://api.cryptonator.com/api/ticker/btc-usd"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        let todayDate = Date()
        let myCalendar = Calendar(identifier: .gregorian)
        let myComponents = myCalendar.component(.weekday, from: todayDate)
        let weekDay = myComponents
        
        func weekDayString(fromNumber weekDay: Int) -> String {
            
            switch weekDay {
                
            case 0:
                return "Sunday"
            case 1:
                return "Monday"
            case 2:
                return "Tuesday"
            case 3:
                return "Wednesday"
            case 4:
                return "Thursday"
            case 5:
                return "Friday"
            case 6:
                return "Saturday"
            default:
                return "Unknown day"
            }
        }
        
        dateFormatter.timeStyle = .short
        self.title = "Bitcoin Value"
        
        let finalTime = weekDayString(fromNumber: weekDay) + " " + dateFormatter.string(from: currentDateTime)
        
        self.currentTimeLabel.text = finalTime
        self.currencyLabel.font = UIFont(name: currencyLabel.font.fontName, size: 60)
        self.valueLabel.font = UIFont(name: valueLabel.font.fontName, size: 60)
        self.currentTimeLabel.font = UIFont(name: currentTimeLabel.font.fontName, size: 18)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let url = URL(string: urlString) else {
            print("Error: Could not create Url")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                
                do {
                    
                    if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String,Any> {
                        
                        if let tickerDictionary = jsonDictionary["ticker"] as? Dictionary<String,Any> {
                            
                            if let name = tickerDictionary["base"] as? String {
                                
                                DispatchQueue.main.async { [unowned self] in
                                    self.currencyLabel.text = name
                                }
                            }
                            
                            if let value = tickerDictionary["price"] as? String {
                                
                                DispatchQueue.main.async { [unowned self] in
                                    self.valueLabel.text = value
                                }
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}

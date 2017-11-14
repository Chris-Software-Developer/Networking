//
//  ViewController.swift
//  Network
//
//  Created by Christopher Smith on 11/13/17.
//  Copyright © 2017 Christopher Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let urlString = "https://api.cryptonator.com/api/ticker/btc-usd"
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBAction func buttonPushed(_ sender: Any) {
        
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



//
//  ViewController.swift
//  BWCurrencyPickerView
//
//  Created by Bastian Wirth on 21.12.15.
//  Copyright © 2015 Bastian Wirth. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BWCurrencyPickerViewDelegate {

    @IBOutlet weak var currencyPickerView: BWCurrencyPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPickerView.currencyDelegate = self
        let locale = NSLocale(localeIdentifier: "de_DE")
        currencyPickerView.locale = locale
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func displayAllPushed(sender: AnyObject) {
        currencyPickerView.currencySource = .AllCurrencies
    }

    @IBAction func displayStandardPushed(sender: AnyObject) {
        currencyPickerView.currencySource = .StandardCurrencies
    }
    
    func currencyPickerView(currencyPickerView: BWCurrencyPickerView, didSelectCurrency currency: BWCurrency) {
        print("Did select code \(currency.currencyCode) with name \(currency.localizedCurrencyName)")
    }

}


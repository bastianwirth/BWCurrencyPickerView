//The MIT License (MIT)
//
//Copyright (c) [2015] [Bastian Wirth]
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

// Version 1.00

import UIKit

public enum BWCurrencyPickerViewDisplayMode : Int {
    case CurrencyCode
    case LocalizedName
}

public enum BWCurrencyPickerViewCurrencySource : Int {
    case AllCurrencies
    case StandardCurrencies
    case UserDefinedCurrencies
}

@objc class BWCurrencyPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    private var allCurrencies: [BWCurrency]?
    private var sortedCurrencies: [BWCurrency]?
    
    private var displayedCurrencies: [BWCurrency]!
    
    weak var currencyDelegate: BWCurrencyPickerViewDelegate?
    var displayMode = BWCurrencyPickerViewDisplayMode.LocalizedName {
        didSet {
            self.setUp()
        }
    }
    
    var locale = NSLocale.currentLocale() {
        didSet {
            allCurrencies = getAllCurrencies()
            self.setUp()
        }
    }
    
    var currencySource = BWCurrencyPickerViewCurrencySource.StandardCurrencies {
        didSet {
            self.setUp()
        }
    }
    
    private let standardCurrencyCodes = ["USD", "EUR", "JPY", "GBP", "CHF", "CAD"]
    
    var userDefinedCurrencyCodes: [String]?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
        self.setUp()
    }
    
    private func setUp() {
        if self.currencySource == .AllCurrencies {
            allCurrencies = self.getAllCurrencies()
            displayedCurrencies = self.getSortedCurrencies(self.allCurrencies!)
        } else if self.currencySource == .StandardCurrencies {
            let standardCurrencies = self.getCurrencies(standardCurrencyCodes)
            displayedCurrencies = getSortedCurrencies(standardCurrencies)
        } else if self.currencySource == .UserDefinedCurrencies {
            if (userDefinedCurrencyCodes != nil) { // Check if nil
                let userDefinedOnes = self.getCurrencies(userDefinedCurrencyCodes!)
                displayedCurrencies = getSortedCurrencies(userDefinedOnes)
            } else {
                print("No user defined currencies")
                displayedCurrencies = [BWCurrency]()
            }
        }
        self.reloadAllComponents()
    }
    

    
    private func getCurrencies(codeArray: [String]) -> [BWCurrency] {
        var currencies = [BWCurrency]()
        for var i = 0; i < codeArray.count; ++i {
            let aCode = codeArray[i]
            if let localizedName = self.locale.displayNameForKey(NSLocaleCurrencyCode, value: aCode) {
                let aCurrency = BWCurrency(code: aCode, name: localizedName)
                currencies.append(aCurrency)
            }
        }
        return currencies
    }
    
    private func getAllCurrencies() -> [BWCurrency] {
        var currencies = [BWCurrency]()
        let codes = NSLocale.ISOCurrencyCodes()
        currencies = self.getCurrencies(codes)
        return currencies
    }
    
    private func getCurrency(currencyCode: String) -> BWCurrency? {
        if let localizedName = self.locale.displayNameForKey(NSLocaleCurrencyCode, value: currencyCode) {
            return BWCurrency(code: currencyCode, name: localizedName)
        } else {
            return nil
        }
    }
    
    private func getSortedCurrencies(unsortedCurrencies: [BWCurrency]) -> [BWCurrency] {
        return unsortedCurrencies.sort { $0.localizedCurrencyName.compare($1.localizedCurrencyName) == .OrderedAscending }
    }
    
    // MARK: - UIPickerView DataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return displayedCurrencies.count
    }
    
    // MARK: - UIPickerView Delegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.displayMode == .LocalizedName {
            return displayedCurrencies[row].localizedCurrencyName
        } else {
            return displayedCurrencies[row].currencyCode
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = displayedCurrencies[row]
        self.currencyDelegate?.currencyPickerView(self, didSelectCurrency: selectedCurrency)
    }
    
}

@objc protocol BWCurrencyPickerViewDelegate {
    func currencyPickerView(currencyPickerView: BWCurrencyPickerView, didSelectCurrency currency: BWCurrency);
}

@objc class BWCurrency: NSObject {
    let currencyCode: String
    let localizedCurrencyName: String

    init(code:String, name:String) {
        currencyCode = code
        localizedCurrencyName = name
    }
}

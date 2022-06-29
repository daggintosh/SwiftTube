//
//  abbrv.swift
//  lcj3
//
//  Created by Dagg on 6/28/22.
//

import Foundation

extension String {
    var Abbreviate: String {
        let oginput: String = self
        let input: Double? = Double(oginput)
        if(input != nil) {
            let k: Double = input!/1000
            if(k >= 1.0 && k < 1000) {
                return formatAndReturn(input: k, abbrv: "K")
            }
            let m: Double = input!/1000000
            if(m >= 1.0 && m < 1000) {
                return formatAndReturn(input: m, abbrv: "M")
            }
            let b: Double = input!/1000000000
            if(b >= 1.0 && b < 1000) {
                return formatAndReturn(input: b, abbrv: "B")
            }
            
            return oginput
        }
        else {
            return "NaN"
        }
    }
    var FormatCool: String {
        let input: String = self
        let dblinput: Double? = Double(input)
        if(dblinput != nil) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            let output = formatter.string(from: dblinput! as NSNumber)
            return "\(output!)"
        }
        else
        {
            return "NaN"
        }
        
    }
}

func formatAndReturn(input: Double, abbrv: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 1
    let output = formatter.string(from: input as NSNumber);
    return "\(output!)\(abbrv)"
}

//
//  MyDate.swift
//  SIGHub
//
//  Created by Ilham Shahputra on 07/04/25.
//

import Foundation

class MyDateFormatter {
    static private var df: DateFormatter = DateFormatter()
    static private var isInitialized: Bool = false
    
    static func initializeFormat() {
        df.dateFormat = "dd/MM/yy HH:mm"
        isInitialized = true
    }
    
    static func fromString(_ string: String) -> Date? {
        if !isInitialized {
            initializeFormat()
        }
        
        return df.date(from: string)
    }
    
    static func fromDate(_ date: Date) -> String? {
        if !isInitialized {initializeFormat()}
        
        return date.formatted(date: .abbreviated, time: .shortened) /*date.formatted(dateTime.weekday(.abbreviated))*/
    }
}

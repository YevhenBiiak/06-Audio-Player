//
//  TimeInterval+.swift
//  06 Audio Player
//
//  Created by Евгений Бияк on 08.07.2022.
//

import Foundation

extension TimeInterval {
    func stringRepresentationOfTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="mm:ss"
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}

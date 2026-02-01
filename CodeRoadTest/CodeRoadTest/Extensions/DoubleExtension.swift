//
//  DoubleExtension.swift
//  CodeRoadTest
//
//  Created by Omar Barrera Peña on 31/01/26.
//

extension Double {
    /**
     Convert a number from **degrees** to **radians**
     
     - Returns: The value converted to **Radians**
     */
    func degToRad() -> Double {
        return self * .pi / 180
    }
}

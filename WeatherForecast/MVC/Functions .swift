import Foundation
import UIKit

extension ViewController {
    //MARK: Check for only letters
    private func containsOnlyLettersAndMaxOneSpace(input: String) -> Bool {
       for chr in input {
          if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr == " ")) {
             return false
          }
       }
       return true
    }
    //MARK: Check for empty space, numbers, !letters
    func checkErrors(input: String) -> Bool {
        let numberCharacters = NSCharacterSet.decimalDigits
        var result = false
        if input.isEmpty {
            searchField.text = "   City? ಠ_ಠ"
            result = false
        } else if input.rangeOfCharacter(from: numberCharacters) != nil {
            searchField.text = "   No numbers! ಠ_ಠ"
            result = false
        } else if containsOnlyLettersAndMaxOneSpace(input: input) == false {
            searchField.text = "   Only letters! ಠ_ಠ"
            result = false
        } else {
            result = true
        }
        return result
    }
    //MARK: Set weather status img
    func setWeatherStatusImage(status: String, dayNightCheck: String) -> UIImage {
        var image = UIImage()
        let str = status.lowercased()
        
        if str.contains("snow") {
            image = UIImage(systemName: "cloud.snow.fill")!
            
        } else if str.contains("blizzard") {
            image = UIImage(systemName: "cloud.snow.fill")!
            
        } else if str.contains("rain") {
            image = UIImage(systemName: "cloud.rain.fill")!
            
        } else if str.contains("drizzle") {
            image = UIImage(systemName: "cloud.drizzle.fill")!
            
        } else if dayNightCheck == "yes" && str.contains("clear") || str.contains("sun") {
            image = UIImage(systemName: "sun.max.fill")!
        
        } else if dayNightCheck == "no" && str.contains("clear") || str.contains("night") {
            image = UIImage(systemName: "moon.stars.fill")!
        
        } else if str.contains("overcast") {
            image = UIImage(systemName: "cloud.fill")!
            
        } else if str.contains("cloud") && dayNightCheck == "yes" {
            image = UIImage(systemName: "cloud.sun.fill")!
            
        } else if str.contains("cloud") && dayNightCheck == "no" {
            image = UIImage(systemName: "cloud.moon.fill")!
            
        } else if str.contains("thunder") || str.contains("lightning") {
            image = UIImage(systemName: "cloud.bolt.fill")!
            
        } else if str.contains("hail") {
            image = UIImage(systemName: "cloud.hail.fill")!
            
        } else if str.contains("fog") || str.contains("mist")  {
            image = UIImage(systemName: "smoke.fill")!
        }
        return image
    }
}

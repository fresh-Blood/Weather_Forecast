import Foundation


protocol UserInternetService {
    func getData(city: String, closure: @escaping (CommonInfo) -> Void)
}

final class InternetService: UserInternetService {
    
    func getData(city: String, closure: @escaping (CommonInfo) -> Void) {
        let check = city
        var newStr = ""
        if check.contains(" ") {
            newStr = check.replacingOccurrences(of: " ", with: "%20")
            print("CITY: \(newStr)")
        } else {
            newStr += " "
            newStr = check.replacingOccurrences(of: " ", with: "%20")
            print("CITY: \(newStr)")
        }
        
        if let url = URL(string: "http://api.weatherstack.com/current?access_key=09efbe53acd0809fad59a01760faabba&query=\(newStr)") {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data {
                    do {
                        let parsedJson = try JSONDecoder().decode(CommonInfo.self, from: data)
                        print("SUCCESS: \(parsedJson)")
                        closure(parsedJson)
                    } catch let error {
                        print("ERROR: \(error)")
                    }
                }
            }.resume()
        }
    }
}

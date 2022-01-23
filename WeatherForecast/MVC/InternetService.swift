import Foundation


protocol UserInternetService {
    func getData(city: String, closure: @escaping (CommonInfo) -> Void)
}

final class InternetService: UserInternetService {
    
    func getData(city: String, closure: @escaping (CommonInfo) -> Void) {
        let check = city
        var city = ""
        if check.contains(" ") {
            city = check.replacingOccurrences(of: " ", with: "%20")
            print("CITY: \(city)")
        } else {
            city += " "
            city = check.replacingOccurrences(of: " ", with: "%20")
            print("CITY: \(city)")
        }
        
        if let url = URL(string: "http://api.weatherstack.com/current?access_key=09efbe53acd0809fad59a01760faabba&query=\(city)") {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data {
                    do {
                        let parsedJson = try JSONDecoder().decode(CommonInfo.self, from: data)
                        closure(parsedJson)
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}

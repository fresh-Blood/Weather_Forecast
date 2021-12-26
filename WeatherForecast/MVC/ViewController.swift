import UIKit

protocol UserView {
    var internetService: UserInternetService? { get set }
}

final class ViewController: UIViewController, UserView {
    
    var internetService: UserInternetService?
    
    let searchField: UISearchBar = {
        let search = UISearchBar()
        search.spellCheckingType = .yes
        search.autocorrectionType = .yes
        search.autocapitalizationType = .words
        search.textContentType = .addressCity
        search.smartDashesType = .yes
        search.smartQuotesType = .yes
        search.isUserInteractionEnabled = true
        search.searchBarStyle = .minimal
        search.tintColor = .white
        search.barTintColor = .white
        search.text = "   City? ಠ_ಠ"
        return search
    }()
    
    private let cityLabel: UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 1
        lbl.font = .systemFont(ofSize: 80, weight: .heavy)
        lbl.text = "City"
        lbl.textAlignment = .right
        lbl.textColor = .white
        return lbl
    }()
    
    private let weatherImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "cloud.sun.fill")
        img.contentMode = .scaleAspectFit
        img.tintColor = .white
        return img
    }()
    
    private let temperatureLabel: UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.font = .systemFont(ofSize: 80, weight: .heavy)
        lbl.numberOfLines = 1
        lbl.text = "C°"
        lbl.textColor = .white
        lbl.textAlignment = .right
        return lbl
    }()
    
    private let localTimeAndDate: UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.font = .systemFont(ofSize: 80, weight: .heavy)
        lbl.numberOfLines = 0
        lbl.text = "Local date and time"
        lbl.textColor = .white
        lbl.textAlignment = .right
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        searchField.delegate = self
        view.addSubview(searchField)
        view.addSubview(weatherImage)
        view.addSubview(cityLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(localTimeAndDate)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let inset: CGFloat = 8
        searchField.frame = CGRect(x: view.bounds.minX,
                                   y: view.safeAreaInsets.top,
                                   width: view.bounds.width,
                                   height: inset*7)
        weatherImage.frame = CGRect(x: view.bounds.width/3,
                                    y: searchField.bounds.maxY + inset*3,
                                    width: view.bounds.width/3*2 - inset,
                                    height: view.bounds.height/3)
        cityLabel.frame = CGRect(x: inset,
                                 y: searchField.bounds.maxY + weatherImage.bounds.maxY + inset,
                                 width: view.bounds.width - inset*2,
                                 height: weatherImage.bounds.height/2)
        temperatureLabel.frame = CGRect(x: view.bounds.width/5,
                                        y: searchField.bounds.maxY + weatherImage.bounds.maxY + cityLabel.bounds.maxY,
                                        width: view.bounds.width/5*4 - inset,
                                        height: weatherImage.bounds.height/2)
        localTimeAndDate.frame = CGRect(x: view.bounds.width/2,
                                        y: searchField.bounds.maxY + weatherImage.bounds.maxY + cityLabel.bounds.maxY + temperatureLabel.bounds.maxY,
                                        width: view.bounds.width/2 - inset,
                                        height: temperatureLabel.bounds.height)
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text?.removeAll()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard
            let str = searchBar.text else { return }
        if checkErrors(input: str) {
            internetService?.getData(city: str, closure: { [weak self] model in
                DispatchQueue.main.async {
                    self?.cityLabel.text = model.location?.name
                    self?.temperatureLabel.text = "\(model.current?.temperature ?? 0) C°"
                    self?.localTimeAndDate.text = model.location?.localtime
                    guard
                        let weatherStatus = model.current?.weather_descriptions?[0] else {return}
                    guard
                        let dayNight = model.current?.is_day else {return}
                    dayNight == "yes" ? self?.view.showDayColor() : self?.view.showNightColor()
                    self?.weatherImage.image = self?.setWeatherStatusImage(status: weatherStatus, dayNightCheck: dayNight)
                }
            })
        }
    }
}

extension UIView {
    func showDayColor() {
        UIView.animate(withDuration: 1.5, animations: {
            self.backgroundColor = .systemTeal
        })
    }
    func showNightColor() {
        UIView.animate(withDuration: 1.5, animations: {
            self.backgroundColor = .darkGray
        })
    }
}

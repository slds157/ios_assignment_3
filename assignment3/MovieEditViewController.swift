//
//  MovieEditViewController.swift
//  assignment3
//
//  Created by 康杰 on 18/5/2023.
//

import UIKit

class MovieEditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    @IBAction func confirmButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "sendMovieInfo", sender: self)
    }
    
    var moviePoster: UIImageView!
    var movieTitle: UILabel!
    var movieIntro: UITextView!
    var movieSelection: UIPickerView!
    
    var dates = ["2023-06-14", "2023-06-15", "2023-06-16", "2023-06-17", "2023-06-18"]
    var times = ["10:00 AM", "1:00 PM", "4:00 PM", "7:30 PM", "11:00 PM"]
    
    var userName : String = " "
    var selectedTime : String = " "
    var movieName : String = "Evil Dead Rise"
    
    let evilDead : String = "Evil Dead Rise is a 2023 American supernatural horror film written and directed by Lee Cronin. It is the fifth installment of the Evil Dead film series. The film stars Lily Sullivan and Alyssa Sutherland as two estranged sisters trying to survive and save their family from deadites. Morgan Davies, Gabrielle Echols, and Nell Fisher (in her film debut) appear in supporting roles."
    
    let bookClub : String = "Book Club: The Next Chapter is a 2023 American romantic comedy film written and directed by Bill Holderman. It serves as a sequel to Book Club (2018). The film stars Diane Keaton, Jane Fonda, Candice Bergen and Mary Steenburgen, Craig T. Nelson, Giancarlo Giannini, Andy García, and Don Johnson."
    
    let loveAgain : String = "Love Again is a 2023 American romantic comedy-drama film written and directed by James C. Strouse. It is an English-language remake of the 2016 German film SMS für Dich, itself based on a novel by Sofie Cramer.[6] The film stars Priyanka Chopra Jonas, Sam Heughan, and Celine Dion, in her first feature film, portraying a fictionalized version of herself."
    
    let guardians : String = "Guardians of the Galaxy Vol. 3 (stylized in marketing as Guardians of the Galaxy Volume 3) is a 2023 American superhero film based on the Marvel Comics superhero team Guardians of the Galaxy, produced by Marvel Studios, and distributed by Walt Disney Studios Motion Pictures."
    
    let johnWick : String = "John Wick: Chapter 4 is a 2023 American neo-noir action thriller film directed by Chad Stahelski and written by Shay Hatten and Michael Finch. The sequel to John Wick: Chapter 3 – Parabellum (2019) and the fourth installment in the John Wick franchise, the film stars Keanu Reeves as the title character, alongside Donnie Yen, Bill Skarsgård, Laurence Fishburne, Hiroyuki Sanada, Shamier Anderson, Lance Reddick, Rina Sawayama, Scott Adkins, Clancy Brown, and Ian McShane. In the film, John Wick sets out to get revenge on the High Table and those who left him for dead."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        
        movieTitle.text = movieName
        movieIntro.text = showMovieIntro(movieName: movieName)
        movieSelection.dataSource = self
        movieSelection.delegate = self
        
        selectedTime = "\(dates[0]) - \(times[0])"
    }

    func setUpLayout() {
        let textWidth = self.view.frame.size.width * 0.8
        let imageWidth = self.view.frame.size.width * 0.6
        let imageHeight = self.view.frame.size.height * 0.4
        let scrollViewX = (self.view.frame.size.width - imageWidth) / 2
        let textX: CGFloat = self.view.frame.size.width * 0.1

        let statusBarHeight: CGFloat
        if #available(iOS 13.0, *) {
            statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        let topOffset: CGFloat = (self.navigationController?.navigationBar.frame.size.height ?? 0) + statusBarHeight + 30
        let scrollViewY = topOffset

        moviePoster = UIImageView(frame: CGRect(x: scrollViewX, y: scrollViewY, width: imageWidth, height: imageHeight))
        moviePoster.image = UIImage(named: "image1")
        moviePoster.contentMode = .scaleAspectFit
        self.view.addSubview(moviePoster)

        movieTitle = UILabel(frame: CGRect(x: textX, y: moviePoster.frame.maxY - 40, width: textWidth, height: 40))
        movieTitle.textAlignment = .center
        movieTitle.font = UIFont.boldSystemFont(ofSize: 16)
        self.view.addSubview(movieTitle)
        
        movieIntro = UITextView(frame: CGRect(x: textX, y: movieTitle.frame.maxY, width: textWidth, height: 160))
        movieIntro.font = UIFont.systemFont(ofSize: 14)
        movieIntro.isEditable = false
        self.view.addSubview(movieIntro)
        
        let selectTimeLabel = UILabel(frame: CGRect(x: textX, y: movieIntro.frame.maxY + 20, width: textWidth, height: 20))
        selectTimeLabel.textAlignment = .center
        selectTimeLabel.text = "Please select a time:"
        selectTimeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.view.addSubview(selectTimeLabel)
        
        movieSelection = UIPickerView(frame: CGRect(x: textX, y: selectTimeLabel.frame.maxY, width: textWidth, height: 100))
        self.view.addSubview(movieSelection)
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 14)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = component == 0 ? dates[row] : times[row]

        return pickerLabel!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return dates.count
        }
        else {
            return times.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return dates[row]
        }
        else {
            return times[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTime = "\(dates[pickerView.selectedRow(inComponent: 0)]) - \(times[pickerView.selectedRow(inComponent: 1)])"
        print(selectedTime)
    }
    
    func showMovieIntro(movieName : String) -> String{
        switch movieName{
        case "Evil Dead Rise":
            let imageValue = UIImage(named: "image1")
            moviePoster.image = imageValue
            return evilDead
        case "Book Club: The Next Chapter":
            let imageValue = UIImage(named: "image2")
            moviePoster.image = imageValue
            return bookClub
        case "Love Again":
            let imageValue = UIImage(named: "image3")
            moviePoster.image = imageValue
            return loveAgain
        case "Guardians of the Galaxy - Vol 3":
            let imageValue = UIImage(named: "image4")
            moviePoster.image = imageValue
            return guardians
        case "John Wick: Chapter 4":
            let imageValue = UIImage(named: "image5")
            moviePoster.image = imageValue
            return johnWick
            
        default:
            return "0"
        }
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "sendMovieInfo"{
            let destinationView = segue.destination as! SeatSelectionViewController
          destinationView.userName = userName
          destinationView.movie = movieName
          destinationView.showTime = selectedTime
          print(selectedTime)
        }
   }
}

//
//  MovieEditViewController.swift
//  assignment3
//
//  Created by 康杰 on 18/5/2023.
//

import UIKit

class MovieEditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    

    @IBOutlet weak var moviePoster: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var movieIntro: UITextView!
    
    @IBOutlet weak var movieSelection: UIPickerView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    let dates = ["2023-05-14", "2023-05-15", "2023-05-16"]
        var times = ["10:00 AM", "2:00 PM", "6:00 PM"]
    
    
    
    var movieName : String = "Evil Dead Rise"
    
    let evilDead : String = "Evil Dead Rise is a 2023 American supernatural horror film written and directed by Lee Cronin. It is the fifth installment of the Evil Dead film series. The film stars Lily Sullivan and Alyssa Sutherland as two estranged sisters trying to survive and save their family from deadites. Morgan Davies, Gabrielle Echols, and Nell Fisher (in her film debut) appear in supporting roles."
    
    let bookClub : String = "Book Club: The Next Chapter is a 2023 American romantic comedy film written and directed by Bill Holderman. It serves as a sequel to Book Club (2018). The film stars Diane Keaton, Jane Fonda, Candice Bergen and Mary Steenburgen, Craig T. Nelson, Giancarlo Giannini, Andy García, and Don Johnson."
    
    let loveAgain : String = "Love Again is a 2023 American romantic comedy-drama film written and directed by James C. Strouse. It is an English-language remake of the 2016 German film SMS für Dich, itself based on a novel by Sofie Cramer.[6] The film stars Priyanka Chopra Jonas, Sam Heughan, and Celine Dion, in her first feature film, portraying a fictionalized version of herself."
    
    let guardians : String = "Guardians of the Galaxy Vol. 3 (stylized in marketing as Guardians of the Galaxy Volume 3) is a 2023 American superhero film based on the Marvel Comics superhero team Guardians of the Galaxy, produced by Marvel Studios, and distributed by Walt Disney Studios Motion Pictures."
    
    let johnWick : String = "John Wick: Chapter 4 is a 2023 American neo-noir action thriller film directed by Chad Stahelski and written by Shay Hatten and Michael Finch. The sequel to John Wick: Chapter 3 – Parabellum (2019) and the fourth installment in the John Wick franchise, the film stars Keanu Reeves as the title character, alongside Donnie Yen, Bill Skarsgård, Laurence Fishburne, Hiroyuki Sanada, Shamier Anderson, Lance Reddick, Rina Sawayama, Scott Adkins, Clancy Brown, and Ian McShane. In the film, John Wick sets out to get revenge on the High Table and those who left him for dead."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitle.text = movieName
        movieIntro.text = showMovieIntro(movieName: movieName)
        movieSelection.dataSource = self
        movieSelection.delegate = self
        // Do any additional setup after loading the view.
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
    
    func showMovieIntro(movieName : String) -> String{
        switch movieName{
        case "Evil Dead Rise":
            let imageValue = UIImage(named: "image1")
            return evilDead
        case "Book Club: The Next Chapter":
            let imageValue = UIImage(named: "image2")
            return bookClub
        case "Love Again":
            let imageValue = UIImage(named: "image3")
            return loveAgain
        case "Guardians of the Galaxy - Vol 3":
            let imageValue = UIImage(named: "image4")
            return guardians
        case "John Wick: Chapter 4":
            let imageValue = UIImage(named: "image5")
            return johnWick
            
        default:
            return "0"
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

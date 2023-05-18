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
    
    var movieName : String = "Thor"
    var thor : String = "Thor: Love and Thunder is a 2022 American superhero film based on Marvel Comics featuring the character Thor. Produced by Marvel Studios and distributed by Walt Disney Studios Motion Pictures, it is the sequel to Thor: Ragnarok (2017) and the 29th film in the Marvel Cinematic Universe (MCU). The film was directed by Taika Waititi, who co-wrote the screenplay with Jennifer Kaytin Robinson, and stars Chris Hemsworth as Thor alongside Christian Bale, Tessa Thompson, Jaimie Alexander, Waititi, Russell Crowe, and Natalie Portman. In the film, Thor attempts to find inner peace, but must return to action and recruit Valkyrie (Thompson), Korg (Waititi), and Jane Foster (Portman)—who is now the Mighty Thor—to stop Gorr the God Butcher (Bale) from eliminating all gods."
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
        case "Thor":
            return thor
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

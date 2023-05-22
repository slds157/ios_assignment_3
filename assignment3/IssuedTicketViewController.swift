//
//  IssuedTicketViewController.swift
//  assignment3
//
//  Created by Zheng Yuan on 2023-05-20.
//

import UIKit

class IssuedTicketViewController: UIViewController {
    
    var Ticket_Key: String = ""
    var issuedSeats: [Seat] = []
    var selectedSeats: [Seat] = []
    var userName: String = ""
    var movie: String = ""
    var showTime: String = ""
    var UserName_Ticket_Key: String = ""
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var ticketDetailsTextView: UITextView!
    @IBOutlet weak var Confirm: UIButton!
    @IBOutlet weak var Cancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserName_Ticket_Key = "\(userName)\(movie)|\(showTime)"
        loadSeatsFromUserDefaults()
        displayTicketInfo()
        displayMoviePoster()
    }
    
    func loadSeatsFromUserDefaults() {
        let defaults = UserDefaults.standard
        if let savedSeatsData = defaults.object(forKey: Ticket_Key) as? Data {
            let decoder = PropertyListDecoder()
            if let loadedSeats = try? decoder.decode([Seat].self, from: savedSeatsData) {
                issuedSeats = loadedSeats
            }
        }
        let keyComponents = Ticket_Key.split(separator: "|")
        if keyComponents.count >= 2 {
            movie = String(keyComponents[0])
            showTime = String(keyComponents[1])
        }
    }
    
    func displayTicketInfo() {
        var detailsText = "Thank you \(userName), \n\nYour order is: \n\nMovie: \(movie)\n\nTime: \(showTime)\n\n"
        for seat in issuedSeats {
            detailsText += "Seat: Row: \(seat.row + 1), Column: \(seat.column + 1)\n\n"
        }

        detailsText += "\nYou can confirm or cancel this order by tapping the buttons below"
        ticketDetailsTextView.text = detailsText
    }
    
    func displayMoviePoster() {
        switch movie {
        case "Evil Dead Rise":
            moviePoster.image = UIImage(named: "image1")
        case "Book Club: The Next Chapter":
            moviePoster.image = UIImage(named: "image2")
        case "Love Again":
            moviePoster.image = UIImage(named: "image3")
        case "Guardians of the Galaxy - Vol 3":
            moviePoster.image = UIImage(named: "image4")
        case "John Wick: Chapter 4":
            moviePoster.image = UIImage(named: "image5")
        default:
            print("No matching movie poster found")
        }
    }
    
    func writeToHistory(){
        let defaults = UserDefaults.standard
        let encoder = PropertyListEncoder()
        if let savedData = try? encoder.encode(selectedSeats) {
            defaults.set(savedData, forKey: UserName_Ticket_Key)
        }
    }

    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: "BookingDate_\(Ticket_Key)")
        let alert = UIAlertController(title: "Confirmed", message: "Your order has been confirmed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        writeToHistory()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
        let defaults = UserDefaults.standard
        //defaults.removeObject(forKey: Ticket_Key)
        defaults.removeObject(forKey: "BookingDate_\(Ticket_Key)")
        issuedSeats = issuedSeats.filter { issuedSeat in
            !selectedSeats.contains { selectedSeat in
                selectedSeat.row == issuedSeat.row && selectedSeat.column == issuedSeat.column
            }
        }
        let encoder = PropertyListEncoder()
        if let updatedData = try? encoder.encode(issuedSeats) {
            defaults.set(updatedData, forKey: Ticket_Key)
        }
        let alert = UIAlertController(title: "Cancelled", message: "Your order has been cancelled.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()

    }
    
}

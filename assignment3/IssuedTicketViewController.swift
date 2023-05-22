//
//  IssuedTicketViewController.swift
//  assignment3
//
//  Created by Zheng Yuan on 2023-05-20.
//

import UIKit

class IssuedTicketViewController: UIViewController {
    
    // Properties to hold information related to the booked ticket
    var Ticket_Key: String = ""
    var issuedSeats: [Seat] = []
    var selectedSeats: [Seat] = []
    var userName: String = ""
    var movie: String = ""
    var showTime: String = ""
    
    // Outlets for UI elements on the screen
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var ticketDetailsTextView: UITextView!
    @IBOutlet weak var Confirm: UIButton!
    @IBOutlet weak var Cancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSeatsFromUserDefaults()
        displayTicketInfo()
        displayMoviePoster()
    }
    
    // Load saved seat information from User Defaults
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
    
    // Display ticket information in a text view
    func displayTicketInfo() {
        var detailsText = "Thank you \(userName), \n\nYour order is: \n\nMovie: \(movie)\n\nTime: \(showTime)\n\n"
        for seat in selectedSeats {
            detailsText += "Seat: Row: \(seat.row + 1), Column: \(seat.column + 1)\n\n"
        }
        
        let totalPrice = selectedSeats.count * 20
        detailsText += "Total price: $\(totalPrice)\n\nYou can confirm or cancel this order by tapping the buttons below"
        ticketDetailsTextView.text = detailsText
    }
    
    // Display corresponding movie poster based on selected movie
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
    
    // Actions for confirm and cancel buttons
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        presentAlert(title: "Confirmed", message: "Your order has been confirmed.")
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        cancelTicketBooking()
        presentAlert(title: "Cancelled", message: "Your order has been cancelled.")
    }
    
    // Present alert dialog with given title and message
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Cancel ticket booking and update User Defaults
    func cancelTicketBooking() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "BookingDate_\(userName)|\(Ticket_Key)")
        issuedSeats = issuedSeats.filter { issuedSeat in
            !selectedSeats.contains { selectedSeat in
                selectedSeat.row == issuedSeat.row && selectedSeat.column == issuedSeat.column
            }
        }
        let encoder = PropertyListEncoder()
        if let updatedData = try? encoder.encode(issuedSeats) {
            defaults.set(updatedData, forKey: Ticket_Key)
        }
    }
    
}

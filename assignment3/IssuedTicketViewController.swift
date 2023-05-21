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
    var userName: String = ""
    var movie: String = ""
    var showTime: String = ""
    
    @IBOutlet weak var ticketDetailsTextView: UITextView!
    @IBOutlet weak var Confirm: UIButton!
    @IBOutlet weak var Cancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSeatsFromUserDefaults()
        displayTicketInfo()
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
        if keyComponents.count >= 3 {
            userName = String(keyComponents[0])
            movie = String(keyComponents[1])
            showTime = String(keyComponents[2])
        }
    }
    
    func displayTicketInfo() {
        var detailsText = "Thank you \(userName), Your order is: \nMovie: \(movie)\nTime: \(showTime)\n"
        var seatDict: [Int: [Int]] = [:]
        for seat in issuedSeats {
            if seatDict[seat.row] == nil {
                seatDict[seat.row] = [seat.column]
            } else {
                seatDict[seat.row]?.append(seat.column)
            }
        }
        let sortedSeatDict = seatDict.sorted(by: { $0.key < $1.key })
        for (key, value) in sortedSeatDict {
            let sortedColumns = value.sorted()
            detailsText += "Seat: Row: \(key + 1), Column: \(sortedColumns.map({ String($0 + 1) }).joined(separator: ", "))\n"
        }
        let defaults = UserDefaults.standard
        if let bookingDateTime = defaults.object(forKey: "BookingDate_\(Ticket_Key)") as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            detailsText += "Order time: \(dateFormatter.string(from: bookingDateTime))"
        }
        ticketDetailsTextView.text = detailsText
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: "BookingDate_\(Ticket_Key)")
        let alert = UIAlertController(title: "Confirmed", message: "Your order has been confirmed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Ticket_Key)
        defaults.removeObject(forKey: "BookingDate_\(Ticket_Key)")
        let alert = UIAlertController(title: "Cancelled", message: "Your order has been cancelled.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

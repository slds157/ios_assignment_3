//
//  BookingHistoryViewController.swift
//  assignment3
//
//  Created by Zheng Yuan on 2023-05-20.
//

import UIKit

// Struct to represent a booking
struct Booking: Codable {
    let userName: String
    let movie: String
    let orderTime: Date
}

// Class to represent booking history view controller
class BookingHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlet for the table view on the screen
    @IBOutlet weak var tableView: UITableView!

    // Property to hold list of bookings
    var bookings: [Booking] = []

    // Function called when the view has loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load bookings from user defaults and set table view delegate and data source
        loadBookingsFromUserDefaults()
        tableView.delegate = self
        tableView.dataSource = self
    }

    // Load bookings from user defaults
    func loadBookingsFromUserDefaults() {
        let defaults = UserDefaults.standard
        let bookingKeys = defaults.dictionaryRepresentation().keys.filter { $0.hasPrefix("BookingDate_") }
        for key in bookingKeys {
            if let bookingDateTime = defaults.object(forKey: key) as? Date {
                let ticketKey = String(key.dropFirst("BookingDate_".count))
                let keyComponents = ticketKey.split(separator: "|")
                if keyComponents.count >= 2 {
                    let userName = String(keyComponents[0])
                    let movie = String(keyComponents[1])
                    let booking = Booking(userName: userName, movie: movie, orderTime: bookingDateTime)
                    bookings.append(booking)
                }
            }
        }
        // Sort bookings by order time
        bookings.sort { $0.orderTime > $1.orderTime }
    }

    // MARK: - Table view data source

    // Returns the number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Returns the number of rows in a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }

    // Provides a cell for a particular row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath)
        let booking = bookings[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.textLabel?.text = "\(indexPath.row + 1). \(booking.movie)"
        cell.detailTextLabel?.text = "\(booking.userName) - \(dateFormatter.string(from: booking.orderTime))"

        return cell
    }

}

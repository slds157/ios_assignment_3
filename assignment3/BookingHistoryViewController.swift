//
//  BookingHistoryViewController.swift
//  assignment3
//
//  Created by Zheng Yuan on 2023-05-20.
//

import UIKit

struct Booking: Codable {
    let userName: String
    let movie: String
    let orderTime: Date
}

class BookingHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var bookings: [Booking] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBookingsFromUserDefaults()

        // The view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
    }

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
        bookings.sort { $0.orderTime > $1.orderTime }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath)

        // Configure the cell...
        let booking = bookings[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.textLabel?.text = "\(indexPath.row + 1). \(booking.movie)"
        cell.detailTextLabel?.text = "\(booking.userName) - \(dateFormatter.string(from: booking.orderTime))"

        return cell
    }

}

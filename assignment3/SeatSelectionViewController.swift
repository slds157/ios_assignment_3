//
//  SeatSelectionViewController.swift
//  assignment3
//
//  Created by Tony on 20/5/2023.
//

import UIKit


class SeatSelectionViewController: UIViewController {
    
    var seats: [[Seat]] = Array(repeating: Array(repeating: Seat(row: 0, column: 0, status: .available), count: 6), count: 10)
    var seatButtons: [[SeatButton]] = []
    let seatButtonSize: CGSize = CGSize(width: 40, height: 40)
    let seatButtonSpacing: CGFloat = 10
    var movie: String = " "
    var showTime: String = " "
    var userName: String = " "
    
    var Ticket_Key: String = " "
    var selectedSeats: [Seat] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Ticket_Key = "\(userName)|\(movie)|\(showTime)"
        loadSeatsFromUserDefaults()
        setupSeatButtons()
    }
    
    func initializeSeats() {
        for row in 0..<seats.count {
            for column in 0..<seats[row].count {
                seats[row][column] = Seat(row: row, column: column, status: .available)
            }
        }
    }
    func loadSeatsFromUserDefaults() {
        let defaults = UserDefaults.standard

        // Try to get the data from UserDefaults
        if let savedSeatsData = defaults.object(forKey: Ticket_Key) as? Data {
            let decoder = PropertyListDecoder()
            if let loadedSeats = try? decoder.decode([Seat].self, from: savedSeatsData) {
                // Reset all the seats to be available first
                initializeSeats()

                // If we successfully got the data, loop over it
                for loadedSeat in loadedSeats {
                    // Make sure the seat position exists in the seats array
                    if loadedSeat.row < seats.count && loadedSeat.column < seats[loadedSeat.row].count {
                        // Assign the loaded seat to the correct position in the seats array
                        seats[loadedSeat.row][loadedSeat.column] = loadedSeat
                    }
                }
                return
            }
        }

        // If we get here, there was no data in UserDefaults or it couldn't be decoded
        // So we initialize all seats as available
        initializeSeats()
    }
    
    func setupSeatButtons() {
        let numberOfRows = seats.count
        let numberOfColumns = seats.first?.count ?? 0
        let totalWidth = CGFloat(numberOfColumns) * (seatButtonSize.width + seatButtonSpacing) - seatButtonSpacing
        let totalHeight = CGFloat(numberOfRows) * (seatButtonSize.height + seatButtonSpacing) - seatButtonSpacing
        let startX = (view.bounds.width - totalWidth) / 2
        let startY = (view.bounds.height - totalHeight) / 2
        
        for row in 0..<numberOfRows {
            var buttonRow: [SeatButton] = []
            for column in 0..<numberOfColumns {
                let seatButton = SeatButton(type: .custom)
                seatButton.configure(seat: seats[row][column])
                
                seatButton.addTarget(self, action: #selector(seatButtonTapped(_:)), for: .touchUpInside)
                
                let x = startX + CGFloat(column) * (seatButtonSize.width + seatButtonSpacing)
                let y = startY + CGFloat(row) * (seatButtonSize.height + seatButtonSpacing)
                seatButton.frame = CGRect(x: x, y: y, width: seatButtonSize.width, height: seatButtonSize.height)
                view.addSubview(seatButton)
                buttonRow.append(seatButton)
            }
            seatButtons.append(buttonRow)
        }
    }
    
    @objc func seatButtonTapped(_ sender: SeatButton) {
        if sender.seat.status == .available {
            sender.seat.status = .occupied
            selectedSeats.append(sender.seat)
        } else if sender.seat.status == .occupied {
            sender.seat.status = .available
            if let index = selectedSeats.firstIndex(where: { $0.row == sender.seat.row && $0.column == sender.seat.column }) {
                selectedSeats.remove(at: index)
            }
        }
        sender.updateAppearance()
        }
    
    func saveSeatsToUserDefaults() {
        // Change the status of all selected seats to 'unavailable'
        for seat in selectedSeats {
            seats[seat.row][seat.column].status = .unavailable
        }

        let defaults = UserDefaults.standard
        let encoder = PropertyListEncoder()

        if let savedData = try? encoder.encode(seats.flatMap({$0}).filter({$0.status == .unavailable})) {
            defaults.set(savedData, forKey: Ticket_Key)
        }
    }
    
    @IBAction func confirmBarButtonTapped(_ sender: UIBarButtonItem) {
        saveSeatsToUserDefaults()
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: "BookingDate_\(Ticket_Key)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTicket"{
            let ticketVC = segue.destination as! IssuedTicketViewController
            ticketVC.Ticket_Key = Ticket_Key
            ticketVC.issuedSeats = selectedSeats // pass the selected seats information
        }
    }

    
}


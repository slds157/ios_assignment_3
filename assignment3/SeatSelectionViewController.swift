//
//  SeatSelectionViewController.swift
//  assignment3
//
//  Created by Tony on 20/5/2023.
//

import UIKit

class SeatSelectionViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var confirmButton: UIButton!
    
    // Class properties
    var seats: [[Seat]] = Array(repeating: Array(repeating: Seat(row: 0, column: 0, status: .available), count: 6), count: 10)
    var seatButtons: [[SeatButton]] = []
    var screenWidth: CGFloat = UIScreen.main.bounds.size.width
    var seatButtonWidth: CGFloat = 40
    var seatButtonSize: CGSize = CGSize(width: 40, height: 40)
    var seatButtonSpacing: CGFloat = 10
    var movie: String = " "
    var showTime: String = " "
    var userName: String = " "
    var Ticket_Key: String = " "
    var selectedSeats: [Seat] = []
    var seatSelectionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adjust button width based on screen width
        seatButtonWidth = screenWidth/10
        seatButtonSize = CGSize(width: seatButtonWidth, height: seatButtonWidth)
        seatButtonSpacing = seatButtonWidth/4
        Ticket_Key = "\(movie)|\(showTime)"
        
        loadSeatsFromUserDefaults()
        setupSeatSelectionLabel()
        setupSeatButtons()
    }
    
    // Initialise the seat availability status
    func initialiseSeats() {
        for row in 0..<seats.count {
            for column in 0..<seats[row].count {
                seats[row][column] = Seat(row: row, column: column, status: .available)
            }
        }
    }
    
    // Load the seat status from user defaults
    func loadSeatsFromUserDefaults() {
        let defaults = UserDefaults.standard

        if let savedSeatsData = defaults.object(forKey: Ticket_Key) as? Data {
            let decoder = PropertyListDecoder()
            if let loadedSeats = try? decoder.decode([Seat].self, from: savedSeatsData) {
                initialiseSeats()
                for loadedSeat in loadedSeats {
                    if loadedSeat.row < seats.count && loadedSeat.column < seats[loadedSeat.row].count {
                        seats[loadedSeat.row][loadedSeat.column] = loadedSeat
                    }
                }
                return
            }
        }
        initialiseSeats()
    }
    
    // Setup the label for seat selection
    func setupSeatSelectionLabel() {
        seatSelectionLabel = UILabel(frame: CGRect(x: 20, y: 120, width: view.frame.width - 40, height: 50))
        seatSelectionLabel.text = "Please select your seat:"
        seatSelectionLabel.font = UIFont.systemFont(ofSize: 20)
        seatSelectionLabel.textAlignment = .center
        view.addSubview(seatSelectionLabel)
    }
    
    // Setup buttons for seat selection
    func setupSeatButtons() {
        // calculate the layout details
        let numberOfRows = seats.count
        let numberOfColumns = seats.first?.count ?? 0
        let totalWidth = CGFloat(numberOfColumns) * (seatButtonSize.width + seatButtonSpacing) - seatButtonSpacing
        let totalHeight = CGFloat(numberOfRows) * (seatButtonSize.height + seatButtonSpacing) - seatButtonSpacing
        let startX = (view.bounds.width - totalWidth) / 2
        let startY = (view.bounds.height - totalHeight) / 2
        let labelSize: CGSize = CGSize(width: seatButtonSize.width, height: seatButtonSize.height)
        
        // Add buttons for seats
        for row in 0..<numberOfRows {
            var buttonRow: [SeatButton] = []
            addRowLabel(row: row, startX: startX, startY: startY, labelSize: labelSize)
            buttonRow = addButtonsForRow(row: row, startX: startX, startY: startY, numberOfColumns: numberOfColumns)
            seatButtons.append(buttonRow)
        }
    }
    
    // Add label for rows
    func addRowLabel(row: Int, startX: CGFloat, startY: CGFloat, labelSize: CGSize) {
        let rowLabel = UILabel()
        rowLabel.text = "\(row + 1)"
        rowLabel.textAlignment = .center
        rowLabel.frame = CGRect(x: startX - labelSize.width, y: startY + CGFloat(row) * (seatButtonSize.height + seatButtonSpacing), width: labelSize.width, height: labelSize.height)
        view.addSubview(rowLabel)
    }
    
    // Add buttons for a row
    func addButtonsForRow(row: Int, startX: CGFloat, startY: CGFloat, numberOfColumns: Int) -> [SeatButton] {
        var buttonRow: [SeatButton] = []
        for column in 0..<numberOfColumns {
            let seatButton = createButton(row: row, column: column, startX: startX, startY: startY)
            buttonRow.append(seatButton)
        }
        return buttonRow
    }
    
    // Create a button for seat
    func createButton(row: Int, column: Int, startX: CGFloat, startY: CGFloat) -> SeatButton {
        let seatButton = SeatButton(type: .custom)
        seatButton.configure(seat: seats[row][column])
        seatButton.addTarget(self, action: #selector(seatButtonTapped(_:)), for: .touchUpInside)
        let x = startX + CGFloat(column) * (seatButtonSize.width + seatButtonSpacing)
        let y = startY + CGFloat(row) * (seatButtonSize.height + seatButtonSpacing)
        seatButton.frame = CGRect(x: x, y: y, width: seatButtonSize.width, height: seatButtonSize.height)
        view.addSubview(seatButton)
        return seatButton
    }
    
    // Update the status of a seat when tapped
    @objc func seatButtonTapped(_ sender: SeatButton) {
        updateSeatStatus(sender: sender)
        sender.updateAppearance()
    }
    
    // Update seat status
    func updateSeatStatus(sender: SeatButton) {
        if sender.seat.status == .available {
            sender.seat.status = .occupied
            selectedSeats.append(sender.seat)
        } else if sender.seat.status == .occupied {
            sender.seat.status = .available
            removeSeatFromSelection(sender: sender)
        }
    }
    
    // Remove a seat from selection
    func removeSeatFromSelection(sender: SeatButton) {
        if let index = selectedSeats.firstIndex(where: { $0.row == sender.seat.row && $0.column == sender.seat.column }) {
            selectedSeats.remove(at: index)
        }
    }
    
    // Save selected seats to user defaults
    func saveSeatsToUserDefaults() {
        updateSeatAvailability()
        saveUnavailableSeats()
    }
    
    // Update seat availability
    func updateSeatAvailability() {
        for seat in selectedSeats {
            seats[seat.row][seat.column].status = .unavailable
        }
    }
    
    // Save unavailable seats
    func saveUnavailableSeats() {
        let defaults = UserDefaults.standard
        let encoder = PropertyListEncoder()
        if let savedData = try? encoder.encode(seats.flatMap({$0}).filter({$0.status == .unavailable})) {
            defaults.set(savedData, forKey: Ticket_Key)
        }
    }
    
    // Action for the confirm button
    @IBAction func confirmButtonTapped(_ sender: Any) {
        if selectedSeats.isEmpty {
            displayNoSeatSelectedAlert()
        } else {
            saveSeatsToUserDefaults()
            saveBookingDate()
        }
    }
    
    // Display an alert when no seat is selected
    func displayNoSeatSelectedAlert() {
        let alertController = UIAlertController(title: "No seat selected", message: "Please select at least one seat.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Save the booking date to user defaults
    func saveBookingDate() {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: "BookingDate_\(userName)|\(Ticket_Key)")
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTicket" {
            prepareForTicketSegue(segue: segue)
        }
    }
    
    // Prepare for the segue to the IssuedTicketViewController
    func prepareForTicketSegue(segue: UIStoryboardSegue) {
        let ticketVC = segue.destination as! IssuedTicketViewController
        ticketVC.Ticket_Key = Ticket_Key
        ticketVC.userName = userName
        ticketVC.selectedSeats = selectedSeats
    }
    
}

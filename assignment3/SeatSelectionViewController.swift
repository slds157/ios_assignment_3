//
//  SeatSelectionViewController.swift
//  assignment3
//
//  Created by Tony on 20/5/2023.
//

import UIKit


class SeatSelectionViewController: UIViewController {
    
    
    
    @IBOutlet weak var confirm: UIBarButtonItem!
    @IBAction func confirmBarButtonTapped(_ sender: UIBarButtonItem) {
        if selectedSeats.isEmpty {
            let alertController = UIAlertController(title: "No seat selected", message: "Please select at least one seat.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            saveSeatsToUserDefaults()
            let defaults = UserDefaults.standard
            defaults.set(Date(), forKey: "BookingDate_\(Ticket_Key)")
        }
    }
    
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

        seatButtonWidth = screenWidth/10
        seatButtonSize = CGSize(width: seatButtonWidth, height: seatButtonWidth)
        seatButtonSpacing = seatButtonWidth/4
        Ticket_Key = "\(userName)|\(movie)|\(showTime)"
        loadSeatsFromUserDefaults()
        setupSeatSelectionLabel()
        setupSeatButtons()
    }
    
    func setupSeatSelectionLabel() {
        seatSelectionLabel = UILabel(frame: CGRect(x: 20, y: 120, width: view.frame.width - 40, height: 50))
        seatSelectionLabel.text = "Please select your seat:"
        seatSelectionLabel.font = UIFont.systemFont(ofSize: 20)
        seatSelectionLabel.textAlignment = .center
        view.addSubview(seatSelectionLabel)
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

        if let savedSeatsData = defaults.object(forKey: Ticket_Key) as? Data {
            let decoder = PropertyListDecoder()
            if let loadedSeats = try? decoder.decode([Seat].self, from: savedSeatsData) {
                initializeSeats()

                for loadedSeat in loadedSeats {
                    if loadedSeat.row < seats.count && loadedSeat.column < seats[loadedSeat.row].count {
                        seats[loadedSeat.row][loadedSeat.column] = loadedSeat
                    }
                }
                return
            }
        }

        initializeSeats()
    }
    
    func setupSeatButtons() {
        let numberOfRows = seats.count
        let numberOfColumns = seats.first?.count ?? 0
        let totalWidth = CGFloat(numberOfColumns) * (seatButtonSize.width + seatButtonSpacing) - seatButtonSpacing
        let totalHeight = CGFloat(numberOfRows) * (seatButtonSize.height + seatButtonSpacing) - seatButtonSpacing
        let startX = (view.bounds.width - totalWidth) / 2
        let startY = (view.bounds.height - totalHeight) / 2

        let labelSize: CGSize = CGSize(width: seatButtonSize.width, height: seatButtonSize.height)
        
        for row in 0..<numberOfRows {
            var buttonRow: [SeatButton] = []
            
            let rowLabel = UILabel()
            rowLabel.text = "\(row + 1)"
            rowLabel.textAlignment = .center
            rowLabel.frame = CGRect(x: startX - labelSize.width, y: startY + CGFloat(row) * (seatButtonSize.height + seatButtonSpacing), width: labelSize.width, height: labelSize.height)
            view.addSubview(rowLabel)

            for column in 0..<numberOfColumns {
                let seatButton = SeatButton(type: .custom)
                seatButton.configure(seat: seats[row][column])
                
                seatButton.addTarget(self, action: #selector(seatButtonTapped(_:)), for: .touchUpInside)
                
                let x = startX + CGFloat(column) * (seatButtonSize.width + seatButtonSpacing)
                let y = startY + CGFloat(row) * (seatButtonSize.height + seatButtonSpacing)
                seatButton.frame = CGRect(x: x, y: y, width: seatButtonSize.width, height: seatButtonSize.height)
                view.addSubview(seatButton)
                buttonRow.append(seatButton)
                
                if row == 0 {
                    let columnLabel = UILabel()
                    columnLabel.text = "\(column + 1)"
                    columnLabel.textAlignment = .center
                    columnLabel.frame = CGRect(x: x, y: startY + totalHeight + seatButtonSpacing, width: labelSize.width, height: labelSize.height)
                    view.addSubview(columnLabel)
                }
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
        for seat in selectedSeats {
            seats[seat.row][seat.column].status = .unavailable
        }

        let defaults = UserDefaults.standard
        let encoder = PropertyListEncoder()

        if let savedData = try? encoder.encode(seats.flatMap({$0}).filter({$0.status == .unavailable})) {
            defaults.set(savedData, forKey: Ticket_Key)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToTicket" {
            if selectedSeats.isEmpty {
                let alertController = UIAlertController(title: "No seat selected", message: "Please select at least one seat.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTicket"{
            let ticketVC = segue.destination as! IssuedTicketViewController
            ticketVC.Ticket_Key = Ticket_Key
            ticketVC.issuedSeats = selectedSeats
        }
    }

}


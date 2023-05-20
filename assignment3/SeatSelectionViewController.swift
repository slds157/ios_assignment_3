//
//  SeatSelectionViewController.swift
//  assignment3
//
//  Created by Tony on 20/5/2023.
//

import UIKit

import UIKit


class SeatSelectionViewController: UIViewController {
    
    private var seats: [[Seat]] = Array(repeating: Array(repeating: Seat(row: 0, column: 0, status: .available), count: 6), count: 10)
    private var seatButtons: [[SeatButton]] = []
    private let seatButtonSize: CGSize = CGSize(width: 40, height: 40)
    private let seatButtonSpacing: CGFloat = 10
    private var movie: String = "Movie1"
    private var showTime: String = "Show1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSeatsFromUserDefaults()
        setupSeatButtons()
    }
    
    private func initializeSeats() {
        for row in 0..<seats.count {
            for column in 0..<seats[row].count {
                seats[row][column] = Seat(row: row, column: column, status: .available)
            }
        }
    }
    private func loadSeatsFromUserDefaults() {
        let defaults = UserDefaults.standard

        if let savedSeats = defaults.object(forKey: "\(movie)\(showTime)Seats") as? Data {
            let decoder = PropertyListDecoder()
            if let loadedSeats = try? decoder.decode([[Seat]].self, from: savedSeats) {
                seats = loadedSeats
                return
            }
        }
        initializeSeats()
    }
    
    private func setupSeatButtons() {
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
    
    @objc private func seatButtonTapped(_ sender: SeatButton) {
            if sender.seat.status == .available {
                sender.seat.status = .occupied
            } else if sender.seat.status == .occupied {
                sender.seat.status = .available
            }
            sender.updateAppearance()
        }
    
    private func saveSeatsToUserDefaults() {
        let defaults = UserDefaults.standard
        let encoder = PropertyListEncoder()

        if let savedData = try? encoder.encode(seats) {
            defaults.set(savedData, forKey: "\(movie)\(showTime)Seats")
        }
    }
}


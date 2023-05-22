//
//  SeatButton.swift
//  assignment3
//
//  Created by Tony on 20/5/2023.
//

import UIKit

// Custom UIButton to represent a seat in the cinema
class SeatButton: UIButton {
    
    // Property to hold the seat data
    var seat: Seat!
    
    // Function to configure the seat button with seat data
    func configure(seat: Seat) {
        self.seat = seat
        updateAppearance()
    }
    
    // Function to update the appearance of the button based on the seat status
    func updateAppearance() {
        switch seat.status {
        case .available:
            backgroundColor = .green
        case .occupied:
            backgroundColor = .red
        case .unavailable:
            backgroundColor = .gray
        }
    }

}

// Struct to represent a seat
struct Seat: Codable {
    
    // Properties to hold the seat location and status
    let row: Int
    let column: Int
    var status: SeatStatus

}

// Enum to represent the possible statuses of a seat
enum SeatStatus: Int, Codable {
    case available
    case occupied
    case unavailable
}

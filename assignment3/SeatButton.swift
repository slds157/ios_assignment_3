//
//  SeatButton.swift
//  assignment3
//
//  Created by Tony on 20/5/2023.
//

import UIKit

class SeatButton: UIButton {

    var seat: Seat!
    
    func configure(seat: Seat){
        self.seat = seat
        updateAppearance()
    }
    
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

struct Seat: Codable {
    let row: Int
    let column: Int
    var status: SeatStatus
}

enum SeatStatus: Int, Codable {
    case available
    case occupied
    case unavailable
}


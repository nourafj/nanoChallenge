//
//  puzzleHint.swift
//  puzzle
//
//  Created by noura on 21/06/1444 AH.
//
import SwiftUI

struct PuzzleGame: View {
    @State private var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @State private var emptySpace = 8
    @State private var showHint = false
    let image: Image


    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "pilestone")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(showHint ? Color.yellow : Color.gray)
                    .onTapGesture {
                        self.showHint.toggle()
                    }
            }
            image
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            ForEach(0..<3, id: \.self) { row in
                HStack {
                    ForEach(0..<3, id: \.self) { col in
                        if self.numbers[row * 3 + col] == 9 {
                            Text("")
                                .frame(width: 50, height: 50)
                                .border(Color.black)
                        } else {
                            Text("\(self.numbers[row * 3 + col])")
                                .frame(width: 50, height: 50)
                                .border(Color.black)
                                .background(self.showHint && self.canMove(at: (row, col)) ? Color.yellow : Color.white)
                                .onTapGesture {
                                    self.moveTile(at: (row, col))
                                }
                        }
                    }
                }
            }
        }
    }

    func moveTile(at position: (row: Int, col: Int)) {
        let index = position.row * 3 + position.col
        if (index == emptySpace - 1 && position.col == 2) ||
            (index == emptySpace + 1 && position.col == 0) ||
            (index == emptySpace - 3 && position.row == 2) ||
            (index == emptySpace + 3 && position.row == 0) {
            numbers.swapAt(index, emptySpace)
            emptySpace = index
        }
    }
    
    func canMove(at position: (row: Int, col: Int)) -> Bool {
        let index = position.row * 3 + position.col
        return (index == emptySpace - 1 && position.col == 2) ||
            (index == emptySpace + 1 && position.col == 0) ||
            (index == emptySpace - 3 && position.row == 2) ||
            (index == emptySpace + 3 && position.row == 0)
    }
    
}

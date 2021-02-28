//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Brandon Knox on 2/24/21.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
//    Go back to project 2 and create a FlagImage() view that renders one flag image using the specific set of modifiers we had.
    struct FlagImage: View {
        var country: String
        
        init(country: String) {
            // may not need anything here
            self.country = country
        }
        
        var body: some View {
            Image(self.country)
                .renderingMode(.original)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color .black, lineWidth: 1))
                .shadow(color: .black, radius: 2)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]),
                            startPoint: .top,
                            endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color .black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                    }
                }
                VStack {
                    Text("Current Score: \(userScore)")
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle),
                      message: Text("Your score is \(userScore)"),
                      dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong!  That's the flag of \(countries[number])"
            userScore -= 1
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

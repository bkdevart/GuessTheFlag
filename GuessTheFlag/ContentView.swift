//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Brandon Knox on 2/24/21.
//

import SwiftUI

struct fadeOutModifier: ViewModifier {
    let amount: Double

    func body(content: Content) -> some View {
        content.opacity(amount)
    }
}

extension AnyTransition {
    static var fadeOut: AnyTransition {
        .modifier(
            active: fadeOutModifier(amount: 0.25),
            identity: fadeOutModifier(amount: 1.00)
        )
    }
}


struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    @State private var animationAmount = 0.0
    @State private var flagOpacity = 1.0

    struct FlagImage: View {
        var country: String
        
        init(country: String) {
            self.country = country
        }
        
        var body: some View {
            Image(self.country)
                .renderingMode(.original)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color .black, lineWidth: 1))
                .shadow(color: .black, radius: 2)
                .transition(.fadeOut)
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
                        FlagImage(country: self.countries[number])
                    }
                    .rotation3DEffect(.degrees((number == correctAnswer) ? animationAmount : 0.0),
                                      axis: (x: 0, y: 1, z: 0))
                    .opacity((number != correctAnswer) ? flagOpacity : 1.0)
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
            withAnimation {
                self.animationAmount += 360
                self.flagOpacity = 0.25
            }
        } else {
            scoreTitle = "Wrong!  That's the flag of \(countries[number])"
            userScore -= 1
            self.flagOpacity = 0.25
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        flagOpacity = 1.0
    }
    
    func isFaded() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

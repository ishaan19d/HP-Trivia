//
//  Instructions.swift
//  HP Trivia
//
//  Created by Ishaan Das on 22/06/24.
//

import SwiftUI

struct Instructions: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack{
            ParchmentBackground()
            
            VStack{
                Image(.appiconwithradius)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top)
                
                ScrollView{
                    Text("How To Play")
                        .font(.largeTitle)
                        .padding()
                    
                    VStack(alignment: .leading){
                        Text("Welcome to HP Trivia! In this game, you will be asked random questions from the HP books and you must guess the right answer or you will lose points!")
                            .padding(.bottom)
                        
                        Text("Each question is worth 5 points, but if you guess a wrong answer, you lose 1 point.")
                            .padding(.bottom)
                        
                        Text("If you are strugling with a question, there is an option to reveal a hint or reveal the book that answers the question. But beware! Using these also minuses 1 point each.")
                            .padding(.bottom)
                        
                        Text("When you select the correct answer, you will be awarded all the points left for that question and they will be added to your total score.")
                    }
                    .padding(.horizontal)
                    .font(.title3)

                    
                    Text("Good Luck!")
                        .font(.title)
                }
                .foregroundStyle(.black)
                
                Button("Done"){
                    dismiss()
                }
                .doneButton()
            }
        }
    }
}

#Preview {
    Instructions()
}

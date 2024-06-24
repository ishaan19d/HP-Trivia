//
//  Gameplay.swift
//  HP Trivia
//
//  Created by Ishaan Das on 22/06/24.
//

import SwiftUI
import AVKit

struct Gameplay: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var game: GameViewModel
    @Namespace private var namespace
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    @State private var animateViewsIn = false
    @State private var tappedCorrectAns = false
    @State private var wrongAnswersTapped: [Int] = []
    @State private var hintWiggle = false
    @State private var scaleNextButton = false
    @State private var movePointsToScore = false
    @State private var revealHint = false
    @State private var revealBook = false
    
    private func playMusic() {
        let songs = ["let-the-mystery-unfold", "spellcraft", "hiding-place-in-the-forest", "deep-in-the-dell"]
        let sound = Bundle.main.path(forResource: songs.randomElement()!, ofType: "mp3")
        musicPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        musicPlayer.volume = 0.1
        musicPlayer.numberOfLoops = -1
        musicPlayer.play()
    }
    
    private func playFlipSound(){
        let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.volume = 0.75
        sfxPlayer.play()
    }
    
    private func playWrongSound(){
        let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.volume = 0.75
        sfxPlayer.play()
    }
    
    private func playCorrectSound(){
        let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.volume = 0.75
        sfxPlayer.play()
    }
    
    private func giveWrongHapticFeedback() {
        let hapticGenerator = UINotificationFeedbackGenerator()
        hapticGenerator.notificationOccurred(.error)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height * 1.05)
                    .overlay{
                        Rectangle().foregroundStyle(.black.opacity(0.8))
                    }
                
                VStack{
                    // MARK: Controls
                    HStack{
                        Button("End Game"){
                            game.endGame()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.5))
                        
                        Spacer()
                        
                        Text("Score: \(game.gameScore)")
                    }
                    .padding()
                    .padding(.vertical, 30)
                    
                    // MARK: Question
                    VStack{
                        if animateViewsIn {
                            Text(game.currentQuestion.question)
                                .font(.custom(Constants.hpFont, size: 50))
                                .multilineTextAlignment(.center)
                                .padding()
                                .transition(.scale)
                                .opacity(tappedCorrectAns ? 0.1 : 1)
                        }
                    }
                    .animation(.easeInOut(duration: animateViewsIn ? 2 : 0), value: animateViewsIn)
                    
                    Spacer()
                    
                    // MARK: Hints
                    HStack{
                        VStack{
                            if animateViewsIn {
                                Image(systemName: "questionmark.app.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundStyle(.cyan)
                                    .rotationEffect(.degrees(hintWiggle ? -13 : -17))
                                    .padding()
                                    .padding(.leading, 10)
                                    .transition(.offset(x: -geo.size.width/2))
                                    .onAppear{
                                        withAnimation(.easeInOut(duration: 0.1).repeatCount(9).delay(5).repeatForever()) {
                                            hintWiggle = true
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 1)){
                                            revealHint = true
                                        }
                                        playFlipSound()
                                        game.questionScore -= 1
                                    }
                                    .rotation3DEffect(.degrees(revealHint ? 1440 : 0),axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealHint ? 5 : 1)
                                    .opacity(revealHint ? 0 : 1)
                                    .offset(x: revealHint ? geo.size.width/2 : 0)
                                    .overlay(
                                        Text(game.currentQuestion.hint)
                                            .padding(.leading, 33)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.center)
                                            .opacity(revealHint ? 1 : 0)
                                            .scaleEffect(revealHint ? 1.33 : 1)
                                    )
                                    .opacity(tappedCorrectAns ? 0.1 : 1)
                                    .disabled(tappedCorrectAns)
                            }
                        }
                        .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
                        
                        Spacer()
                        
                        VStack{
                            if animateViewsIn {
                                Image(systemName: "book.closed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .foregroundStyle(.black)
                                    .frame(width: 100, height: 100)
                                    .background(.cyan)
                                    .clipShape(.rect(cornerRadius: 20))
                                    .rotationEffect(.degrees(hintWiggle ? 13 : 17))
                                    .padding()
                                    .padding(.trailing, 10)
                                    .transition(.offset(x: geo.size.width/2))
                                    .onAppear{
                                        withAnimation(.easeInOut(duration: 0.1).repeatCount(9).delay(5).repeatForever()) {
                                            hintWiggle = true
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 1)){
                                            revealBook = true
                                        }
                                        playFlipSound()
                                        game.questionScore -= 1
                                    }
                                    .rotation3DEffect(.degrees(revealBook ? 1440 : 0),axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealBook ? 5 : 1)
                                    .opacity(revealBook ? 0 : 1)
                                    .offset(x: revealBook ? -geo.size.width/2 : 0)
                                    .overlay(
                                        Image("hp\(game.currentQuestion.book)")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(.trailing, 33)
                                            .opacity(revealBook ? 1 : 0)
                                            .scaleEffect(revealBook ? 1.33 : 1)
                                    )
                                    .opacity(tappedCorrectAns ? 0.1 : 1)
                                    .disabled(tappedCorrectAns)
                            }
                        }
                        .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
                    }
                    .padding(.bottom)
                    
                    // MARK: Answers
                    LazyVGrid(columns: [GridItem(), GridItem()]){
                        ForEach(Array(game.answers.enumerated()), id: \.offset) { i,answer in
                            if game.currentQuestion.answers[answer] == true {
                                VStack{
                                    if animateViewsIn {
                                        if tappedCorrectAns == false {
                                            Text(answer)
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                                .padding(10)
                                                .frame(width: geo.size.width/2.15, height: 80)
                                                .background(.green.opacity(0.5))
                                                .clipShape(.rect(cornerRadius: 20))
                                                .transition(.asymmetric(insertion: .scale, removal: .scale(scale: 2).combined(with: .opacity.animation(.easeOut(duration: 0.1)))))
                                                .matchedGeometryEffect(id: "answer", in: namespace)
                                                .onTapGesture {
                                                    withAnimation(.easeOut(duration: 1)){
                                                        tappedCorrectAns = true
                                                    }
                                                    playCorrectSound()
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now()+3.5){
                                                        game.correct()
                                                    }
                                                }
                                        }
                                    }
                                }
                                .animation(.easeOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                            }
                            else{
                                VStack{
                                    if animateViewsIn {
                                        Text(answer)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.center)
                                            .padding(10)
                                            .frame(width: geo.size.width/2.15, height: 80)
                                            .background(wrongAnswersTapped.contains(i) ? .red.opacity(0.5) : .green.opacity(0.5))
                                            .clipShape(.rect(cornerRadius: 20))
                                            .transition(.scale)
                                            .onTapGesture {
                                                withAnimation(.easeOut(duration: 1)) {
                                                    wrongAnswersTapped.append(i)
                                                }
                                                playWrongSound()
                                                giveWrongHapticFeedback()
                                                game.questionScore -= 1
                                            }
                                            .scaleEffect(wrongAnswersTapped.contains(i) ? 0.75 : 1)
                                            .disabled(tappedCorrectAns || wrongAnswersTapped.contains(i))
                                            .opacity(tappedCorrectAns ? 0.1 : 1)
                                    }
                                }
                                .animation(.easeOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .foregroundStyle(.white)
                
                // MARK: Celebration
                VStack{
                    Spacer()
                    
                    VStack{
                        if tappedCorrectAns {
                            Text("\(game.questionScore)")
                                .font(.largeTitle)
                                .padding(.top, 50)
                                .transition(.offset(y: -geo.size.height/4))
                                .offset(x: movePointsToScore ? geo.size.width/2.3 : 0, y: movePointsToScore ? -geo.size.height/13 : 0)
                                .opacity(movePointsToScore ? 0 : 1)
                                .onAppear{
                                    withAnimation(.easeInOut(duration: 1).delay(3)){
                                        movePointsToScore = true
                                    }
                                }
                        }
                    }
                    .animation(.easeInOut(duration: 1).delay(2), value: tappedCorrectAns)
                    
                    Spacer()
                    
                    VStack{
                        if tappedCorrectAns {
                            Text("Brilliant!")
                                .font(.custom(Constants.hpFont, size: 100))
                                .transition(.scale.combined(with: .offset(y: -geo.size.height/2)))
                        }
                    }
                    .animation(.easeInOut(duration: animateViewsIn ? 1 : 0.25).delay(animateViewsIn ? 1 : 0), value: tappedCorrectAns)
                    
                    Spacer()
                    
                    if tappedCorrectAns {
                        Text(game.correctAnswer)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: geo.size.width/2.15, height: 80)
                            .background(.green.opacity(0.6))
                            .clipShape(.rect(cornerRadius: 20))
                            .scaleEffect(2)
                            .matchedGeometryEffect(id: "answer", in: namespace)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    VStack{
                        if tappedCorrectAns {
                            Button("Next Level >"){
                                animateViewsIn = false
                                tappedCorrectAns = false
                                revealHint = false
                                revealBook = false
                                movePointsToScore = false
                                wrongAnswersTapped = []
                                game.newQuestion()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                    animateViewsIn = true
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue.opacity(0.5))
                            .font(.largeTitle)
                            .transition(.offset(y: geo.size.height/3))
                            .scaleEffect(scaleNextButton ? 1.15 : 1)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                                    scaleNextButton.toggle()
                                }
                            }
                        }
                    }
                    .animation(.easeInOut(duration: animateViewsIn ? 2.7 : 0.5).delay(animateViewsIn ? 2.7 : 0.25), value: tappedCorrectAns)
                    
                    Spacer()
                    Spacer()
                }
                .foregroundStyle(.white)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            animateViewsIn = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                playMusic()
            }
        }
    }
}

#Preview {
    Gameplay()
        .environmentObject(GameViewModel())
}

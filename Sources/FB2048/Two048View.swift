//
//  Two048View.swift
//  FabetApp
//
//  Created by Justin on 2/8/25.
//

import SwiftUI

struct Two048View: View {
    private enum DetailView: String {
        case settings
    }
    
    @ObservedObject private var manager = LanguageManager.shared
//    @ObservedObject private var appSw17ch3r = AppSw17ch3r.shared
    @ObservedObject var viewModel = Two048ViewModel()
    @State private var path: [UUID] = []
    @State private var selectedView: DetailView?
    
    @State private var showingGameOver = false
    @State private var showingWinAlert = false
    @Binding var isActive: Bool
    
    var body: some View {
        NavigationStack {
            mainView
        }
        .ignoresSafeArea()
        
    }
    
    private var mainView: some View {
        VStack {
            if isActive {
                Spacer()
            }
            Text("2048")
                .font(.sairaSemiCondensed(46))
                .foregroundColor(.white)
                .padding(.top)

            Text("main.guide".localized())
                .font(.sairaSemiCondensed(14))
                .foregroundColor(.white)
                .padding(.bottom)

            if isActive {
                Spacer(minLength: 20)
                Button {
                    viewModel.resetGame()
                } label: {
                    Text("main.restart".localized())
                        .font(.sairaSemiCondensed(32))
                        .foregroundColor(.orange)
                }
                VStack {
                    VStack {
                        
                        Text("\("main.score".localized()): \(viewModel.score)")
                            .font(.sairaSemiCondensed(40))
                            .foregroundColor(.white)
                        Text("\("main.highscore".localized()): \(viewModel.highScore)")
                            .font(.sairaSemiCondensed(28))
                            .foregroundColor(.white)
                    }
                    .padding()

                    VStack(spacing: 5) {
                        ForEach(0..<viewModel.gridSize, id: \.self) { row in
                            HStack(spacing: 5) {
                                ForEach(0..<viewModel.gridSize, id: \.self) { column in
                                    let number = viewModel.grid[row][column]
                                    MainCell(number: number)
                                        .animation(.easeInOut, value: viewModel.grid[row][column])
                                        .gesture(
                                            TapGesture(count: 10)
                                                .onEnded {
                                                    performTapAction(number: number)
                                                }
                                        )
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.1))
                    )
                    .shadow(radius: 8)
                }
                .padding()

                Spacer()
                Spacer()
            }
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    let horizontalAmount = gesture.translation.width as CGFloat
                    let verticalAmount = gesture.translation.height as CGFloat
                    let direction: Two048Direction
                    if abs(horizontalAmount) > abs(verticalAmount) {
                        direction = horizontalAmount > 0 ? .right : .left
                    } else {
                        direction = verticalAmount > 0 ? .down : .up
                    }
                    viewModel.onSwipe(direction)
                    
                    if viewModel.isLose {
                        NNSoundService.shared.playSound(.lose)
                        showingGameOver = true
                    }
                    if viewModel.grid.contains(where: { $0.contains(2048) }) {
                        NNSoundService.shared.playSound(.win)
                        showingWinAlert = true
                    }
                }
        )
        .alert(isPresented: $showingGameOver) {
            Alert(
                title: Text("Oh, tiếc quá! Bạn đã thua"),
                message: Text("Điểm của bạn là: \(viewModel.score)"),
                dismissButton: .default(Text("Thử lại nhé")) {
                    restartGame()
                }
            )
        }
        .alert("Chúc mừng!", isPresented: $showingWinAlert) {
               Button("Tiếp tục", role: .cancel) { showingWinAlert = false }
       } message: {
           Text("Bạn đã đạt được 2048!")
       }
       .ignoresSafeArea()
       .frame(maxWidth: .infinity, maxHeight: .infinity)
       .background {
           LinearGradient(
               gradient: Gradient(colors: [Color(hex: "#04614C"), Color(hex: "#012D25")]),
               startPoint: .top,
               endPoint: .bottom
           )
           .ignoresSafeArea()
       }
       .toolbar {
           if isActive {
               NavigationLink {
                   Two048SettingView()
               } label: {
                   Image("gear")
               }
           }
       }
    }
    
    private func restartGame() {
        viewModel.grid = Array(repeating: Array(repeating: 0, count: viewModel.gridSize), count: viewModel.gridSize)
        viewModel.score = 0
        viewModel.addNewNumber()
        viewModel.addNewNumber()
        showingGameOver = false
    }

    private func performTapAction(number: Int) {
//        appSw17ch3r.setState(is2048: false)
    }
}

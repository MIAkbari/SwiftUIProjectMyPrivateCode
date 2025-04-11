//
//  ContentView.swift
//  SwiftUIProjectMyPrivateCode
//
//  Created by Mohammad on 4/11/25.
//

import SwiftUI

struct PercentageEnviremnetKey: EnvironmentKey {
    static var defaultValue: CGFloat = 0.0
}

extension EnvironmentValues {
    var progress: CGFloat {
        get { self[PercentageEnviremnetKey.self] }
        set { self[PercentageEnviremnetKey.self] = newValue }
    }
}

struct ProgressButtonStyle: ButtonStyle {
    
    @Environment(\.progress) var fillPercentage
    let color: [Color] = [.teal, .orange, .red, .green]
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.teal.opacity(0.3))
                    
                RoundedRectangle(cornerRadius: 4)
                    .fill(color.randomElement()!)
                    .frame(width: geo.size.width * fillPercentage)
            }
            .animation(.easeInOut(duration: 7), value: fillPercentage)
        }
        .overlay {
            configuration.label
                .font(.body.weight(.heavy))
                .foregroundStyle(.white)
        }
    }
}

extension View {
    func progress(_ percentage: CGFloat) -> some View {
        environment(\.progress, percentage)

    }
}

struct ContentView: View {
    
    @State var progress: CGFloat = 0.0
    @State var textState: String = "Start Donwload"
    
    var body: some View {
        VStack {
            Text("Button Downloader wit Animations")
                .padding(.bottom, 30)
                .transition(.slide)
            
            Button(textState) {
                progress = 1.0
                textState = "Donloading..."
            }
            .buttonStyle(ProgressButtonStyle())
            .frame(height: 40)
            .padding(.horizontal, 20)
            .progress(progress)
            .onChange(of: progress) { _, _ in
                Task {
                    try? await Task.sleep(for: .seconds(7))
                    
                    await MainActor.run {
                        textState = "Finished"
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

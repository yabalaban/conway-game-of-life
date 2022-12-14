//
//  ContentView.swift
//  Shared
//
//  Created by Alexander Balaban on 13/10/2022.
//

import SwiftUI

enum ContentViewStyle {
    static let formWidth: CGFloat = 200
}

struct ContentView: View {
    @State var gridWidth: Int = 128
    @State var gridHeight: Int = 128
    @State var fps: Int = 12
    @State var isPaused: Bool = true
    @State var pattern: String = "Pixel"
    var tickCallbackHolder = TickCallbackHolder()
    var modelsStorage = PatternModelsStorage.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    MetalView(config: Config(gridSize: (gridWidth, gridHeight),
                                             fps: fps,
                                             isPaused: isPaused),
                              selectedPattern: pattern,
                              tickCallbackHolder: tickCallbackHolder)
                        .border(Color.black, width: MetalViewStyle.borderWidth)
                        .frame(width: MetalViewStyle.frameSize,
                               height: MetalViewStyle.frameSize)
                }
                VStack {
                    Form {
                        Section(header: Text("Grid Size")) {
                            TextField("Width", value: $gridWidth, formatter: NumberFormatter())
                            TextField("Height", value: $gridHeight, formatter: NumberFormatter())
                        }
                        Divider()
                        Section(header: Text("Rendering")) {
                            TextField("FPS", value: $fps, formatter: NumberFormatter())
                            Text(isPaused ? "Paused" : "Running")
                                .foregroundColor(isPaused
                                                 ? Color.orange
                                                 : Color.green)
                            HStack {
                                Button(isPaused
                                       ? "\(Image(systemName: "play")) Run"
                                       : "\(Image(systemName: "pause")) Pause") {
                                    isPaused.toggle()
                                }
                                Button("\(Image(systemName: "goforward")) Tick") {
                                    tickCallbackHolder.callback()
                                }.disabled(!isPaused)
                            }
                        }
                        Divider()
                        Section(header: Text("Edit")) {
                            Picker("Brush", selection: $pattern) {
                                ForEach(modelsStorage.keys,
                                        id: \.self) { patternKey in
                                    Text(patternKey).tag(patternKey)
                                }
                            }
                            .pickerStyle(.inline)
                        }.disabled(!isPaused)
                    }.frame(width: ContentViewStyle.formWidth)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

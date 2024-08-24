//
//  ContentView.swift
//  KMPObservableViewModelSample
//
//  Created by Rick Clephas on 21/11/2022.
//

import SwiftUI
import KMPObservableViewModelSwiftUI


struct ContentView: View {
    @StateViewModel var viewModel = TimeTravelViewModel()
    
    @State private var input: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack{
            Spacer()
            Group {
                Button(action: {
                    dismiss()
                }) {
                    Text("Dismiss")
                }
                ShortMessagesRow()
                if useTextInput {
                    TextField("type_something", text: $input)
                }
            }
            Spacer()
        }
        .onAppear {
            print("TimeTravelViewModel", "onAppear")
        }
        .onDisappear {
            print("TimeTravelViewModel", "onDisappear")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ShortMessagesRow: View {
    var content: some View {
        HStack(spacing: 8) {
            ForEach(
                ["1", "2", "3"],
                id:\.self
            ) { message in
                Text(message)
            }
        }.padding(.horizontal, 8)
    }
    var body: some View {
        if useScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                content
            }
        } else {
            content
        }
    }
}


//
//  KMPObservableViewModelSampleApp.swift
//  KMPObservableViewModelSample
//
//  Created by Rick Clephas on 21/11/2022.
//

import SwiftUI

let useNavigationStack = true
let setDeeplinkHandler = true
let useScrollView = false
let useTextInput = false

class DeeplinkHandler: ObservableObject {
    @Published var chatId: String? = nil
}

@main
struct KMPObservableViewModelSampleApp: App {
    
    @State private var shouldPresentContent: Bool = false
    @StateObject var deeplinkHandler = DeeplinkHandler()
    
    var body: some Scene {
        WindowGroup {
            NavigationStackCompat {
                Button {
                    shouldPresentContent = true
                } label: {
                    Text("Next Screen")
                }
                .navigationDestinationCompat(isPresented: $shouldPresentContent) {
                    ChatList()
                }
            }
            .environmentObject(deeplinkHandler)
        }
    }
}

struct ChatList: View {
    @EnvironmentObject var deeplinkHandler: DeeplinkHandler
    @State private var shouldPresentChat: Bool = false
    @State private var selectedChat: String? = nil {
        didSet {
            shouldPresentChat = selectedChat != nil
        }
    }
        
    var body: some View {
        VStack {
            Text("Chat List")
            ForEach(["chat1", "chat2", "chat3"], id: \.self) { chat in
                Button {
                    selectedChat = chat
                } label: {
                    Text(chat)
                }
            }
        }
        .onAppear {
            if setDeeplinkHandler {
                selectedChat = deeplinkHandler.chatId
            }
        }
        .navigationDestinationCompat(isPresented: $shouldPresentChat) {
            if let chat = selectedChat {
                ContentView()
            }
        }
    }
}

struct NavigationStackCompat<Content>: View where Content: View {
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        if useNavigationStack {
            NavigationStack(root: content)
        } else {
            NavigationView(content: content)
                .navigationViewStyle(.stack)
        }
    }
}

fileprivate struct NavigationDestinationModifier<Destination: View>: ViewModifier {
    let useNavigationStack: Bool
    let isPresented: Binding<Bool>
    let destination: Destination

    func body(content: Content) -> some View {
        if useNavigationStack {
            content.navigationDestination(isPresented: isPresented) {
                destination
            }
        } else {
            content.background(
                NavigationLink(destination: destination, isActive: isPresented) {
                    EmptyView()
                }
            )
        }
    }
}

extension View {
    func navigationDestinationCompat<Destination: View>(isPresented: Binding<Bool>, @ViewBuilder destination: () -> Destination) -> some View {
        modifier(NavigationDestinationModifier(useNavigationStack: useNavigationStack, isPresented: isPresented, destination: destination()))
    }
}

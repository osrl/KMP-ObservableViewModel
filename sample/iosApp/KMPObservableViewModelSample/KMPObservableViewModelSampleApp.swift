//
//  KMPObservableViewModelSampleApp.swift
//  KMPObservableViewModelSample
//
//  Created by Rick Clephas on 21/11/2022.
//

import SwiftUI

let useNavigationStack = false
let useScrollView = true
let useTextInput = true

@main
struct KMPObservableViewModelSampleApp: App {
    
    @State private var shouldPresentContent: Bool = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStackCompat(useNavigationStack: useNavigationStack) {
                Button {
                    shouldPresentContent = true
                } label: {
                    Text("Next Screen")
                }
                .navigationDestinationCompat(useNavigationStack: useNavigationStack, isPresented: $shouldPresentContent) {
                    ContentView()
                }
            }
        }
    }
}

struct NavigationStackCompat<Content>: View where Content: View {
    
    let useNavigationStack: Bool
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
    func navigationDestinationCompat<Destination: View>(useNavigationStack: Bool, isPresented: Binding<Bool>, @ViewBuilder destination: () -> Destination) -> some View {
        modifier(NavigationDestinationModifier(useNavigationStack: useNavigationStack, isPresented: isPresented, destination: destination()))
    }
}

//
//  HashApp.swift
//  Hash
//
//  Created by i on 2025/6/5.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

@main
struct HashApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
            CommandGroup(replacing: .appInfo) {
                Button("About Hash") {
                    showAboutWindow()
                }
            }
        }
    }
    
    private func showAboutWindow() {
        let aboutWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        aboutWindow.title = "About Hash"
        aboutWindow.center()
        aboutWindow.isReleasedWhenClosed = false
        
        let aboutView = AboutView()
        aboutWindow.contentView = NSHostingView(rootView: aboutView)
        aboutWindow.makeKeyAndOrderFront(nil)
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            // App Icon
            Image(systemName: "number.square")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            // App Name and Version
            VStack(spacing: 8) {
                Text("Hash")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Version 1.0.0")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Description
            Text("A concise and efficient macOS hash calculation tool")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Divider()
            
            // Author and Project Info
            VStack(spacing: 12) {
                HStack {
                    Text("Author:")
                        .fontWeight(.medium)
                    Spacer()
                    Text("Jia Xianhua")
                }
                
                HStack {
                    Text("Project:")
                        .fontWeight(.medium)
                    Spacer()
                    Link("GitHub Repository", destination: URL(string: "https://github.com/iOSDevLog/Hash")!)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Copyright
            Text("© 2025 Hash Project Contributors")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 400, height: 300)
    }
}

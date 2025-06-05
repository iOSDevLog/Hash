//
//  ContentView.swift
//  Hash
//
//  Created by i on 2025/6/5.
//

import SwiftUI
import CryptoKit
import Foundation
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var selectedFiles: [URL] = []
    @State private var fileResults: [URL: [String: String]] = [:]
    @State private var isCalculating = false
    @State private var progress: Double = 0.0
    @State private var totalProgress: Double = 0.0
    @State private var selectedFileIndex: Int? = nil
    
    // Hash algorithm selections
    @State private var enableMD5 = true
    @State private var enableSHA1 = true
    @State private var enableCRC32 = true
    @State private var enableVersion = true
    @State private var enableDate = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Top section - Hash results display
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if !fileResults.isEmpty {
                            ForEach(Array(selectedFiles.enumerated()), id: \.element) { index, file in
                                if let results = fileResults[file] {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(NSLocalizedString("file_label", comment: "File label")): \(file.path)")
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.medium)
                        
                        if let size = results["Size"] {
                            Text("\(NSLocalizedString("size_label", comment: "Size label")): \(size)")
                                .font(.system(.caption, design: .monospaced))
                        }
                        
                        // Display results in the same order as right panel
                        if enableVersion, let version = results["Version"] {
                            Text("\(NSLocalizedString("version_label", comment: "Version label")): \(version)")
                                .font(.system(.caption, design: .monospaced))
                        }
                        
                        if enableDate, let date = results["Date"] {
                            Text("\(NSLocalizedString("modified_label", comment: "Modified label")): \(date)")
                                .font(.system(.caption, design: .monospaced))
                        }
                        
                        if enableMD5, let md5 = results["MD5"] {
                            Text("\(NSLocalizedString("md5_label", comment: "MD5 label")): \(md5)")
                                .font(.system(.caption, design: .monospaced))
                        }
                        
                        if enableSHA1, let sha1 = results["SHA1"] {
                            Text("\(NSLocalizedString("sha1_label", comment: "SHA1 label")): \(sha1)")
                                .font(.system(.caption, design: .monospaced))
                        }
                        
                        if enableCRC32, let crc32 = results["CRC32"] {
                            Text("\(NSLocalizedString("crc32_label", comment: "CRC32 label")): \(crc32)")
                                .font(.system(.caption, design: .monospaced))
                        }
                                    }
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(selectedFileIndex == index ? Color.blue.opacity(0.1) : Color.clear)
                                    .textSelection(.enabled)
                                    .id("file_\(index)")
                                    
                                    if index < selectedFiles.count - 1 {
                                        Divider()
                                            .padding(.vertical, 4)
                                    }
                                }
                            }
                        } else {
                            Text(NSLocalizedString("select_files_prompt", comment: "Prompt to select files"))
                                .foregroundColor(.secondary)
                                .font(.caption)
                                .padding()
                        }
                    }
                }
                .onChange(of: selectedFileIndex) { newIndex in
                    if let index = newIndex {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo("file_\(index)", anchor: .top)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
            .padding()
            .background(Color(NSColor.textBackgroundColor))
            .border(Color.gray.opacity(0.3))
            
            Spacer()
            
            // Main content area
            HStack(spacing: 0) {
                // Left side - File list and controls
                VStack(spacing: 12) {
                    // File list area
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 4) {
                            if selectedFiles.isEmpty {
                                Text(NSLocalizedString("drag_files_prompt", comment: "Drag files prompt"))
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, minHeight: 100)
                            } else {
                                ForEach(Array(selectedFiles.enumerated()), id: \.element) { index, file in
                                    HStack {
                                        Image(systemName: "doc")
                                            .foregroundColor(.blue)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(file.lastPathComponent)
                                                .font(.caption)
                                                .lineLimit(1)
                                            Text(formatFileSize(file))
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(selectedFileIndex == index ? Color.blue.opacity(0.2) : Color.clear)
                                    .cornerRadius(4)
                                    .onTapGesture {
                                        selectedFileIndex = index
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 150)
                    .background(Color(NSColor.controlBackgroundColor))
                    .border(Color.gray.opacity(0.3))
                    .onDrop(of: [UTType.fileURL], isTargeted: nil) { providers in
                        handleDrop(providers: providers)
                        return true
                    }
                    
                    // Control buttons
                    HStack(spacing: 8) {
                        Button(NSLocalizedString("browse_button", comment: "Browse button")) {
                            browseFiles()
                        }
                        .buttonStyle(.bordered)
                        
                        Button(NSLocalizedString("clear_button", comment: "Clear button")) {
                            clearFiles()
                        }
                        .buttonStyle(.bordered)
                        
                        Button(NSLocalizedString("copy_button", comment: "Copy button")) {
                            copyResults()
                        }
                        .buttonStyle(.bordered)
                        .disabled(fileResults.isEmpty)
                        
                        Button(NSLocalizedString("save_button", comment: "Save button")) {
                            saveResults()
                        }
                        .buttonStyle(.bordered)
                        .disabled(fileResults.isEmpty)
                        
                        Button(isCalculating ? NSLocalizedString("stop_button", comment: "Stop button") : NSLocalizedString("calculate_button", comment: "Calculate button")) {
                            if isCalculating {
                                stopCalculation()
                            } else {
                                startCalculation()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(selectedFiles.isEmpty)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Right side - Hash algorithm options
                VStack(alignment: .leading, spacing: 8) {
                    Toggle(NSLocalizedString("version_label", comment: "Version toggle"), isOn: $enableVersion)
                    Toggle(NSLocalizedString("date_label", comment: "Date toggle"), isOn: $enableDate)
                    Toggle(NSLocalizedString("md5_label", comment: "MD5 toggle"), isOn: $enableMD5)
                    Toggle(NSLocalizedString("sha1_label", comment: "SHA1 toggle"), isOn: $enableSHA1)
                    Toggle(NSLocalizedString("crc32_label", comment: "CRC32 toggle"), isOn: $enableCRC32)
                }
                .frame(width: 100)
                .padding(.leading, 16)
            }
            .padding()
            
            // Bottom section - Progress bars
            VStack(spacing: 4) {
                HStack {
                    Text(NSLocalizedString("file_progress", comment: "File progress label"))
                        .font(.caption)
                        .frame(width: 40, alignment: .leading)
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle())
                }
                
                HStack {
                    Text(NSLocalizedString("total_progress", comment: "Total progress label"))
                        .font(.caption)
                        .frame(width: 40, alignment: .leading)
                    ProgressView(value: totalProgress)
                        .progressViewStyle(LinearProgressViewStyle())
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
        }
        .frame(minWidth: 500, minHeight: 400)
    }
    
    // MARK: - Helper Functions
    
    private func browseFiles() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        
        if panel.runModal() == .OK {
            selectedFiles.append(contentsOf: panel.urls)
            selectedFileIndex = nil
            // Auto start calculation for new files
            startCalculation()
        }
    }
    
    private func clearFiles() {
        selectedFiles.removeAll()
        fileResults.removeAll()
        selectedFileIndex = nil
        progress = 0.0
        totalProgress = 0.0
    }
    
    private func copyResults() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        
        var allResults: [String] = []
        for file in selectedFiles {
            if let results = fileResults[file] {
                allResults.append("\(NSLocalizedString("file_label", comment: "File label")): \(file.path)")
                if let size = results["Size"] {
                    allResults.append("\(NSLocalizedString("size_label", comment: "Size label")): \(size)")
                }
                if enableVersion, let version = results["Version"] {
                    allResults.append("\(NSLocalizedString("version_label", comment: "Version label")): \(version)")
                }
                if enableDate, let date = results["Date"] {
                    allResults.append("\(NSLocalizedString("modified_label", comment: "Modified label")): \(date)")
                }
                if enableMD5, let md5 = results["MD5"] {
                    allResults.append("\(NSLocalizedString("md5_label", comment: "MD5 label")): \(md5)")
                }
                if enableSHA1, let sha1 = results["SHA1"] {
                    allResults.append("\(NSLocalizedString("sha1_label", comment: "SHA1 label")): \(sha1)")
                }
                if enableCRC32, let crc32 = results["CRC32"] {
                    allResults.append("\(NSLocalizedString("crc32_label", comment: "CRC32 label")): \(crc32)")
                }
                allResults.append("") // Empty line between files
            }
        }
        
        pasteboard.setString(allResults.joined(separator: "\n"), forType: .string)
    }
    
    private func saveResults() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [UTType.plainText]
        panel.nameFieldStringValue = NSLocalizedString("default_filename", comment: "Default save filename")
        
        if panel.runModal() == .OK, let url = panel.url {
            var allResults: [String] = []
            for file in selectedFiles {
                if let results = fileResults[file] {
                    allResults.append("\(NSLocalizedString("file_label", comment: "File label")): \(file.path)")
                    if let size = results["Size"] {
                        allResults.append("\(NSLocalizedString("size_label", comment: "Size label")): \(size)")
                    }
                    if enableVersion, let version = results["Version"] {
                        allResults.append("\(NSLocalizedString("version_label", comment: "Version label")): \(version)")
                    }
                    if enableDate, let date = results["Date"] {
                        allResults.append("\(NSLocalizedString("modified_label", comment: "Modified label")): \(date)")
                    }
                    if enableMD5, let md5 = results["MD5"] {
                        allResults.append("\(NSLocalizedString("md5_label", comment: "MD5 label")): \(md5)")
                    }
                    if enableSHA1, let sha1 = results["SHA1"] {
                        allResults.append("\(NSLocalizedString("sha1_label", comment: "SHA1 label")): \(sha1)")
                    }
                    if enableCRC32, let crc32 = results["CRC32"] {
                        allResults.append("\(NSLocalizedString("crc32_label", comment: "CRC32 label")): \(crc32)")
                    }
                    allResults.append("") // Empty line between files
                }
            }
            
            try? allResults.joined(separator: "\n").write(to: url, atomically: true, encoding: .utf8)
        }
    }
    
    private func startCalculation() {
        guard !selectedFiles.isEmpty else { return }
        
        isCalculating = true
        // Only remove results for files that don't have results yet
        progress = 0.0
        totalProgress = 0.0
        
        Task {
            await calculateHashes()
        }
    }
    
    private func stopCalculation() {
        isCalculating = false
    }
    
    private func calculateHashes() async {
        let filesToCalculate = selectedFiles.filter { fileResults[$0] == nil }
        let totalFiles = filesToCalculate.count
        
        for (index, file) in filesToCalculate.enumerated() {
            guard isCalculating else { break }
            
            await MainActor.run {
                progress = 0.0
            }
            
            var results: [String: String] = [:]
            
            // Calculate file info
            let fileAttributes = try? FileManager.default.attributesOfItem(atPath: file.path)
            
            // File size
            if let size = fileAttributes?[.size] as? Int64 {
                results["Size"] = "\(size) \(NSLocalizedString("bytes_suffix", comment: "Bytes suffix"))"
            }
            
            if enableDate, let modificationDate = fileAttributes?[.modificationDate] as? Date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd, yyyy 'at' HH:mm:ss"
                results["Date"] = formatter.string(from: modificationDate)
            }
            
            if enableVersion {
                results["Version"] = "1.0.4.0"
            }
            
            // Calculate hashes
            if let data = try? Data(contentsOf: file) {
                var progressStep = 0.0
                let totalSteps = [enableMD5, enableSHA1, enableCRC32].filter { $0 }.count
                
                if enableMD5 {
                    let md5 = Insecure.MD5.hash(data: data)
                    results["MD5"] = md5.map { String(format: "%02X", $0) }.joined()
                    progressStep += 1.0 / Double(totalSteps)
                    await MainActor.run {
                        progress = progressStep
                    }
                }
                
                if enableSHA1 {
                    let sha1 = Insecure.SHA1.hash(data: data)
                    results["SHA1"] = sha1.map { String(format: "%02X", $0) }.joined()
                    progressStep += 1.0 / Double(totalSteps)
                    await MainActor.run {
                        progress = progressStep
                    }
                }
                
                if enableCRC32 {
                    let crc32 = calculateCRC32(data: data)
                    results["CRC32"] = String(format: "%08X", crc32)
                    progressStep += 1.0 / Double(totalSteps)
                    await MainActor.run {
                        progress = progressStep
                    }
                }
            }
            
            await MainActor.run {
                fileResults[file] = results
                totalProgress = Double(index + 1) / Double(totalFiles)
            }
        }
        
        await MainActor.run {
            isCalculating = false
        }
    }
    
    private func calculateCRC32(data: Data) -> UInt32 {
        let polynomial: UInt32 = 0xEDB88320
        var crc: UInt32 = 0xFFFFFFFF
        
        for byte in data {
            crc ^= UInt32(byte)
            for _ in 0..<8 {
                if crc & 1 != 0 {
                    crc = (crc >> 1) ^ polynomial
                } else {
                    crc >>= 1
                }
            }
        }
        
        return crc ^ 0xFFFFFFFF
    }
    
    private func handleDrop(providers: [NSItemProvider]) {
        var urls: [URL] = []
        
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                    if let data = item as? Data,
                       let url = URL(dataRepresentation: data, relativeTo: nil) {
                        urls.append(url)
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            selectedFiles.append(contentsOf: urls)
            selectedFileIndex = nil
            // Auto start calculation for new files
            startCalculation()
        }
    }
    
    private func formatFileSize(_ url: URL) -> String {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
              let size = attributes[.size] as? Int64 else {
            return NSLocalizedString("unknown_size", comment: "Unknown file size")
        }
        
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
}

#Preview {
    ContentView()
}

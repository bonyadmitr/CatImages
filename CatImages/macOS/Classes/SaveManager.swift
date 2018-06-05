//
//  SaveManager.swift
//  CatImages-macOS
//
//  Created by Bondar Yaroslav on 5/23/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Cocoa

final class SaveManager {
    
    /// Capabilities - File Access list - Pictures Folder - Read/Write
    /// type: png, jpg, etc..
    /// if type == nil it will be detected from data
    @discardableResult
    static func save(data: Data, name: String, type: String? = nil) throws -> URL {
        
//        let pictureDirectories = NSSearchPathForDirectoriesInDomains(.picturesDirectory, [.userDomainMask], true)
//        guard let pictureFolderPath = pictureDirectories.first else {
//            throw CustomErrors.system
//        }
        
        guard let pictureDirectoryUrl = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first else {
            throw CustomErrors.system
        }
        
        let catFolderUrl = pictureDirectoryUrl.appendingPathComponent("Cat Images")
        let pictureFolderPath = catFolderUrl.path
        
        /// with "withIntermediateDirectories: false" will fail with "file already exists"
        /// with "withIntermediateDirectories: true" will not clear folder and will not fail if it exists, so we don't need to check ourselfs by "fileExists" func
        try FileManager.default.createDirectory(atPath: pictureFolderPath,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
        
        
        
        let fileExtension = type ?? ImageFormat.get(from: data).imageTypeForSave
        
        let nameSuffix: String
        
        if let files = try? FileManager.default.contentsOfDirectory(atPath: pictureFolderPath) {
            let imagesWithName = files.filter({ $0.contains(name)})
            var numbers: [Int] = imagesWithName.compactMap { fileName in
                let startIndex = name.count + 1 /// 1 for _
                let endIndex = fileName.count - fileExtension.count - 1 /// 1 for .
                let numberStr = fileName[startIndex..<endIndex]
                if let n = Int(numberStr) {
                    return n + 1 /// 1 for next number
                }
                return 2
            }
            numbers.sort()
            print(numbers)
            print()
            
            if let last = numbers.last {
                nameSuffix = "_\(last)"
            } else {
                nameSuffix = "_1"
            }
            
        } else {
            nameSuffix = "_1"
        }
        
        let pictureUrl = URL(fileURLWithPath: "\(pictureFolderPath)/\(name)\(nameSuffix).\(fileExtension)")
        try data.write(to: pictureUrl)
        return pictureUrl
    }
    
    static func saveAs(data: Data, name: String, type: String? = nil,  handler: @escaping VoidCancelableResult) {
        /// error: caught non-fatal NSInternalInconsistencyException 'bridge absent' with backtrace
        /// Capabilities - File Access list - User Selected File - Read/Write
        /// https://stackoverflow.com/a/48248271
        ///
        /// https://developer.apple.com/library/content/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/UsingtheOpenandSavePanels/UsingtheOpenandSavePanels.html
        ///
        /// is not a supported subclass for sandboxing error
        let savePanel = NSSavePanel()
        
        /// https://stackoverflow.com/a/42857068
//        savePanel.allowedFileTypes = ["jpg", "png"]
//        savePanel.allowedFileTypes = NSImage.imageTypes
//        savePanel.allowsOtherFileTypes = true
        let fileExtension = type ?? ImageFormat.get(from: data).imageTypeForSave
        savePanel.nameFieldStringValue = "\(name).\(fileExtension)"
        
        /// string displayed in front of the filename text field
        //savePanel.nameFieldLabel = "nameFieldLabel"
        
        /// default button
        //savePanel.prompt = "savePanel.prompt"
        
        let savePanelCompletionHandler: (NSApplication.ModalResponse) -> Void = { result in
            switch result {
            case .OK: ///NSFileHandlingPanelOKButton or 
                guard let fileUrl = savePanel.url else {
                    handler(.failure(CustomErrors.system))
                    return
                }
                
                do {
                    try data.write(to: fileUrl)
                    handler(.success(()))
                } catch {
                    handler(.failure(error))
                }
                
            case .cancel:
                handler(.cancel)
            default:
                let errorString = "\(result), raw: \(result.rawValue)" 
                let error = CustomErrors.systemDebug(errorString)
                print("⚠️", error.localizedDescription)
                handler(.failure(error))
            }   
        }
        
        
        if let window = NSApplication.shared.mainWindow {
            savePanel.beginSheetModal(for: window, completionHandler: savePanelCompletionHandler)
        } else {
            savePanel.begin(completionHandler: savePanelCompletionHandler)
        }
        
        // TODO: WIDGET ONLY
        
        /// moves the window to the front, but below current front app
        /// here need for widget, to be hight than main app 
        savePanel.makeKeyAndOrderFront(nil)
        
        /// same as main app
        savePanel.keepOnTop = true
        
        /// make active for widget
        savePanel.becomeKey()
        
        /// can be used insted savePanel.begin
        ///let result = savePanel.runModal()
        
        ///savePanel.becomesKeyOnlyIfNeeded = true
        
        // TODO: check: don't need outside widget simulator
        NSApp.activate(ignoringOtherApps: true)
    }
}

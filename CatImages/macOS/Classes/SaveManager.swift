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
    static func saveImage(data: Data, name: String, type: String? = nil, folderName: String? = nil) throws -> URL {
        
        /// way to get picture directory path (not url!)
        //guard let path = NSSearchPathForDirectoriesInDomains(.picturesDirectory, [.userDomainMask], true).first
        guard let pictureDirectoryUrl = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first else {
            throw CustomErrors.system
        }
        
        let picturePath: String
        if let folderName = folderName {
            let catFolderUrl = pictureDirectoryUrl.appendingPathComponent(folderName)
            picturePath = catFolderUrl.path
            
            /// with "withIntermediateDirectories: false" will fail with "file already exists"
            /// with "withIntermediateDirectories: true" will not clear folder and will not fail if it exists, so we don't need to check ourselfs by "fileExists" func
            try FileManager.default.createDirectory(atPath: picturePath,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } else {
            picturePath = pictureDirectoryUrl.path
        }
        
        let fileExtension = type ?? ImageFormat.get(from: data).imageTypeForSave
        
        let suffixDivider = "_"
        let suffixNumber = suffixNumberFor(directoryPath: picturePath,
                                           baseFileName: name,
                                           fileExtension: fileExtension,
                                           suffixDivider: suffixDivider)
        let nameSuffix = "\(suffixDivider)\(suffixNumber)"
        
        let pictureUrl = URL(fileURLWithPath: "\(picturePath)/\(name)\(nameSuffix).\(fileExtension)")
        try data.write(to: pictureUrl)
        return pictureUrl
    }
    
    private static func suffixNumberFor(directoryPath: String, baseFileName: String, fileExtension: String, suffixDivider: String) -> Int {
        let startNumber = 1
        
        if let files = try? FileManager.default.contentsOfDirectory(atPath: directoryPath) {
            let sameNames = files.filter({ $0.contains(baseFileName)})
            var fileNameNumbers: [Int] = sameNames.compactMap { fileName in
                
                let fileSuffix = fileName[baseFileName.count ..< (baseFileName.count + suffixDivider.count)]
                
                if suffixDivider != fileSuffix {
                    return nil
                }
                
                let startIndex = baseFileName.count + suffixDivider.count
                let endIndex = fileName.count - fileExtension.count - 1 /// 1 for "." char
                let numberStr = fileName[startIndex ..< endIndex]
                
                
                if let n = Int(numberStr) {
                    return n + 1 /// 1 for next number
                }
                
                /// will call if we changed name saving rule. (ex: changed suffixConcat)
                return nil
            }
            fileNameNumbers.sort()
            print(fileNameNumbers)
            
            return fileNameNumbers.last ?? startNumber
        } else {
            return startNumber
        }
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

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
        
        let nameSuffix: String
        
        let suffixConcat = "_"
        
        if let files = try? FileManager.default.contentsOfDirectory(atPath: picturePath) {
            let imagesWithName = files.filter({ $0.contains(name)})
            var numbers: [Int] = imagesWithName.compactMap { fileName in
                
                let fileSuffix = fileName[name.count ..< (name.count + suffixConcat.count)]
                
                if suffixConcat != fileSuffix {
                    return nil
                }
                
                let startIndex = name.count + suffixConcat.count
                let endIndex = fileName.count - fileExtension.count - 1 /// 1 for "." char
                let numberStr = fileName[startIndex ..< endIndex]
                
                
                if let n = Int(numberStr) {
                    return n + 1 /// 1 for next number
                }
                
                /// will call if we changed name saving rule. (ex: change suffixConcat)
                return nil
            }
            numbers.sort()
            print(numbers)
            print()
            
            if let last = numbers.last {
                nameSuffix = "\(suffixConcat)\(last)"
            } else {
                nameSuffix = "\(suffixConcat)1"
            }
            
        } else {
            nameSuffix = "\(suffixConcat)1"
        }
        
        let pictureUrl = URL(fileURLWithPath: "\(picturePath)/\(name)\(nameSuffix).\(fileExtension)")
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

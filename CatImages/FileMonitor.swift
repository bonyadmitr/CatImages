//
//  FileMonitor.swift
//  CatImages-iOS
//
//  Created by Bondar Yaroslav on 7/12/18.
//  Copyright © 2018 Bondar Yaroslav. All rights reserved.
//

import Foundation

/// https://github.com/dagostini/DAFileMonitor
open class FileMonitor {
    
    private let filePath: String
    private let fileSystemEvent: DispatchSource.FileSystemEvent
    private let dispatchQueue: DispatchQueue
    private var eventSource: DispatchSourceFileSystemObject?
    
    public var onFileEvent: (() -> Void)? {
        willSet {
            eventSource?.cancel()
        }
        didSet {
            if onFileEvent != nil {
                startObservingFileChanges()
            }
        }
    }
    
    /// event .rename work for "move to trash"
    /// event .attrib called after file saving/observer added
    init?(withFilePath path: String, observeEvent event: DispatchSource.FileSystemEvent = [.rename, .delete], queue: DispatchQueue = DispatchQueue.global(), createFile create: Bool = false) {
        self.filePath = path
        self.fileSystemEvent = event
        self.dispatchQueue = queue
        
        /// createFileIfNeed
        if !isFileExists {
            if !create {
                return nil
            } else {
                createFile()
            }   
        }
    }
    
    deinit {
        eventSource?.cancel()
    }
    
    private var isFileExists: Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    private func createFile() {
        if !isFileExists {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
    }
    
    private func startObservingFileChanges() {
        guard isFileExists else {
            return
        }
        
        let descriptor = open(filePath, O_EVTONLY)
        if descriptor == -1 {
            return
        }
        
        eventSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: descriptor, eventMask: fileSystemEvent, queue: dispatchQueue)
        
        /// check!!!!
        //eventSource?.setEventHandler(handler: onFileEvent)
        eventSource?.setEventHandler { [weak self] in
            self?.onFileEvent?()
        }
        
        eventSource?.setCancelHandler() {
            close(descriptor)
        }
        
        eventSource?.resume()
    }
}

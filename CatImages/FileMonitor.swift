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
    
    init?(withFilePath path: String, observeEvent event: DispatchSource.FileSystemEvent, queue: DispatchQueue = DispatchQueue.global(), createFile create: Bool = false) {
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
    
    /// maybe can optimzied by create one eventSource
    private func startObservingFileChanges() {
        guard isFileExists else {
            return
        }
        
        let descriptor = open(filePath, O_EVTONLY)
        if descriptor == -1 {
            return
        }
        
        let newEventSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: descriptor, eventMask: fileSystemEvent, queue: dispatchQueue)

        newEventSource.setEventHandler(handler: onFileEvent)
        
        newEventSource.setCancelHandler() {
            close(descriptor)
        }
        
        newEventSource.resume()
        eventSource = newEventSource
    }
}

// TODO: need to check DirectoryMonitor
/// apple answer https://forums.developer.apple.com/thread/90531
/// + simple https://gist.github.com/mattlawer/3db21a1264afdca0314c7183143438bc
//class DirectoryMonitor {  
//    
//    typealias Delegate = DirectoryMonitorDelegate  
//    
//    init(directory: URL, matching typeIdentifier: String, requestedResourceKeys: Set<URLResourceKey>) {  
//        self.directory = directory  
//        self.typeIdentifier = typeIdentifier  
//        self.requestedResourceKeys = requestedResourceKeys  
//        self.actualResourceKeys = [URLResourceKey](requestedResourceKeys.union([.typeIdentifierKey]))  
//        self.contents = []  
//    }  
//    
//    let typeIdentifier: String  
//    let requestedResourceKeys: Set<URLResourceKey>  
//    private let actualResourceKeys: [URLResourceKey]  
//    let directory: URL  
//    
//    weak var delegate: Delegate? = nil  
//    
//    private(set) var contents: Set<URL>  
//    
//    fileprivate enum State {  
//        case stopped  
//        case started(dirSource: DispatchSourceFileSystemObject)  
//        case debounce(dirSource: DispatchSourceFileSystemObject, timer: Timer)  
//    }  
//    
//    private var state: State = .stopped  
//    
//    private static func source(for directory: URL) throws -> DispatchSourceFileSystemObject {  
//        let dirFD = open(directory.path, O_EVTONLY)  
//        guard dirFD >= 0 else {  
//            let err = errno  
//            throw NSError(domain: POSIXError.errorDomain, code: Int(err), userInfo: nil)  
//        }  
//        return DispatchSource.makeFileSystemObjectSource(  
//            fileDescriptor: dirFD,   
//            eventMask: [.write],   
//            queue: DispatchQueue.main  
//        )  
//    }  
//    
//    func start() throws {  
//        guard case .stopped = self.state else { fatalError() }  
//        
//        let dirSource = try DirectoryMonitor.source(for: self.directory)  
//        dirSource.setEventHandler {  
//            self.kqueueDidFire()  
//        }  
//        dirSource.resume()  
//        // We don't support `stop()` so there's no cancellation handler.  
//        // kqueue.source.setCancelHandler {   
//        //     _ = close(...)  
//        // }  
//        if #available(OSX 10.12, *) {
//            let nowTimer = Timer.scheduledTimer(withTimeInterval: 0.0, repeats: false) { _ in   
//                self.debounceTimerDidFire()  
//            }
//            self.state = .debounce(dirSource: dirSource, timer: nowTimer)
//        } else {
//            // Fallback on earlier versions
//        }  
//          
//    }  
//    
//    private func kqueueDidFire() {  
//        switch self.state {  
//        case .started(let dirSource):  
//            if #available(OSX 10.12, *) {
//                let timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in   
//                    self.debounceTimerDidFire()  
//                }
//                self.state = .debounce(dirSource: dirSource, timer: timer)
//            } else {
//                // Fallback on earlier versions
//            }  
//              
//        case .debounce(_, let timer):  
//            timer.fireDate = Date(timeIntervalSinceNow: 0.2)  
//        // Stay in the `.debounce` state.  
//        case .stopped:  
//            // This can happen if the read source fired and enqueued a block on the   
//            // main queue but, before the main queue got to service that block, someone   
//            // called `stop()`.  The correct response is to just do nothing.  
//            break  
//        }  
//    }  
//    
//    static func contents(of directory: URL, matching typeIdentifier: String, including: [URLResourceKey]) -> Set<URL> {  
//        guard let rawContents = try? FileManager.default.contentsOfDirectory(  
//            at: directory,   
//            includingPropertiesForKeys: including,   
//            options: [.skipsHiddenFiles]  
//            ) else {  
//                return []  
//        }  
//        let filteredContents = rawContents.filter { url in   
//            guard let v = try? url.resourceValues(forKeys: [.typeIdentifierKey]),  
//                let urlType = v.typeIdentifier else {  
//                    return false  
//            }  
//            return urlType == typeIdentifier  
//        }  
//        return Set(filteredContents)  
//    }  
//    
//    private func debounceTimerDidFire() {  
//        guard case .debounce(let dirSource, let timer) = self.state else { fatalError() }  
//        timer.invalidate()  
//        self.state = .started(dirSource: dirSource)  
//        
//        let newContents = DirectoryMonitor.contents(of: self.directory, matching: self.typeIdentifier, including: self.actualResourceKeys)  
//        let itemsAdded = newContents.subtracting(self.contents)  
//        let itemsRemoved = self.contents.subtracting(newContents)  
//        self.contents = newContents  
//        
//        if !itemsAdded.isEmpty || !itemsRemoved.isEmpty {  
//            self.delegate?.didChange(directoryMonitor: self, added: itemsAdded, removed: itemsRemoved)  
//        }  
//    }  
//    
//    func stop() {  
//        if !self.state.isRunning { fatalError() }  
//        // I don't need an implementation for this in the current project so   
//        // I'm just leaving it out for the moment.  
//        fatalError()  
//    }  
//}  
//
//fileprivate extension DirectoryMonitor.State {  
//    var isRunning: Bool {  
//        switch self {  
//        case .stopped:  return false  
//        case .started:  return true   
//        case .debounce: return true   
//        }  
//    }  
//}  
//
//protocol DirectoryMonitorDelegate : AnyObject {  
//    func didChange(directoryMonitor: DirectoryMonitor, added: Set<URL>, removed: Set<URL>)  
//}  


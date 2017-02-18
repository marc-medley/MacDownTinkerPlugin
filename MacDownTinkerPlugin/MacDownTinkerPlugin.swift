//
//  MacDownTinkerController.swift
//  MacDownTinkerPlugin
//
//  Created by --marc on 2017.02.15.
//  Copyright © 2017. All rights reserved.
//

import Cocoa

public class MacDownTinkerPlugin: NSObject {
    
    // MacDown Required
    let name: String = "Tinker! v0.1"
    
    // MacDown Required 
    public func run(_ sender: NSMenuItem) -> Bool {
        print("sender: \(sender)")        
        return doAutoEdit()
    }
    
    public func doAutoEdit() -> Bool {
        print("doAutoEdit()") 
        let dc = NSDocumentController.shared()
        print( "dc.currentDocument \(dc.currentDocument)")
        if let document: NSDocument = dc.currentDocument {
            print("document.displayName = \(document.displayName)")
            print("document.attributeKeys = \(document.attributeKeys)")
            
            print("document.value(forKey: String) ... ")
            if let displayName = document.value(forKey: "displayName") as? String {
                print("       displayName = \(displayName)")
            } 
            if let isDocumentEdited = document.value(forKey: "isDocumentEdited") as? Bool {
                print("  isDocumentEdited = \(isDocumentEdited)")
                // document.setValue(true, forKey: "isDocumentEdited") // FAIL
            } 
            
            if var markdown = document.value(forKey: "markdown") as? String {
                print("  markdown = \(markdown)")
                
                markdown.append("\n### Plugin added this line.\n")
                document.setValue(markdown, forKey: "markdown")
                // Note: document does not show as edited. no undo.
                // Note: must make an edit in the document for html to re-render, or View > Render HTML
            } 
            if let html = document.value(forKey: "html") as? String {
                print("  html = \(html)")
            } 
            
            if let scriptingProperties = document.value(forKey: "scriptingProperties") as? [String : AnyObject] {
                print("  scriptingProperties = \(scriptingProperties)")
            } 
            if let fileURL = document.value(forKey: "fileURL") as? URL {
                print("  fileURL = \(fileURL)")
                print("  fileURL.lastPathComponent = \(fileURL.lastPathComponent)")
            } 
            if let classCode = document.value(forKey: "classCode") as? Int {
                print("  classCode = \(classCode)")
            } 
            
            guard var markdown = document.value(forKey: "markdown") as? String else {
                return false
            }
            guard let fileUrl = document.value(forKey: "fileURL") as? URL else {
                return false
            }
            
            markdown.append("\n### Write to file. Document does not reload after writing to file. Document save may overwrite this change.\n")
            do {
                try markdown.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
                // Note: changes to fileUrl do not automatically load in MacDown.
            }
            catch {
                return false
            }

        }
        
        return true
    }

    
 
}

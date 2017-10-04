//
//  ViewController.swift
//  Screen Shot Sorter
//
//  Created by Thomas Holbrook on 04/10/2017.
//  Copyright © 2017 Thomas Holbrook. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    
    @IBOutlet weak var sourceFolder: NSTextField!
    @IBOutlet weak var destinationFolder: NSTextField!
    
    let dialog = NSOpenPanel();
    
    func selectFolder() {
    
        self.dialog.title = "Choose a folder";
        self.dialog.showsResizeIndicator = true;
        self.dialog.showsHiddenFiles = true;
        self.dialog.canChooseDirectories = true;
        self.dialog.canCreateDirectories = false;
        self.dialog.allowsMultipleSelection = false;
        self.dialog.canChooseFiles = false;
    }
    
    func moveScreenShots(path: String) -> Array<String> {
        let pathURL = NSURL(fileURLWithPath: path, isDirectory: true)
        var allFiles: [String] = []
        let fileManager = FileManager.default
        let pathString = path.replacingOccurrences(of: "file:", with: "")
        if let enumerator = fileManager.enumerator(atPath: pathString) {
            for file in enumerator {
                if let path = NSURL(fileURLWithPath: file as! String, relativeTo: pathURL as URL).path, path.hasSuffix(".png"){
                    if path.contains("Screen Shot") {

                        let fileNameArray = (path as NSString)
                        //print("Adding" + (fileNameArray as String))
                        allFiles.append(fileNameArray as String)

                    }
                    else {

                        //print("Skipping" + path + " As it is not called Screen Shot")
                        
                    }
                }
            }
        }
    return allFiles
    }
    
    @IBAction func selectSource(_ sender: Any) {
        
        selectFolder()

        if (self.dialog.runModal() == NSApplication.ModalResponse.OK) {
        
        let result = self.dialog.url
            if (result != nil) {
                let path = result!.path
                sourceFolder.stringValue = path
            }
        
            else {
                return
            }
        }
    }
    
    @IBAction func selectDestination(_ sender: Any) {
        
        selectFolder()
        
        if (self.dialog.runModal() == NSApplication.ModalResponse.OK) {
            
            let result = self.dialog.url
            if (result != nil) {
                let path = result!.path
                destinationFolder.stringValue = path
            }
                
            else {
                return
            }
        }
        
    }
    
    @IBAction func buttonGo(_ sender: Any) {
        let allFiles = moveScreenShots(path: sourceFolder.stringValue)
        let fileManager = FileManager.default
        for file in allFiles {
            do {
                let fileName = URL(fileURLWithPath : file).lastPathComponent as String
                try fileManager.moveItem(atPath: file, toPath: destinationFolder.stringValue + "/" + fileName)
            }
            catch let error as NSError {
                print("\(error.code)")
                if (error.code == 516) {
                    do {
                        let fileName = URL(fileURLWithPath : file).lastPathComponent as String
                        try fileManager.moveItem(atPath: file, toPath: destinationFolder.stringValue + "/Duplicate-" + fileName)
                    }
                    catch let error as NSError {
                        print("\(error.code)")
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


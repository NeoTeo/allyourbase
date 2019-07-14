//
//  StatusMenuController.swift
//  AllYourBase
//
//  Created by Teo Sartori on 18/03/2019.
//  Copyright © 2019 teos. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    var pasteBoardCheckTimer: Timer?
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    override func awakeFromNib() {
        statusItem.title = "[AllYourBase]"
        //        statusItem.image =
        statusItem.menu = statusMenu
        if pasteBoardCheckTimer == nil {
            pasteBoardCheckTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                
                let pb = NSPasteboard.general
                for element in pb.pasteboardItems! {
                    guard let str = element.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) else { return }
                    guard let val = Int(str) else {
                        self.statusItem.title = "NaN"
                        return
                    }
                    let hexstring = "0x\(String(val, radix: 16))"
                    self.statusItem.title = hexstring
                    
                }
            }
        }
    }
}

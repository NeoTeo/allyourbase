//
//  StatusMenuController.swift
//  AllYourBase
//
//  Created by Teo Sartori on 18/03/2019.
//  Copyright © 2019 teos. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    
    enum BaseType : RawRepresentable {
        case Hex
        case Dec
        case Bin
        
        var rawValue: (String, Int) {
            switch self {
            case .Hex: return ("hex:", 16)
            case .Dec: return ("dec:", 10)
            case .Bin: return ("bin:", 2)
            }
        }
        
        init?(rawValue: Self.RawValue) {
            switch rawValue {
            case ("hex:", 16): self = .Hex
            case ("dec:", 10): self = .Dec
            case ("bin:", 2): self = .Bin
            default: return nil
            }
        }
    }
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    var pasteBoardCheckTimer: Timer?
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var selectedBaseMenuItem: NSMenuItem?
    var selectedBaseType: BaseType?
    
    @IBAction func hexSelected(_ sender: Any) {
        mutexSelect(item: sender as? NSMenuItem)
        selectedBaseType = .Hex
        updateTitle()
    }
    
    @IBAction func decSelected(_ sender: Any) {
        mutexSelect(item: sender as? NSMenuItem)
        selectedBaseType = .Dec
        updateTitle()
    }
    
    @IBAction func binSelected(_ sender: Any) {
        mutexSelect(item: sender as? NSMenuItem)
        selectedBaseType = .Bin
        updateTitle()
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    func mutexSelect(item: NSMenuItem?) {
        selectedBaseMenuItem?.state = .off
        selectedBaseMenuItem = item
        selectedBaseMenuItem?.state = .on
    }
    
    func updateTitle() {
        guard self.selectedBaseType != nil else {
            print("selectedBaseType er nil")
            return
        }
        
        let pb = NSPasteboard.general
        for element in pb.pasteboardItems! {
            guard let str = element.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) else { return }
            guard let val = Int(str) else {
                self.statusItem.title = "NaN"
                return
            }
            let title = self.selectedBaseType?.rawValue.0 ?? "?"
            let value = String(val, radix: self.selectedBaseType?.rawValue.1 ?? 0)
            print("title; \(title) and \(value)")
            self.statusItem.title = title + value
        }
    }
    
    override func awakeFromNib() {
        statusItem.title = "[AllYourBase]"
        statusItem.menu = statusMenu
        
        if pasteBoardCheckTimer == nil {
            pasteBoardCheckTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                self.updateTitle()
            }
        }
    }
}

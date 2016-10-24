//
//  ViewController.swift
//  Mark
//
//  Created by Velislava Yanchina on 10/20/16.
//  Copyright © 2016 Velislava Yanchina. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

typealias ResourceTuple = (name: String, extension: String)

fileprivate enum Resources {
    static let step1Video = (name: "system_prefs_demo", extension: "mov")
    static let step2Video = (name: "key_bindings_demo", extension: "mov")
}

protocol NavigationItemProtocol {
    var title: String {get set}
}

fileprivate struct NavigationItem: NavigationItemProtocol{
    internal var title: String
 }
fileprivate struct HeaderNavigationItem : NavigationItemProtocol {
    internal var title: String
 }

class ViewController: NSViewController {

    @IBOutlet weak var sourceListView: NSOutlineView!
    @IBOutlet weak var step1VideoPlayer: AVPlayerView!
    @IBOutlet weak var step2VideoPlayer: AVPlayerView!
    
    fileprivate lazy var data = [HeaderNavigationItem(title: "HOW TO SETUP?"),
                                 NavigationItem(title: "Installation"),
                                 NavigationItem(title: "Key Bindings Setup")] as [Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()

/*        configurePlayer(playerView: step1VideoPlayer, with: Resources.step1Video)
        configurePlayer(playerView: step2VideoPlayer, with: Resources.step2Video) */
    }

    
    func configurePlayer(playerView: AVPlayerView, with resource: ResourceTuple) {
        let url = Bundle.main.url(forResource: resource.name, withExtension: resource.extension)!
        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        player.play()
        
        playerView.player = player
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loop(with:)),
                                               name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem!)
    }
    
    func loop(with notification: Notification) {
        let item = notification.object as! AVPlayerItem
        item.seek(to: kCMTimeZero)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    //MARK: NSOutlineViewDelegate
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let navigationItem = item as? NavigationItem {
            return configureCell(with: "DataCell", for: navigationItem)
        } else {
            return configureCell(with: "HeaderCell", for: (item as! HeaderNavigationItem))
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        return ((item as? NavigationItem) != nil)
    }
    
    func configureCell(with identifer: String, for item: NavigationItemProtocol) -> NSTableCellView? {
        var view: NSTableCellView?
        view = sourceListView.make(withIdentifier: identifer, owner: self) as? NSTableCellView
        if let textField = view?.textField {
            textField.stringValue = item.title
        }
        return view
    }

    //MARK: NSOutlineViewDataSource
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return self.data.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return self.data[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
}


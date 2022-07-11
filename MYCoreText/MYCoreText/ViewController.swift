//
//  ViewController.swift
//  MYCoreText
//
//  Created by MC on 2022/7/8.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        guard let file = Bundle.main.path(forResource: "zombies", ofType: "txt") else { return }
        do {
            let text = try String(contentsOfFile: file, encoding: .utf8)
            // 2
            let parser = MarkupParser()
            parser.parseMarkup(text)
            
            (view as? CTView)?.buildFrames(withAttrString: parser.attrString, andImages: parser.images)
            
        } catch _ {
        }
    }
}


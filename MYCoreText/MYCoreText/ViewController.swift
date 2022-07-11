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
        
//        // 1
//        guard let file = Bundle.main.path(forResource: "zombies", ofType: "txt") else { return }
//
//        do {
//          let text = try String(contentsOfFile: file, encoding: .utf8)
//          // 2
//          let parser = MarkupParser()
//          parser.parseMarkup(text)
//          (view as? CTView)?.importAttrString(parser.attrString)
//        } catch _ {
//        }

        
        let rect = CGRect(
            origin: CGPoint(x: 20, y: 100),
            size: CGSize(width: 300, height: 100)
        )
        let v = CTView(frame: rect)
        v.backgroundColor = UIColor.white
        self.view.addSubview(v)
    }


}


//
//  CTColumnView.swift
//  MYCoreText
//
//  Created by MC on 2022/7/11.
//

import UIKit
import CoreText

class CTColumnView: UIView {
  
  // MARK: - Properties
  var ctFrame: CTFrame!
  
  // MARK: - Initializers
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  required init(frame: CGRect, ctframe: CTFrame) {
    super.init(frame: frame)
    self.ctFrame = ctframe
    backgroundColor = .white
  }
  
  // MARK: - Life Cycle
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }
      
    context.textMatrix = .identity
    context.translateBy(x: 0, y: bounds.size.height)
    context.scaleBy(x: 1.0, y: -1.0)
      
    CTFrameDraw(ctFrame, context)
  }
}


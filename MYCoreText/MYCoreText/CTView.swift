//
//  CTView.swift
//  MYCoreText
//
//  Created by MC on 2022/7/8.
//


import UIKit
import CoreText

class CTView : UIScrollView {
    
    /// create 'CTColumnView' then add thme to scrollView
    func buildFrames(withAttrString attrString:NSAttributedString,
                     andImages images: [[String:Any]]){
        isPagingEnabled = true
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
         
        var pageView = UIView()
        var textPos = 0
        var columnIndex: CGFloat = 0
        var pageIndex: CGFloat = 0
        let settings = CTSettings()
        
        while textPos < attrString.length {
            /// first column on its page
            if columnIndex.truncatingRemainder(dividingBy: settings.columnsPerPage) == 0 {
                columnIndex = 0
                pageView = UIView(frame: settings.pageRect.offsetBy(dx: pageIndex*bounds.width, dy: 0))
                addSubview(pageView)
                pageIndex += 1
            }
            
            let columnXOrigin = pageView.frame.self.width / settings.columnsPerPage
            let columnOffset = columnIndex * columnXOrigin
            
            /// 'columnFrame' 'path' 'ctframe'
            // column View frame
            let columnFrame = settings.columnRect.offsetBy(dx: columnOffset, dy: 0)
            //  canvas frame
            let path = CGMutablePath()
            path.addRect(CGRect(origin: .zero, size: columnFrame.size))
            // text paragraph frame
            let ctframe = CTFramesetterCreateFrame(framesetter,
                                                   CFRangeMake(textPos, 0),
                                                   path,
                                                   nil)
            
            let column = CTColumnView(frame:columnFrame,
                                      ctframe: ctframe)
            pageView.addSubview(column)
            
            //
            let frameRange = CTFrameGetVisibleStringRange(ctframe)
            textPos += frameRange.length
            
            columnIndex += 1
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Flip the coordinate system
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: CGSize(width: 100, height: 50)))
        let attrString = NSAttributedString(string: "Hello World")
        
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)
        CTFrameDraw(frame, context)
    }
}

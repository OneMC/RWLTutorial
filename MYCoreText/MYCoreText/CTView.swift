//
//  CTView.swift
//  MYCoreText
//
//  Created by MC on 2022/7/8.
//


import UIKit
import CoreText

class CTView : UIScrollView {
    
    var imageIndex: Int!
    
    /// create 'CTColumnView' then add thme to scrollView
    func buildFrames(withAttrString attrString:NSAttributedString,
                     andImages images: [[String:Any]]){
        imageIndex = 0
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
            
            // 计算ctframe可以显示多少text内容;据说这里用中文会有问题
            let frameRange = CTFrameGetVisibleStringRange(ctframe)
            textPos += frameRange.length
            columnIndex += 1
            
            if images.count > imageIndex {
                attachImagesWithFrame(images, ctframe: ctframe, margin: settings.margin, columnView: column)
            }
        }
        
        contentSize = CGSize(width: CGFloat(pageIndex) * bounds.size.width, height: bounds.self.height)
    }
    
    func attachImagesWithFrame(_ images:[[String: Any]],
                               ctframe: CTFrame,
                               margin:CGFloat,
                               columnView:CTColumnView) {
        // ‘CTFrameGetLines’可以获得行数
        let lines = CTFrameGetLines(ctframe) as NSArray
        
        var origins = [CGPoint](repeating: .zero, count: lines.count)
        //
        CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), &origins)
        
        var nextImage = images[imageIndex]
        guard var imgLocation = nextImage["location"] as? Int else {
            return
        }
        
        for lineIndex in 0..<lines.count {
            let line = lines[lineIndex] as! CTLine
            
            if let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun],
               let imageFilename = nextImage["filename"] as? String,
               let img = UIImage(named: imageFilename) {
                for run in glyphRuns {
                    let runRange = CTRunGetStringRange(run)
                    if runRange.location > imgLocation ||
                        runRange.location + runRange.length <= imgLocation {
                        continue
                    }
                    
                    var imgBounds: CGRect = .zero
                    var ascent: CGFloat  = 0
                    // 获得图片的尺寸
                    imgBounds.size.width = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, nil, nil))
                    imgBounds.size.height = ascent
                    
                    // 获得line's xOffset
                    let xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil)
                    imgBounds.origin.x = origins[lineIndex].x + xOffset
                    imgBounds.origin.y = origins[lineIndex].y
                    
                    columnView.images += [(image:img,frame:imgBounds)]
                    
                    imageIndex! += 1
                    
                    if imageIndex < images.count {
                        nextImage = images[imageIndex]
                        imgLocation = (nextImage["location"] as AnyObject).intValue
                    }
                }
            }
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

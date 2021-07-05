//
//  Popup.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit

class Popup: NSControl {
    public var title: String {
        get { labelView.stringValue }
        set {
            labelView.stringValue = newValue
            needsLayout = true
        }
    }
    
    public var header: String? {
        get { headerLabel.stringValue }
        set {
            headerLabel.stringValue = newValue ?? ""
            if header == nil {
                headerLabel.removeFromSuperview()
            }
            needsLayout = true
        }
    }
    
    public var image: NSImage? {
        get { imageView.image }
        set {
            imageView.image = newValue
            needsLayout = true
        }
    }
    
    public override var alignment: NSTextAlignment {
        didSet {
            labelView.alignment = alignment
            headerLabel.alignment = alignment
        }
    }
    
    public override var font: NSFont? {
        didSet {
            labelView.font = font
            needsLayout = true
            needsDisplay = true
        }
    }
    
    public override var bounds: NSRect {
        didSet { needsDisplay = true }
    }
    
    private var state: NSControl.StateValue = .off {
        didSet {
            labelView.textColor = state == .off ? .controlTextColor : .controlTextColor.withSystemEffect(.pressed)
            needsDisplay = true
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        wantsLayer = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        needsDisplay = true
        setupViewHierarchy()
    }
    
    private enum Style { case sidebar, `default` }
    private var style: Style = .default {
        didSet {
            needsDisplay = true
            needsLayout = true
        }
    }
    
    public override var wantsUpdateLayer: Bool { true }
    public override func draw(_ dirtyRect: NSRect) { }
    
    // MARK: - Interaction
    override var acceptsFirstResponder: Bool { true }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        state = .on
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        state = .off
    }
    
    // MARK: - View hierarchy
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        
        if ascender(of: NSOutlineView.self) != nil {
            
        }
    }
    
    // MARK: - Layer
    override func updateLayer() {
        super.updateLayer()
        
        let bgColor = state == .off ? NSColor.clear : NSColor(white: 0, alpha: 0.1)
        layer?.backgroundColor = bgColor.cgColor
        layer?.borderColor = NSColor.separatorColor.cgColor
    }

    // MARK: - Subviews
    private let imageView = PopupImageView()
    private let headerLabel = NSTextField(labelWithString: "").configure {
        $0.lineBreakMode = .byTruncatingTail
        $0.font = .systemFont(ofSize: 10, weight: .semibold)
        $0.textColor = .tertiaryLabelColor
    }
    
    private let labelView = NSTextField(labelWithString: "").configure {
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let arrowsImageView = NSImageView().configure {
        var image = NSImage(named: "PopupArrows")!
        let symbolConfig = NSImage.SymbolConfiguration(pointSize: NSFont.systemFontSize, weight: .medium)
        image = image.withSymbolConfiguration(symbolConfig)!
        image.isTemplate = true
        
        $0.image = image
        $0.contentTintColor = .tertiaryLabelColor
    }
    
    private func setupViewHierarchy() {
        addSubview(imageView)
        addSubview(labelView)
        addSubview(arrowsImageView)
    }
    
    
    // MARK: - Layout
    override func layout() {
        super.layout()
        
        let gap: CGFloat = 4
        let innerFrame = bounds.insetBy(dx: 18, dy: 8)
        
        if header != nil && headerLabel.superview != self {
            addSubview(headerLabel)
        }
        
        let imageSize = CGSize(width: innerFrame.height, height: innerFrame.height)
        let imageY = innerFrame.minY
        
        let arrowSize = arrowsImageView.image?.size ?? .zero
        let arrowY = innerFrame.midY - arrowSize.height / 2
        
        let labelWidth = innerFrame.width - imageSize.width - gap - arrowSize.width - gap
        let labelSize = CGSize(width: labelWidth, height: labelView.intrinsicContentSize.height)
        
        let headerSize: CGSize
        if header != nil {
            headerSize = headerLabel.sizeThatFits(innerFrame.size)
        } else {
            headerSize = .zero
        }
        
        let labelsSize = CGSize(width: max(headerSize.width, labelSize.width), height: headerSize.height + labelSize.height)
        let labelsBottom = innerFrame.midY - labelsSize.height / 2
        let labelY = labelsBottom + 1
        let headerY = labelY + labelSize.height - 2
        
        if userInterfaceLayoutDirection == .leftToRight {
            imageView.frame = CGRect(
                origin: innerFrame.origin,
                size: imageSize
            )
            
            labelView.frame = CGRect(
                origin: CGPoint(x: imageView.frame.maxX + gap, y: labelY),
                size: labelSize
            )
            
            arrowsImageView.frame = CGRect(
                origin: CGPoint(x: innerFrame.maxX - arrowSize.width, y: arrowY),
                size: arrowSize
            )
            
            if header != nil {
                headerLabel.frame = CGRect(
                    origin: CGPoint(x: labelView.frame.minX, y: headerY),
                    size: headerSize
                )
            }
        } else {
            arrowsImageView.frame = CGRect(
                origin: CGPoint(x: innerFrame.minX, y: arrowY),
                size: arrowSize
            )
            
            imageView.frame = CGRect(
                origin: CGPoint(x: innerFrame.maxX - imageSize.width, y: imageY),
                size: imageSize
            )
            
            labelView.frame = CGRect(
                origin: CGPoint(x: imageView.frame.minX - gap - labelWidth, y: labelY),
                size: labelSize
            )
            
            if header != nil {
                headerLabel.frame = CGRect(
                    origin: CGPoint(x: labelView.frame.maxX - headerSize.width, y: headerY),
                    size: headerSize
                )
            }
        }
    }
}

class PopupImageView: ImageView {
    override func updateLayer() {
        super.updateLayer()
        layer?.cornerRadius = 4
        layer?.masksToBounds = true
        layer?.borderWidth = 1
        layer?.borderColor = NSColor.separatorColor.cgColor
    }
}

import SwiftUI

struct PopupView: NSViewRepresentable {
    let title: String
    let font: NSFont?
    
    init(title: String, font: NSFont? = nil) {
        self.title = title
        self.font = font
    }
    
    func makeNSView(context: Context) -> Popup {
        Popup().configure {
            $0.title = title
            $0.header = "Team"
            $0.image = Demo.image(named: "umur")
            $0.font = font
        }
    }
    
    func updateNSView(_ nsView: Popup, context: Context) { }
}

struct Popup_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                PopupView(title: "Testing")
                PopupView(title: "Some long title label here haha")
                PopupView(title: "Umur Gedik", font: .systemFont(ofSize: NSFont.systemFontSize, weight: .bold))
            }.frame(width: 250, height: 40).padding()
            
            NavigationView {
                List {
                    PopupView(title: "Testing")
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                    Text("Hello")
                }.listStyle(SidebarListStyle())
                
                Text("Hello world").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
    }
}

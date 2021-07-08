//
//  TaskCardView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import AppKit

public class TaskCardView: Background {
    // MARK: - State
    public var isSelected: Bool = false {
        didSet { updateSelectionUI() }
    }

    public func configure(with task: Task, coverImage: NSImage? = nil) {
        titleLabel.stringValue = task.title
        
        dueLabel.isHidden = task.dueDate == nil
        if let dueDate = task.dueDate {
            dueLabel.dueDate = dueDate
        }

        coverImageView.isHidden = coverImage == nil
        if let image = coverImage {
            coverImageView.image = image
        }
        
        needsLayout = true
    }
    
    // MARK: - View Hierarchy
    private var selectionView: TaskCardSelectionView?
    private let coverImageView = ImageView()
    private let dueLabel = TaskDueLabel()
    private let titleLabel = NSTextField(wrappingLabelWithString: "").configure {
        $0.isSelectable = false
        $0.font = .systemFont(ofSize: 14)
    }
    
    // public override var wantsDefaultClipping: Bool { false }

    public override func setupViewHierarchy() {
        cornerRadius = 4
        borderWidth = 1
        autoresizesSubviews = false
        
        coverImageView.isHidden = true
        dueLabel.isHidden = true
        
        addSubview(coverImageView)
        addSubview(dueLabel)
        addSubview(titleLabel)
    }
    
    public override func updateLayer() {
        super.updateLayer()
        if effectiveAppearance.name == .darkAqua {
            layer?.backgroundColor = NSColor.alternatingContentBackgroundColors[1].cgColor
            layer?.borderColor = NSColor.quaternaryLabelColor.withAlphaComponent(0.1).cgColor
        } else {
            layer?.backgroundColor = .white
            layer?.borderColor = NSColor.separatorColor.cgColor
        }
    }
    
    private func updateSelectionUI() {
        switch (isSelected, selectionView) {
        case (true, nil):
            let view = TaskCardSelectionView()
            animator().addSubview(view)
            selectionView = view
            needsLayout = true
            
        case let (false, view?):
            view.animator().removeFromSuperview()
            selectionView = nil
            
        default:
            return
        }
    }
    
    // MARK: - Layout
    private enum Metrics {
        static let contentInsets = NSEdgeInsets(top: 12, left: 16, bottom: 7, right: 16)
    }
    
    public override var isFlipped: Bool { true }
    public override func layout() {
        super.layout()
        
        if let selectionView = selectionView {
            selectionView.frame = bounds
        }
        
        var contentRect = bounds
        if !coverImageView.isHidden, let image = coverImageView.image {
            coverImageView.frame.origin = .zero
            coverImageView.frame.size = CGSize(
                width: bounds.width,
                height: bounds.width / (image.size.width / image.size.height)
            )
        
            contentRect = contentRect.consumeHeight(coverImageView.frame.size.height, isFlipped: true)
        }
        
        contentRect = contentRect.inset(by: Metrics.contentInsets, isFlipped: true)
        if !dueLabel.isHidden {
            dueLabel.sizeToFit()
            dueLabel.setFrameOrigin(contentRect.origin)
            dueLabel.frame.size.width = min(dueLabel.frame.width, contentRect.width)
        
            contentRect = contentRect.consumeHeight(dueLabel.bounds.height, isFlipped: true)
        } else {
            contentRect = contentRect.consumeHeight(6, isFlipped: true)
        }
        
        titleLabel.preferredMaxLayoutWidth = contentRect.width
        titleLabel.frame.origin = contentRect.origin
        titleLabel.frame.size = titleLabel.sizeThatFits(CGSize(width: contentRect.width, height: .greatestFiniteMagnitude))
    }
    
    public func heightForWidth(_ width: CGFloat) -> CGFloat {
        let contentWidth = width - Metrics.contentInsets.left - Metrics.contentInsets.right
        var height: CGFloat = 0
        if !coverImageView.isHidden, let image = coverImageView.image {
            let imageViewHeight = width / (image.size.width / image.size.height)
            height += imageViewHeight
        }
        
        height += Metrics.contentInsets.top
        if !dueLabel.isHidden {
            height += dueLabel.fittingSize.height
        } else {
            height += 6
        }
        
        titleLabel.preferredMaxLayoutWidth = contentWidth
        let titleSize = titleLabel.sizeThatFits(CGSize(width: contentWidth, height: .greatestFiniteMagnitude))
        height += titleSize.height + Metrics.contentInsets.bottom + 10
        return height
    }
}


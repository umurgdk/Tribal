//
//  ContextPickerViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 14.07.2021.
//

import AppKit

protocol ContextPickerDelegate: AnyObject {
    func contextPickerDidPickContext(_ context: EntityContext)
}

class ContextPickerViewController: BaseViewController {
    public weak var delegate: ContextPickerDelegate?
    
    lazy var pickerView = ContextPickerView()
    public override func loadView() {
        view = pickerView
    }
    
    public func setContexts(_ contexts: [EntityContext]) {
        pickerView.removeAllItemViews()
        
        contexts.enumerated().forEach { index, context in
            let itemView = ContextPickerItemView(context: context)
            itemView.onClick = { [weak self] in self?.contextItemViewDidClick(context) }
            pickerView.addContextItemView(itemView)
        }
    }
    
    public func selectContext(_ context: EntityContext) {
        pickerView.selectContext(context)
    }
    
    private func contextItemViewDidClick(_ context: EntityContext) {
        pickerView.selectContext(context)
        delegate?.contextPickerDidPickContext(context)
    }
}

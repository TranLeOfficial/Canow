//
//  RadioButtonGroup.swift
//  Canow
//
//  Created by TuanBM6 on 10/11/21.
//

import Foundation

protocol RadioButtonGroupDelegate: AnyObject {
    func groupChangeSelection(_ sender: RadioButtonGroup)
}

class RadioButtonGroup: RadioButtonDelegate, Equatable {
    static func == (lhs: RadioButtonGroup, rhs: RadioButtonGroup) -> Bool {
        return lhs === rhs
    }
    
    private(set) var radioButtonSelected: RadioButton?
    private(set) var idSelected: String?
    private(set) var groups = [(rb: RadioButton, id: String)]()
    private(set) var isEnabled = true
    weak var delegate: RadioButtonGroupDelegate?
    
    init(_ radioButtons: (rb: RadioButton, id: String)...) {
        radioButtons.forEach { (radioButton) in
            radioButton.rb.delegate = self
            self.groups.append(radioButton)
        }
    }
    
    func disable() {
        self.groups.forEach({ $0.rb.isEnabled = false })
        self.isEnabled = false
        self.radioButtonSelected?.selected = false
        self.radioButtonSelected = nil
        self.idSelected = nil
    }
    
    func enable() {
        self.groups.forEach({ $0.rb.isEnabled = true })
        self.isEnabled = true
    }
    
    func select(id: String) {
        for item in self.groups where item.id == id {
            changeSelect(item.rb)
        }
    }
    
    private func changeSelect(_ sender: RadioButton) {
        guard radioButtonSelected != sender else {
            return
        }
        self.radioButtonSelected?.selected = false
        self.radioButtonSelected = sender
        sender.selected = true
        for item in self.groups where item.rb == sender {
            self.idSelected = item.id
        }
        self.delegate?.groupChangeSelection(self)
    }
    
    func onClick(_ sender: RadioButton) {
        changeSelect(sender)
    }
}

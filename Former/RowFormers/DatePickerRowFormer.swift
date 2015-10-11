//
//  DatePickerRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol DatePickerFormableRow: FormableRow {
    
    func formDatePicker() -> UIDatePicker
}

public class DatePickerRowFormer<T: UITableViewCell where T: DatePickerFormableRow>
: CustomRowFormer<T>, FormValidatable {
    
    // MARK: Public
    
    public var onValidate: (NSDate -> Bool)?
    
    public var onDateChanged: (NSDate -> Void)?
    public var date: NSDate = NSDate()
    
    required public init(instantiateType: Former.InstantiateType = .Class, cellSetup: (T -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    deinit {
        cell.formDatePicker().removeTarget(self, action: "dateChanged:", forControlEvents: .ValueChanged)
    }
    
    public override func initialized() {
        super.initialized()
        cellHeight = 216.0
    }
    
    public override func cellInitialized(cell: T) {
        super.cellInitialized(cell)
        cell.formDatePicker().addTarget(self, action: "dateChanged:", forControlEvents: .ValueChanged)
    }
    
    public override func update() {
        super.update()
        
        cell.selectionStyle = .None
        let datePicker = cell.formDatePicker()
        datePicker.setDate(date, animated: false)
        datePicker.userInteractionEnabled = enabled
        datePicker.alpha = enabled ? 1.0 : 0.5
    }
    
    public func validate() -> Bool {
        return onValidate?(date) ?? true
    }
    
    // MARK: Private
    
    private dynamic func dateChanged(datePicker: UIDatePicker) {
        if enabled {
            let date = datePicker.date
            self.date = date
            onDateChanged?(date)
        }
    }
}
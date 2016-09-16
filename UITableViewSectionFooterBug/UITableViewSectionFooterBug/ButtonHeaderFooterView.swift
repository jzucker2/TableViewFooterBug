//
//  ButtonHeaderFooterView.swift
//  UITableViewSectionFooterBug
//
//  Created by Jordan Zucker on 9/16/16.
//  Copyright © 2016 Jordan Zucker. All rights reserved.
//

import UIKit

class ButtonHeaderFooterView: UITableViewHeaderFooterView {

    private let button: UIButton
    
    override init(reuseIdentifier: String?) {
        self.button = UIButton(type: .system)
        super.init(reuseIdentifier: reuseIdentifier)
        button.forceAutoLayout()
        contentView.addSubview(button)
        let views = [
            "button": button
        ]
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[button]-20-|", options: [], metrics: nil, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[button]-30-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraints)
        NSLayoutConstraint.activate(horizontalConstraints)
        contentView.setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        button.setTitle(nil, for: .normal)
        button.removeAllTargets()
    }
    
    func update(title: String, target: Any, action: Selector) {
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        contentView.setNeedsLayout()
    }
    
    class func height() -> CGFloat {
        return 70.0
    }

}

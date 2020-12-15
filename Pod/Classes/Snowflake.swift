//
//  Twitter: @MartinRogalla
//  EmaiL: email@martinrogalla.com
//
//  Created by Martin Rogalla.
//

import UIKit

class Snowflake: UIView {

    override init(frame : CGRect) {
        super.init(frame : frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.7)
        layer.cornerRadius = CGFloat(self.frame.width/2)
    }

    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}

//
//  OptionArgumentParseError.swift
//  Basic
//
//  Created by kyohei yamaguchi on 2019/04/02.
//

import Foundation
import Utility

struct OptionArgumentParseError<Kind>: Error, CustomStringConvertible {
    
    let target: OptionArgument<Kind>
    
    init(_ optionArgument: OptionArgument<Kind>) {
        self.target = optionArgument
    }
    
    var description: String {
        return "parse error: \(target)\n"
    }

}

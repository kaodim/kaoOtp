//
//  KaoInstruction.swift
//  KaoDesign
//
//  Created by sadman samee on 3/3/20.
//

import Foundation

public struct KaoInstruction {
    public var title: String
    public var message: String
    public var nextTitle: String
    public var flowIndex: Int
    

    public init(title: String,message: String,nextTitle: String,flowIndex: Int){
        self.title = title
        self.message = message
        self.nextTitle = nextTitle
        self.flowIndex = flowIndex
    }

}

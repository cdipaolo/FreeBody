//
//  FBButtonNode.swift
//  FreeBody
//
//  Created by Jackson Kearl on 12/30/14.
//  Copyright (c) 2014 Applications of Computer Science Club. All rights reserved.
//

import SpriteKit

class FBButtonNode: SKSpriteNode {
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }

    init(text:String, identifier:String, size:CGFloat) {
        super.init()
        let buttonText = SKLabelNode(fontNamed: "GillSans-Bold")
        buttonText.text = text
        buttonText.fontColor = FBColors.YellowBright
        buttonText.fontSize = size
        buttonText.verticalAlignmentMode = .Center

        let buttonBackground = SKShapeNode(rectOfSize: CGSizeMake( buttonText.frame.size.width + 5, buttonText.frame.height + 5))
        buttonBackground.fillColor = FBColors.Brown
        buttonBackground.lineWidth = 0

        let buttonResponder = SKSpriteNode(texture: nil, color: nil, size: buttonBackground.frame.size)
        buttonResponder.name = identifier

        buttonBackground.addChild(buttonText)
        buttonBackground.addChild(buttonResponder)

        self.addChild(buttonBackground)
        self.size = buttonBackground.frame.size

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

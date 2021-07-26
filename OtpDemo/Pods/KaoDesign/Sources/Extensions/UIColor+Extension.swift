//
//  UIColor+Extension.swift
//  KaodimIosDesign
//
//  Created by augustius cokroe on 23/07/2018.
//  Copyright © 2018 kaodim. All rights reserved.
//
// http://chir.ag/projects/name-that-color

import Foundation
import UIKit

public enum KaoColorHex: UInt {
    case linkWater = 0xE1EDF5
    case whiteLilac = 0xE6E7E8
    case whiteWildSand = 0xF4F4F4
    case chablis = 0xFFEFF1
    case bigStone = 0x12232E
    case midnight = 0x002340
    case prussianBlue = 0x003158
    case silver = 0xC0C0C0
    case curiousBlue = 0x3498DB
    case twilightBlue = 0xF8FFFF
    case altoSolid = 0xdbdbdb
    case alto = 0xD8D8D8
    case alto2 = 0xD9D9D9
    case dustyGray = 0x969696

    case hintOfGreen = 0xEBFFF3
    case azureRadiance = 0x007AFF
    case azureRadiance2 = 0x009FF8
    case opal = 0xA6BFBA
    case alabaster = 0xFAFAFA
    case sun = 0xFDB813
    case casper = 0xABC0CF

    case scorpion = 0x5A5A5A
    case mountainMeadow = 0x1ABC9C
    case aquaIsland = 0xA9D5DE
    case torchRed = 0xFF002A
    case cardinal = 0xC91634
    case shamRock = 0x2ECC71
    case jellyBean = 0x276F86
    case mercury = 0xE5E5E5
    case gableGreen = 0x13232E
    case dodgerBlue = 0x1E8CFF
    case flint = 0x707070
    case scarlet = 0xd0021b

    case brownishGrey = 0x636363
    case peacockBlue = 0x005e8d
    case whiteThree = 0xEEEEEE
    case boulder = 0x747474
    case mineShaft = 0x222222
    case bombay = 0xB6BAC2
    case oceanGreen = 0x4bb095
    case tradewind = 0x51ba9e
    case corn = 0xeac709
    case casablanca = 0xF9C647
    case cinnabar = 0xe3363b
    case carouselPink = 0xfbe8eb
    case red = 0xfb0000
    case hibiscus = 0xA51F7D
    case iron = 0xcecfd2
    case mischka = 0xdcdee6

    case grayChateau = 0x99a2a9
    case warningRed = 0xffe5e5
    case labelGray = 0xceced3
    case submarine = 0x879198
    case venetianRed = 0xD9002D
    case carrotOrange = 0xF1961C
    case dimGray = 0x6a6a6a
    case heather = 0xb7bdc2
    case gainsboro = 0xe0e0e0
    case grayStack = 0x8F8F8F
    case blueOnahau = 0xD1EDFF
    case salemGreen = 0x149E4F
    case blueAlice = 0xF0F9FF
    case blue = 0x0084FF
    case darkBlue = 0x223C63
    case grayFlat = 0xEFEFF4
    case emperor = 0x555555

    case crimson = 0xE3193A // kaodim_red
    case kaodimRed60 = 0xee7589
    case kaodimRed40 = 0xf4a3b0
    case kaodimRed20 = 0xf9d1d8
    case kaodimRed10 = 0xfde8eb
    case kaodimBrand = 0xed193a

    case textBlack = 0x000000
    case textDisable = 0xbbbbbb
    case black = 0x262626 // textDarkgrey
    case greyishBrown = 0x4a4a4a // textmidgrey
    case dustyGray2 = 0x9b9b9b // textlightgrey
    case veryLightPink = 0xf2f2f2 //bg_lightgrey
    case malachite = 0x11b958 // kaodim_green

    case kaodimGreen60 = 0x70d59b
    case kaodimGreen40 = 0xa0e3bc
	case dashedGrey = 0x979797
    case kaodimGreen20 = 0xcff1de
    case kaodimGreen10 = 0xe7f8ee
	case textGreen = 0x1e730b

    case vividBlue = 0x2692ee // kaodim_blue
    case kaodimBlue60 = 0x7dbef5
    case kaodimBlue40 = 0xa8d3f8
    case kaodimBlue20 = 0xd4e9fc
    case hawkesBlue = 0xe9f4fd // kaodim_blue_10
	case textBlue = 0x07468e
	
    case kaodimOrange = 0xf5a623
    case kaodimOrange60 = 0xf9ca7b
    case kaodimOrange40 = 0xfbdba7
    case kaodimOrange20 = 0xfdedd3
    case kaodimOrange10 = 0xfef6e9
	case textOrange = 0x8d5c0b
    case white = 0xffffff
    case errorRed = 0xee0000

    case textRed = 0xcc1616
    case textRed10 = 0xffe9f0

    case unavailableGray = 0xd6d6d6
    case borderGrey = 0xdddddd

    case disableBkgColor = 0xf5f5f5

    case cursorBlue = 0x426bf2
    case textBlue1 = 0x0852a6
    case tumbleweed = 0xdaba7f

    case kaodimPurpule = 0x5d56fe
    case kaodimTale = 0x11aa93
    case kaodimDeepOrange = 0xff774c
    case kaodimGold = 0xb78732

    case kaodimPurpule20 = 0xeaeafd
    case kaodimTale20 = 0xcfeee9
    case kaodimDeepOrange20 = 0xffe4db
    case kaodimGold20 = 0xfff1d7

    case coolGray = 0x889a9e

}

public extension UIColor {

    class func kaoColor(_ hex: KaoColorHex, alpha: CGFloat = 1.0) -> UIColor {
        return self.kaoColor(hex.rawValue, alpha: alpha)
    }

    class func kaoColor(_ customhex: UInt, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(
            red: CGFloat((customhex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((customhex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(customhex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }

    func as1ptImage() -> UIImage? { // get line with color
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    class func kaoColor(_ string: String, alpha: CGFloat = 1.0) -> UIColor {
       return UIColor.kaoColor(UInt(string.hashCode),alpha: alpha)
    }
}

public extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

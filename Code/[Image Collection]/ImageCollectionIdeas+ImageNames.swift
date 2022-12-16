//
//  ImageCollectionIdeas+ImageNames.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/11/22.
//

import Foundation

extension ImageCollectionIdeas {
    
    static func imageNames() -> [String] {
        let text = """
        IDEA_barbecue_ribs.png
        IDEA_cheese_wheel_slice.png
        IDEA_chipmunk_coffee.png
        IDEA_cow_face.png
        IDEA_doughnut.png
        IDEA_easter_bunny_baby.png
        IDEA_hot_pepper.png
        IDEA_m_m_s.png
        IDEA_maine_lobster.png
        IDEA_neon_tooth_brush.png
        IDEA_pacifier.png
        IDEA_piggy_bank.png
        IDEA_reeces_cup.png
        IDEA_skull_wig.png
        IDEA_snow_man_carrot_nose.png
        IDEA_steak.png
        IDEA_taped_banana.png
        IDEA_vegetable_tray.png
        IDEA_whopper_fries.png
        IDEA_wind_uo_teeth.png
        """
        
        return textToLines(imageListText: text)
    }
    
}

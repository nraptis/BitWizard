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
        IDEA_rice_krispies_box.png
        IDEA_bacon_strips.png
        IDEA_barbecue_ribs.png
        IDEA_birthday_hat.png
        IDEA_birthday_stuff.png
        IDEA_boquet_of_flowers_in_hand.png
        IDEA_burger_king.png
        IDEA_buttons.png
        IDEA_cake_wine.png
        IDEA_cannon_shot.png
        IDEA_cheese_wheel_slice.png
        IDEA_chipmunk_coffee.png
        IDEA_chocolate_buny.png
        IDEA_chocolate_cupcake_pink_frosting_cherry.png
        IDEA_chocolate_cupcake_white_frosting_sprinkles.png
        IDEA_chocolate_cupcake.png
        IDEA_christmas_village_decoration.png
        IDEA_cinnamon_bun.png
        IDEA_cocoa_puffs_bowl.png
        IDEA_cocoa_puffs_box.png
        IDEA_cocoa_puffs_on_spoon.png
        IDEA_cooked_meat.png
        IDEA_cough_syrup.png
        IDEA_count_chocula_dense.png
        IDEA_count_chocula_vampire.png
        IDEA_cow_face.png
        IDEA_dandelion_seeds_blowing.png
        IDEA_dirty_paint_brushes.png
        IDEA_disco_roller_skates.png
        IDEA_disney_castle_night.png
        IDEA_dog_with_hose.png
        IDEA_doughnut.png
        IDEA_egg_emojis.png
        IDEA_egg_mc_muffin.png
        IDEA_eggs_and_toast.png
        IDEA_ferris_wheel_neon.png
        IDEA_ferris_wheel.png
        IDEA_frosted_flakes_in_milk.png
        IDEA_frosted_flakes_on_spoon_in_milk.png
        IDEA_frosted_mini_wheats_bowl.png
        IDEA_frosted_mini_wheats_milk_pour.png
        IDEA_fruit_bowl_apples_cherries.png
        IDEA_fruit_bowl_oranges_kiwis.png
        IDEA_fruit_bowl_wire_apples_grapes.png
        IDEA_fruit_loops_box.png
        IDEA_fruit_loops_in_milk.png
        IDEA_fruit_loops_milk_pour.png
        IDEA_fruit_loops_on_spoon.png
        IDEA_gingerbread_macarons.png
        IDEA_gold_mickey_mouse.png
        IDEA_grilled_cheese.png
        IDEA_hamster_ball.png
        IDEA_harmonica.png
        IDEA_hostess_cupcake.png
        IDEA_hot_pepper.png
        IDEA_hotdogs_relish.png
        IDEA_inhaler.png
        IDEA_low_fuel.png
        IDEA_lucky_charms_box.png
        IDEA_lucky_charms_dense.png
        IDEA_lucky_charms_in_bowl_30_degree.png
        IDEA_lucky_charms_on_spoon.png
        IDEA_m_m_s.png
        IDEA_maine_lobster.png
        IDEA_mcdonalds_sign.png
        IDEA_mobile_airplanes_clouds.png
        IDEA_mushroom.png
        IDEA_musical_bar.png
        IDEA_neon_tooth_brush.png
        IDEA_paint_brush_and_paint_buckets.png
        IDEA_pinwheel.png
        IDEA_potted_cacti.png
        IDEA_rainbow_cupcake.png
        IDEA_reeces_cup.png
        IDEA_rice_krispies_in_red_bowl.png
        IDEA_rice_krispies_treats_stacked.png
        IDEA_roasted_bacon.png
        IDEA_roasted_turkey.png
        IDEA_roller_coaster_corkscrew.png
        IDEA_roller_coaster.png
        IDEA_santa_hat.png
        IDEA_scrambled_eggs_and_toast.png
        IDEA_snow_man_carrot_nose.png
        IDEA_snowglobe.png
        idea_steak_on_grill.png
        IDEA_steak.png
        IDEA_taped_banana.png
        IDEA_thanksgiving_dinner.png
        IDEA_toilet_paper_empty.png
        IDEA_toilet_paper_roll.png
        IDEA_toilet_paper_rolls.png
        IDEA_tooth_brush_with_paste.png
        IDEA_trix_bowl_30_degree.png
        IDEA_trix_bowl.png
        IDEA_trix_box.png
        IDEA_unisex_bathroom.png
        IDEA_vegetable_tray.png
        IDEA_whopper_fries.png
        IDEA_wind_uo_teeth.png
        IDEA_yarn_balls.png
        """
        
        return textToLines(imageListText: text)
    }
    
}

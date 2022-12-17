//
//  ImageCollectionWords+ImageNames.swift
//  BitWizard
//
//  Created by Nicky Taylor on 12/11/22.
//

import Foundation

extension ImageCollectionWords {
    
    static func imageNames() -> [String] {
        let text = """
        shield.png
        sub_way.png
        sheep.png
        season.png
        october.png
        napkin.png
        mouth.png
        mountain.png
        lettuce.png
        lasagna.png
        kitty.png
        karate.png
        island.png
        hill.png
        heat.png
        gong.png
        giraffe.png
        garage.png
        friday.png
        fork.png
        fish.png
        fiber.png
        feature.png
        energy.png
        driver.png
        damage.png
        cricket.png
        calendar.png
        buffet.png
        booklet.png
        bicycle.png
        bagel.png
        arm_chair.png
        active.png
        beard_trimmer.png
        blow_dart.png
        brain_surgery.png
        chemically_imbalanced.png
        diet.png
        useless.png
        10__juice.png
        banana_split.png
        birthday_hat.png
        carp_pond.png
        evidence.png
        fighting.png
        flag_pole.png
        modern.png
        possible.png
        always_ready.png
        awkward_silence.png
        big_foot.png
        calm.png
        sign_here.png
        back_pack.png
        class_clown.png
        cremation.png
        delay.png
        fruit_salad.png
        gummy_bear.png
        invite.png
        luggage.png
        viral.png
        bad_advice.png
        doing_nothing.png
        fact.png
        metal_bucket.png
        milky_way.png
        pony.png
        extra_calories.png
        m_m_s.png
        focus.png
        predict.png
        zone.png
        toast.png
        teeth.png
        surprise.png
        stove.png
        slime.png
        samurai.png
        salad.png
        red.png
        rainbow.png
        rain.png
        noodle.png
        mirror.png
        kale.png
        hobbies.png
        hamster.png
        garden.png
        feather.png
        farmer.png
        engine.png
        dew.png
        crayon.png
        chair.png
        broccoli.png
        beginner.png
        air_plane.png
        adult.png
        """
        return textToLines(imageListText: text)
    }
    
}

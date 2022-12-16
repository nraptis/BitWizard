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
        10__juice.png
        active.png
        adult.png
        air_plane.png
        always_ready.png
        arm_chair.png
        awkward_silence.png
        back_pack.png
        bad_advice.png
        bagel.png
        banana_split.png
        beard_trimmer.png
        beginner.png
        bicycle.png
        big_foot.png
        birthday_hat.png
        blow_dart.png
        booklet.png
        brain_surgery.png
        broccoli.png
        buffet.png
        calendar.png
        calm.png
        carp_pond.png
        chair.png
        chemically_imbalanced.png
        class_clown.png
        crayon.png
        cremation.png
        cricket.png
        damage.png
        delay.png
        dew.png
        diet.png
        doing_nothing.png
        driver.png
        energy.png
        engine.png
        evidence.png
        extra_calories.png
        fact.png
        farmer.png
        feather.png
        feature.png
        fiber.png
        fighting.png
        fish.png
        flag_pole.png
        focus.png
        fork.png
        friday.png
        fruit_salad.png
        garage.png
        garden.png
        giraffe.png
        gong.png
        gummy_bear.png
        hamster.png
        heat.png
        hill.png
        hobbies.png
        invite.png
        island.png
        kale.png
        karate.png
        kitty.png
        lasagna.png
        lettuce.png
        luggage.png
        m_m_s.png
        metal_bucket.png
        milky_way.png
        mirror.png
        modern.png
        mountain.png
        mouth.png
        napkin.png
        noodle.png
        october.png
        pony.png
        possible.png
        predict.png
        rain.png
        rainbow.png
        red.png
        salad.png
        samurai.png
        season.png
        sheep.png
        sign_here.png
        slime.png
        stove.png
        sub_way.png
        surprise.png
        teeth.png
        toast.png
        useless.png
        viral.png
        zone.png
        """
        return textToLines(imageListText: text)
    }
    
}

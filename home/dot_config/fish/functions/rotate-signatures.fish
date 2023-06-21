function rotate-signatures

    # Define an array with the data from the Perl script's __DATA__ section.
    set sigs "Off the record, on the QT, and very hush-hush." \
        "On second thought, let's not go to Camelot. It is a silly place." \
        "It's the wrong trousers Gromit, and they've gone wrong!" \
        "You know, for kids." \
        "Sir, are you classified as human?\nUhh, negative, I am a meat popsicle." \
        "They're techno trousers, ex-NASA, fantastic for walkies!" \
        "It does not do to leave a live Dragon out of your calculations.." \
        "Indifference will certainly be the downfall of mankind, but who cares?" \
        "( ( ( [ ] ) ) )\nIn Stereo Where\n   Available" \
        "Ya gotta love UNIX, where else do you wonder whether\nyou can kill a zombie spawned by a daemon's fork?" \
        "dd if=/dev/sarcasm of=/dev/clue" \
        "There is no emergency. Nothing to see here. Move along." \
        "Do not panic, do not panic! We are trained professionals!\nNow, stay calm. We are going around the leaf." \
        "A good messenger expects to get shot. --Larry Wall" \
        "Minds are like parachutes... they work best when open." \
        "It is dark. You are likely to be eaten by a grue." \
        "For every new fool-proof invention there is a new and improved fool." \
        "Hey, careful, man, there's a beverage here!" \
        "My pockets hurt. - Homer Simpson" \
        "You have the puzzle pieces? Good, then turn off the damn walls." \
        "This knob controls the thing that changes when you turn it. - noah" \
        "On a long enough timeline, the survival rate for everyone drops to zero." \
        "I'm really looking forward to this hangover." \
        "You can usually recover from production flaws...but you can never recover from a bad design" \
        "Welcome to hell. Here's your accordion." \
        "There was supposed to be a big kaboom." \
        "<ZangTT> berkeley db - it's mostly about the hash()" \
        "<weezyl> \$6.66: The Value Meal of the Beast." \
        "'It has become appallingly obvious that our technology has exceeded our humanity.' - Albert Einstein" \
        "<iNoah> I think someone should create a magazine for computer peripherals, called Card & Driver" \
        "<faisal> my life is collapsing to what will soon be NEGATIVE INTEGER degrees of separation." \
        "<iNoah> kernel's original recipe: 11 secret args and switches" \
        "<iNoah> my pdp goes to 11." \
        "<iNoah> all your base class are belong to us" \
        "<nil> It sucks to discover that you are the foremost authority on some set of things when you've got a problem." \
        "<iNoah> you know, most free operating systems come preinstalled with their own high horse." \
        "<dr.pox> wtf? a garbled dingbat makes java switch to DWIM?" \
        "<dr.pox> does whistling in the dark make me go blind faster?" \
        "<dr.pie> 31336.5: the neighbor of the l33t" \
        "'This basis of our government being the opinion of the people, the very first object should be to keep that right
\nand were it left to me to decided whether we should have a government without newspapers, or newspapers without a\ngovernment, I should not hesitate a moment to prefer the latter.' - Thomas Jefferson" \
        "<noah> the auto mechanic told me there was something wrong with my rear differential.\nI told him I never took calculus." \
        "<dr.pox> do they call it 'gq' because it makes your text fashionable?" \
        "<noah> I used to be indecisive, but now I'm not sure." \
        "<dr.pox> what're the units of the coefficient of agnosticity? I don't knows per hour?" \
        "<fuz> deregulation will lead to greater competition, consumer choice, and lower prices.\nmy name is elmer fudd. I own a mansion and a yacht." \
        "'They that can give up essential liberty to obtain a little temporary safety deserve neither liberty nor safety.' - Benjamin Franklin" \
        "<Nigel> Please refrain from fearing the reaper." \
        "vacation (n) : an extended trip away from home in search of inconvenient ways to connect to the Internet." \
        "<Djall> and I also learned that a meat vortex takes meat away from you." \
        "<weezyl> Oh, I cook bacon naked all the time. You just have to keep the heat on med-low." \
        "<dmercer> Because that is what our industry does.\nChurns out useless shit. Followed by inferior re-implementations of useless shit." \
        "Adobe Photoshop - When you want the truth. Real bad." \
        "'History, I believe, furnishes no example of a priest-ridden people \"maintaining a free civil government.\nThis marks the lowest grade of ignorance of which their civil as well as religious leaders will always\navail themselves for their own purposes.\"' --Thomas Jefferson to Alexander von Humboldt, 1813." \
        "<moof >I always think about the production machines when I think of olivia - because god, she has such a nice rackspace." \
        "<jwb >burning substations is manifestly the desire of the free market. hooray for utility deregulation\n <jwb >the government would never be able to set fires with such brutal efficiency" \
        "<jwb >if only a gigantic walking octopus would come along and strangle the entire nutjob religious right" \
        "<dr.pox >NO, NETBSD IS NOT REALLY BUILT WITH ELITE FORTRAN77!!@\$#\$" \
        "<jwb >"I am POWERBOOK thy god. Thou shalt have no other laptop before me"\n <gage >and the mountains shall drop sweet wine, and the hills shall melt" \
        "<Daemon >seriously, first there was the circle, then sliced bread, then tivo" \
        "<iNoah >one little two little three little-endians" \
        "<goldenmean >Today is the greatest day of my life. The amazon recommendation system has decided I should own Zardoz." \
        "<siva >fsck --harder --harder --like-you're-wrecking-ann-coulters-browneye" \
        "<weezyl> assfucking and margaritas and a soft place to land.\nIs that too much to ask? I SAY NO." \
        "<ren> I wanna be an anime girl with blue hair and huge tits and get fucked\nevery which way by a giant squid. now that sounds like a Monday" \
        "<goldenmean> The Self Deprecating Angle by the way is the name of my book about the plight of suicidal geometry." \
        "I like Florida. Everything is in the 80's. The temperatures, the ages and the IQ's. - George Carlin"

    # Get a random index.
    set rand_index (math (random) % (count $sigs))

    # Get a random signature and replace '\\n' with actual newlines.
    set rand_sig (string replace -r '\\n' '\n' $sigs[$rand_index])

    echo -e $rand_sig
end

rotate-signatures
